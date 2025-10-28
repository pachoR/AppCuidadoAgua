#import "Registro.h"

@implementation Registro

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.registroId = [dict[@"id"] integerValue];
        self.fechaRegistro = dict[@"fecha_registro"];
        self.cantidadConsumida = [dict[@"cantidad_consumida"] doubleValue];
    }
    return self;
}

- (instancetype)initWithId:(NSInteger)registroId fecha:(NSDate *)fecha cantidad:(double)cantidad {
    self = [super init];
    if (self) {
        self.registroId = registroId;
        self.fechaRegistro = fecha;
        self.cantidadConsumida = cantidad;
    }
    return self;
}

- (NSString *)description {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"Registro %ld: %.2f unidades - %@",
            (long)self.registroId,
            self.cantidadConsumida,
            [formatter stringFromDate:self.fechaRegistro]];
}

@end
