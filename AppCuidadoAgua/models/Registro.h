#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Registro : NSObject

@property (nonatomic, assign) NSInteger registroId;
@property (nonatomic, strong) NSDate *fechaRegistro;
@property (nonatomic, assign) double cantidadConsumida;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithId:(NSInteger)registroId fecha:(NSDate *)fecha cantidad:(double)cantidad;

@end

NS_ASSUME_NONNULL_END
