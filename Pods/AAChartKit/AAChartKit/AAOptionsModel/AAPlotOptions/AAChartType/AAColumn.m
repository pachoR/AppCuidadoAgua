//
//  AAColumn.m
//  AAChartKit
//
//  Created by An An on 17/1/5.
//  Copyright © 2017年 An An. All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 * 🌕 🌖 🌗 🌘  ❀❀❀   WARM TIPS!!!   ❀❀❀ 🌑 🌒 🌓 🌔
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/12302132/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */

#import "AAColumn.h"

@implementation AAColumn
    
- (instancetype)init {
    self = [super init];
    if (self) {
        _grouping = true;
    }
    return self;
}

AAPropSetFuncImplementation(AAColumn, NSString *,     name)
AAPropSetFuncImplementation(AAColumn, NSArray  *,     data)
AAPropSetFuncImplementation(AAColumn, NSString *,     color)
AAPropSetFuncImplementation(AAColumn, BOOL,           grouping)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     pointPadding)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     pointPlacement)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     groupPadding)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     borderWidth)
AAPropSetFuncImplementation(AAColumn, BOOL ,          colorByPoint)
AAPropSetFuncImplementation(AAColumn, AADataLabels *, dataLabels)
AAPropSetFuncImplementation(AAColumn, NSString *,     stacking)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     borderRadius)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     yAxis)
AAPropSetFuncImplementation(AAColumn, NSNumber *,     pointWidth) //柱形条的宽度
AAPropSetFuncImplementation(AAColumn, NSNumber *,     maxPointWidth) //柱形条的最大宽度
AAPropSetFuncImplementation(AAColumn, NSNumber *,     minPointLength) //柱形条的最小高度
AAPropSetFuncImplementation(AAColumn, AAStates *,     states)
AAPropSetFuncImplementation(AAColumn, BOOL      ,     allowPointSelect) //是否允许在点击数据点标记（markers）、柱子（柱形图）、扇区（饼图）时选中该点，选中的点可以通过 Chart.getSelectedPoints 来获取。 默认是：false.
AAPropSetFuncImplementation(AAColumn, id        ,     enableMouseTracking)

@end
