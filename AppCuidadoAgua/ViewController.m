//
//  ViewController.m
//  AppCuidadoAgua
//
//  Created by Alejandro Francisco Ruiz Guerrero on 27/10/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputLitters = 0;
    
    // Ejecutar las operaciones de base de dato
    NSLog(@"Start");
    [self realizarOperacionesBaseDeDatos];
}


- (IBAction)addingLitersStepper:(id)sender {
    NSLog(@"in");
    UIStepper *stepper = (UIStepper *)sender;
    self.inputLitters = (int)stepper.value;
    if (self.inputLitters < 0) {
        self.inputLitters = 0;
    }
    NSLog(@"%d", self.inputLitters);
    self.addedLitersLabel.text = [NSString stringWithFormat:@"%d L", self.inputLitters];
}


- (IBAction)addLits:(id)sender {
    NSLog(@"in");
    UIStepper *stepper = (UIStepper *)sender;
    self.inputLitters = (int)stepper.value;
    if (self.inputLitters < 1) {
        self.inputLitters = 1;
    }
    NSLog(@"%d", self.inputLitters);
    self.addedLitersLabel.text = [NSString stringWithFormat:@"%d L", self.inputLitters];
}

- (IBAction)addLitersButton:(id)sender {
    
}

- (IBAction)datePicker:(id)sender {
}

//kjhgfdsdfghjkjhgfdfghjk
- (void)realizarOperacionesBaseDeDatos {
    // Obtener instancia del DatabaseManager
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
    
    // 1. INSERTAR REGISTROS DE EJEMPLO
    NSLog(@"=== INSERTANDO REGISTROS ===");
    
    // Insertar registros con diferentes fechas y cantidades
    BOOL success1 = [dbManager insertRegistroWithCantidad:2.5 fecha:[NSDate date]];
    if (success1) {
        NSLog(@"✅ Registro 1 insertado: 2.5 unidades - fecha actual");
    } else {
        NSLog(@"❌ Error insertando registro 1");
    }
    
    // Crear fecha de ayer
    NSDate *ayer = [NSDate dateWithTimeIntervalSinceNow:-86400]; // 24 horas atrás
    BOOL success2 = [dbManager insertRegistroWithCantidad:1.8 fecha:ayer];
    if (success2) {
        NSLog(@"✅ Registro 2 insertado: 1.8 unidades - fecha de ayer");
    } else {
        NSLog(@"❌ Error insertando registro 2");
    }
    
    // Crear fecha de hace 2 días
    NSDate *hace2Dias = [NSDate dateWithTimeIntervalSinceNow:-172800]; // 48 horas atrás
    BOOL success3 = [dbManager insertRegistroWithCantidad:3.2 fecha:hace2Dias];
    if (success3) {
        NSLog(@"✅ Registro 3 insertado: 3.2 unidades - hace 2 días");
    } else {
        NSLog(@"❌ Error insertando registro 3");
    }
    
    // Insertar otro registro de hoy
    BOOL success4 = [dbManager insertRegistroWithCantidad:4.0 fecha:[NSDate date]];
    if (success4) {
        NSLog(@"✅ Registro 4 insertado: 4.0 unidades - fecha actual");
    } else {
        NSLog(@"❌ Error insertando registro 4");
    }
    
    // Pequeña pausa para asegurar que las inserciones se completen
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mostrarDatosBaseDeDatos];
    });
}

- (void)mostrarDatosBaseDeDatos {
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
    
    // 2. OBTENER TODOS LOS REGISTROS
    NSLog(@"\n=== TODOS LOS REGISTROS ===");
    NSArray *todosLosRegistros = [dbManager getAllRegistros];
    
    if (todosLosRegistros.count > 0) {
        for (NSDictionary *registro in todosLosRegistros) {
            NSInteger registroId = [registro[@"id"] integerValue];
            double cantidad = [registro[@"cantidad_consumida"] doubleValue];
            NSDate *fecha = registro[@"fecha_registro"];
            
            // Formatear fecha para mostrar
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *fechaString = [dateFormatter stringFromDate:fecha];
            
            NSLog(@"📝 ID: %ld | Cantidad: %.2f | Fecha: %@",
                  (long)registroId, cantidad, fechaString);
        }
    } else {
        NSLog(@"📭 No hay registros en la base de datos");
    }
    
    // 3. OBTENER REGISTROS DE HOY
    NSLog(@"\n=== REGISTROS DE HOY ===");
    NSArray *registrosHoy = [dbManager getRegistrosByDate:[NSDate date]];
    
    if (registrosHoy.count > 0) {
        for (NSDictionary *registro in registrosHoy) {
            NSInteger registroId = [registro[@"id"] integerValue];
            double cantidad = [registro[@"cantidad_consumida"] doubleValue];
            NSDate *fecha = registro[@"fecha_registro"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *horaString = [dateFormatter stringFromDate:fecha];
            
            NSLog(@"🕐 ID: %ld | Cantidad: %.2f | Hora: %@",
                  (long)registroId, cantidad, horaString);
        }
    } else {
        NSLog(@"📭 No hay registros para hoy");
    }
    
    // 4. OBTENER TOTAL CONSUMIDO HOY
    NSLog(@"\n=== TOTALES ===");
    double totalHoy = [dbManager getTotalConsumidoHoy];
    NSLog(@"💰 Total consumido hoy: %.2f unidades", totalHoy);
    
    // 5. OBTENER REGISTROS POR RANGO DE FECHAS
    NSLog(@"\n=== REGISTROS POR RANGO DE FECHAS ===");
    
    // Crear rango de fechas (últimos 3 días)
    NSDate *hoy = [NSDate date];
    NSDate *hace3Dias = [NSDate dateWithTimeIntervalSinceNow:-259200]; // 72 horas atrás
    
    NSArray *registrosRango = [dbManager getRegistrosFromDate:hace3Dias toDate:hoy];
    
    if (registrosRango.count > 0) {
        for (NSDictionary *registro in registrosRango) {
            NSInteger registroId = [registro[@"id"] integerValue];
            double cantidad = [registro[@"cantidad_consumida"] doubleValue];
            NSDate *fecha = registro[@"fecha_registro"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *fechaString = [dateFormatter stringFromDate:fecha];
            
            NSLog(@"📊 ID: %ld | Cantidad: %.2f | Fecha: %@",
                  (long)registroId, cantidad, fechaString);
        }
    }
    
    // 6. OBTENER TOTAL POR RANGO DE FECHAS
    double totalRango = [dbManager getTotalConsumidoFromDate:hace3Dias toDate:hoy];
    NSLog(@"💰 Total últimos 3 días: %.2f unidades", totalRango);
    
    // 7. EJEMPLO DE ACTUALIZACIÓN Y ELIMINACIÓN
    NSLog(@"\n=== OPERACIONES ADICIONALES ===");
    
    // Actualizar el primer registro si existe
    if (todosLosRegistros.count > 0) {
        NSDictionary *primerRegistro = todosLosRegistros[0];
        NSInteger primerId = [primerRegistro[@"id"] integerValue];
        
        BOOL updateSuccess = [dbManager updateRegistro:primerId cantidad:5.0 fecha:[NSDate date]];
        if (updateSuccess) {
            NSLog(@"✏️ Registro ID %ld actualizado a 5.0 unidades", (long)primerId);
        }
        
        // Mostrar registros después de la actualización
        NSArray *registrosActualizados = [dbManager getAllRegistros];
        NSLog(@"📊 Total de registros después de operaciones: %ld", (long)registrosActualizados.count);
    }
}
@end
