//
//  ViewController.h
//  AppCuidadoAgua
//
//  Created by Alejandro Francisco Ruiz Guerrero on 27/10/25.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property int inputLitters;

- (IBAction)addingLitersStepper:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addedLitersLabel;
- (IBAction)datePicker:(id)sender;

@end

