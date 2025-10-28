//
//  ViewController.m
//  AppCuidadoAgua
//
//  Created by Alejandro Francisco Ruiz Guerrero on 27/10/25.
//

#import "ViewController.h"
#import "AAChartKit/AAChartKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputLitters = 0;
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
@end
