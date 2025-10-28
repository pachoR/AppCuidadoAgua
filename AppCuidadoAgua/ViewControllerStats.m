//
//  ViewControllerStats.m
//  AppCuidadoAgua
//
//  Created by Alejandro Francisco Ruiz Guerrero on 27/10/25.
//

#import "ViewControllerStats.h"
@import AAChartKit;

@interface ViewControllerStats ()
@property (nonatomic, strong) AAChartView *chartView;
@end

@implementation ViewControllerStats

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chartView = [[AAChartView alloc] init];
    self.chartView.frame = self.chartContainerView.bounds;
    self.chartView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.chartContainerView addSubview:self.chartView];
    
    // Configure the chart model
    AAChartModel *chartModel = AAChartModel.new
    .chartTypeSet(AAChartTypeAreaspline)
    .titleSet(@"Water Usage Statistics")
    .subtitleSet(@"By Month")
    .categoriesSet(@[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun"])
    .seriesSet(@[
        AASeriesElement.new
        .nameSet(@"Water Usage")
        .dataSet(@[@7.0, @6.9, @9.5, @14.5, @18.2, @21.5])
        .colorSet(@"#1E90FF")
    ]);
    
    // Draw the chart
    [self.chartView aa_drawChartWithChartModel:chartModel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
