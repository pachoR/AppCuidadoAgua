#import "DatabaseManager.h"

@interface DatabaseManager()
@property (nonatomic, assign) sqlite3 *database;
@property (nonatomic, strong) NSString *databasePath;
@end

@implementation DatabaseManager

+ (instancetype)sharedInstance {
    static DatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance createDatabaseIfNeeded];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDatabasePath];
    }
    return self;
}

- (void)setupDatabasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    self.databasePath = [documentsDirectory stringByAppendingPathComponent:@"registros.db"];
}

- (BOOL)createDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.databasePath]) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"registros" ofType:@"db"];
        if (bundlePath) {
            NSError *error;
            [fileManager copyItemAtPath:bundlePath toPath:self.databasePath error:&error];
            if (error) {
                NSLog(@"Error copying database: %@", error.localizedDescription);
                return NO;
            }
        }
    }
    
    if (sqlite3_open([self.databasePath UTF8String], &_database) == SQLITE_OK) {
        NSLog(@"Database opened successfully");
        [self createTables];
        return YES;
    } else {
        NSLog(@"Failed to open database");
        return NO;
    }
}

- (void)createTables {
    const char *createTableSQL = "CREATE TABLE IF NOT EXISTS registros ("
                                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                                "fecha_registro DATE NOT NULL, "
                                "cantidad_consumida REAL NOT NULL);";
    
    char *errorMessage;
    if (sqlite3_exec(self.database, createTableSQL, NULL, NULL, &errorMessage) != SQLITE_OK) {
        NSLog(@"Error creating table: %s", errorMessage);
        sqlite3_free(errorMessage);
    } else {
        NSLog(@"Table 'registros' created successfully");
    }
}

#pragma mark - CRUD Operations

- (NSArray *)getAllRegistros {
    NSMutableArray *registros = [NSMutableArray array];
    const char *query = "SELECT id, fecha_registro, cantidad_consumida FROM registros ORDER BY fecha_registro DESC";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, query, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSDictionary *registro = [self registroFromStatement:statement];
            if (registro) {
                [registros addObject:registro];
            }
        }
        sqlite3_finalize(statement);
    }
    
    return [registros copy];
}

- (NSArray *)getRegistrosByDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSMutableArray *registros = [NSMutableArray array];
    const char *query = "SELECT id, fecha_registro, cantidad_consumida FROM registros WHERE date(fecha_registro) = ? ORDER BY fecha_registro DESC";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, query, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSDictionary *registro = [self registroFromStatement:statement];
            if (registro) {
                [registros addObject:registro];
            }
        }
        sqlite3_finalize(statement);
    }
    
    return [registros copy];
}

- (NSArray *)getRegistrosFromDate:(NSDate *)fechaInicio toDate:(NSDate *)fechaFin {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fechaInicioString = [dateFormatter stringFromDate:fechaInicio];
    NSString *fechaFinString = [dateFormatter stringFromDate:fechaFin];
    
    NSMutableArray *registros = [NSMutableArray array];
    const char *query = "SELECT id, fecha_registro, cantidad_consumida FROM registros WHERE date(fecha_registro) BETWEEN ? AND ? ORDER BY fecha_registro DESC";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, query, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [fechaInicioString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [fechaFinString UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSDictionary *registro = [self registroFromStatement:statement];
            if (registro) {
                [registros addObject:registro];
            }
        }
        sqlite3_finalize(statement);
    }
    
    return [registros copy];
}

- (BOOL)insertRegistroWithCantidad:(double)cantidad fecha:(NSDate *)fecha {
    const char *insertSQL = "INSERT INTO registros (fecha_registro, cantidad_consumida) VALUES (?, ?)";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fechaString = [dateFormatter stringFromDate:fecha];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, insertSQL, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [fechaString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement, 2, cantidad);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_finalize(statement);
            return YES;
        } else {
            NSLog(@"Error inserting registro: %s", sqlite3_errmsg(self.database));
        }
        sqlite3_finalize(statement);
    }
    return NO;
}

- (BOOL)updateRegistro:(NSInteger)registroId cantidad:(double)cantidad fecha:(NSDate *)fecha {
    const char *updateSQL = "UPDATE registros SET fecha_registro = ?, cantidad_consumida = ? WHERE id = ?";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fechaString = [dateFormatter stringFromDate:fecha];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, updateSQL, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [fechaString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement, 2, cantidad);
        sqlite3_bind_int(statement, 3, (int)registroId);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_finalize(statement);
            return YES;
        }
        sqlite3_finalize(statement);
    }
    return NO;
}

- (BOOL)deleteRegistro:(NSInteger)registroId {
    const char *deleteSQL = "DELETE FROM registros WHERE id = ?";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database, deleteSQL, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, (int)registroId);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_finalize(statement);
            return YES;
        }
        sqlite3_finalize(statement);
    }
    return NO;
}

#pragma mark - Total Methods

- (double)getTotalConsumidoHoy {
    return [self getTotalConsumidoEnFecha:[NSDate date]];
}

- (double)getTotalConsumidoEnFecha:(NSDate *)fecha {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fechaString = [dateFormatter stringFromDate:fecha];
    
    const char *query = "SELECT SUM(cantidad_consumida) FROM registros WHERE date(fecha_registro) = ?";
    
    sqlite3_stmt *statement;
    double total = 0.0;
    
    if (sqlite3_prepare_v2(self.database, query, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [fechaString UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            total = sqlite3_column_double(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    
    return total;
}

- (double)getTotalConsumidoFromDate:(NSDate *)fechaInicio toDate:(NSDate *)fechaFin {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fechaInicioString = [dateFormatter stringFromDate:fechaInicio];
    NSString *fechaFinString = [dateFormatter stringFromDate:fechaFin];
    
    const char *query = "SELECT SUM(cantidad_consumida) FROM registros WHERE date(fecha_registro) BETWEEN ? AND ?";
    
    sqlite3_stmt *statement;
    double total = 0.0;
    
    if (sqlite3_prepare_v2(self.database, query, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [fechaInicioString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [fechaFinString UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            total = sqlite3_column_double(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    
    return total;
}

#pragma mark - Helper Methods

- (NSDictionary *)registroFromStatement:(sqlite3_stmt *)statement {
    NSInteger registroId = sqlite3_column_int(statement, 0);
    const char *fechaChars = (const char *)sqlite3_column_text(statement, 1);
    double cantidad = sqlite3_column_double(statement, 2);
    
    if (fechaChars == NULL) {
        return nil;
    }
    
    NSString *fechaString = [NSString stringWithUTF8String:fechaChars];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fecha = [dateFormatter dateFromString:fechaString];
    
    return @{
        @"id": @(registroId),
        @"fecha_registro": fecha ?: [NSDate date],
        @"cantidad_consumida": @(cantidad)
    };
}

- (void)dealloc {
    if (self.database) {
        sqlite3_close(self.database);
    }
}

@end
