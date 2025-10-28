#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

+ (instancetype)sharedInstance;
- (BOOL)createDatabaseIfNeeded;

- (NSArray *)getAllRegistros;
- (NSArray *)getRegistrosByDate:(NSDate *)date;
- (NSArray *)getRegistrosFromDate:(NSDate *)fechaInicio toDate:(NSDate *)fechaFin;
- (BOOL)insertRegistroWithCantidad:(double)cantidad fecha:(NSDate *)fecha;
- (BOOL)updateRegistro:(NSInteger)registroId cantidad:(double)cantidad fecha:(NSDate *)fecha;
- (BOOL)deleteRegistro:(NSInteger)registroId;
- (double)getTotalConsumidoHoy;
- (double)getTotalConsumidoEnFecha:(NSDate *)fecha;
- (double)getTotalConsumidoFromDate:(NSDate *)fechaInicio toDate:(NSDate *)fechaFin;

@end

NS_ASSUME_NONNULL_END
