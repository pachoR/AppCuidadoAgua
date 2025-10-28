//
//  ViewController.h
//  AppCuidadoAgua
//
//  Created by Alejandro Francisco Ruiz Guerrero on 27/10/25.
//

#import <UIKit/UIKit.h>
#import "Database/DatabaseManager.h"

@interface ViewController : UIViewController

@property int inputLitters;

- (IBAction)addingLitersStepper:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addedLitersLabel;
- (IBAction)datePicker:(id)sender;
- (IBAction)addLitersButton:(id)sender;

- (void)realizarOperacionesBaseDeDatos;
- (void)mostrarDatosBaseDeDatos;

@end

