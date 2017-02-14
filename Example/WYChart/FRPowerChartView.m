//
//  FRPowerChartView.m
//  WYChart
//
//  Created by JoseChen on 2017/2/14.
//  Copyright © 2017年 FreedomKing. All rights reserved.
//

#import "FRPowerChartView.h"
#import "WYLineChartCalculator.h"
#import "WYLineChartPoint.h"
#import "WYLineChartView.h"

@interface FRPowerChartView ()<WYLineChartViewDelegate,WYLineChartViewDatasource>

@property (nonatomic, strong) WYLineChartView *chartView;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) NSMutableArray *numberArray;
@property (nonatomic, strong) UILabel *touchLabel;

@end

@implementation FRPowerChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initChartView];
        [self updateGraph];
    }
    return self;
}

- (void)initChartView{
    _chartView = [[WYLineChartView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) ,CGRectGetHeight(self.frame))];
    _chartView.delegate = self;
    _chartView.datasource = self;
    _chartView.points = [NSArray arrayWithArray:_points];
    _chartView.animationDuration = roundf(0.2);
    _chartView.animationStyle = kWYLineChartNoneAnimation;
    _chartView.backgroundColor = [UIColor colorWithRed:12.f/255.f green:71.f/255.f blue:98.f/255.f alpha:0.6];
    _chartView.scrollable = true;
    _chartView.pinchable = false;
    _chartView.touchPointColor = [UIColor redColor];
    
    _chartView.yAxisHeaderPrefix = @"(mA)";
    _chartView.yAxisHeaderSuffix = @"Time";
    
    _chartView.labelsFont = [UIFont systemFontOfSize:13];
    
    _chartView.verticalReferenceLineColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _chartView.horizontalRefernenceLineColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _chartView.axisColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _chartView.labelsColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    _touchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _touchLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    _touchLabel.textColor = [UIColor blackColor];
    _touchLabel.layer.cornerRadius = 5;
    _touchLabel.layer.masksToBounds = YES;
    _touchLabel.textAlignment = NSTextAlignmentCenter;
    _touchLabel.font = [UIFont systemFontOfSize:13.f];
    _chartView.touchView = _touchLabel;
    
    [self addSubview:_chartView];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

}

- (void)updateGraph {
    
    self.numberArray = [NSMutableArray new];
    for (int i = 0 ; i < 30 ; i++) {
        [_numberArray addObject:[NSNumber numberWithInteger:((30*i)%300)]];
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *points = [WYLineChartPoint pointsFromValueArray:_numberArray];
    [mutableArray addObject:points];
    points = [WYLineChartPoint pointsFromValueArray:@[@0]];
    _points = mutableArray;
    _chartView.points = [NSArray arrayWithArray:_points];
    
    [_chartView updateGraph];
}

- (void)onTimer
{
    [_numberArray addObject:@30];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *points = [WYLineChartPoint pointsFromValueArray:_numberArray];
    [mutableArray addObject:points];
    points = [WYLineChartPoint pointsFromValueArray:@[@0]];
    _points = mutableArray;
    _chartView.points = [NSArray arrayWithArray:_points];
    
    [_chartView updateGraph];
}


#pragma mark - WYLineChartViewDelegate

- (NSInteger)numberOfLabelOnXAxisInLineChartView:(WYLineChartView *)chartView {
    
    return [_points[0] count];
}

- (NSInteger)numberOfLabelOnYAxisInLineChartView:(WYLineChartView *)chartView {
    return 3;
}

- (CGFloat)gapBetweenPointsHorizontalInLineChartView:(WYLineChartView *)chartView {
    
    return 60.f;
}

- (NSInteger)numberOfReferenceLineVerticalInLineChartView:(WYLineChartView *)chartView {
    return [_points[0] count];
}

- (NSInteger)numberOfReferenceLineHorizontalInLineChartView:(WYLineChartView *)chartView {
    return 3;
}

- (void)lineChartView:(WYLineChartView *)lineView didBeganTouchAtSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //    NSLog(@"began move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didMovedTouchToSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //    NSLog(@"changed move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didEndedTouchToSegmentOfPoint:(WYLineChartPoint *)originalPoint value:(CGFloat)value {
    //    NSLog(@"ended move for value : %f", value);
    _touchLabel.text = [NSString stringWithFormat:@"%f", value];
}

- (void)lineChartView:(WYLineChartView *)lineView didBeganPinchWithScale:(CGFloat)scale {
    
    //    NSLog(@"begin pinch, scale : %f", scale);
}

- (void)lineChartView:(WYLineChartView *)lineView didChangedPinchWithScale:(CGFloat)scale {
    
    //    NSLog(@"change pinch, scale : %f", scale);
}

- (void)lineChartView:(WYLineChartView *)lineView didEndedPinchGraphWithOption:(WYLineChartViewScaleOption)option scale:(CGFloat)scale {
    
    //    NSLog(@"end pinch, scale : %f", scale);
}

#pragma mark - WYLineChartViewDatasource

- (NSString *)lineChartView:(WYLineChartView *)chartView contextTextForPointAtIndexPath:(NSIndexPath *)indexPath {
    
    if((indexPath.row%3 != 0 && indexPath.section%2 != 0)
       || (indexPath.row%3 == 0 && indexPath.section%2 == 0)) return nil;
    
    NSArray *pointsArray = _chartView.points[indexPath.section];
    WYLineChartPoint *point = pointsArray[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%lu", (NSInteger)point.value];
    return text;
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForXAxisLabelAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%lu", index+1];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToXAxisLabelAtIndex:(NSInteger)index {
    return _points[0][index];
}

- (WYLineChartPoint *)lineChartView:(WYLineChartView *)chartView pointReferToVerticalReferenceLineAtIndex:(NSInteger)index {
    
    return _points[0][index];
}

- (NSString *)lineChartView:(WYLineChartView *)chartView contentTextForYAxisLabelAtIndex:(NSInteger)index {
    
    CGFloat value;
    switch (index) {
        case 0:
            value = [self.chartView.calculator minValuePointsOfLinesPointSet:self.chartView.points].value;
            break;
        case 1:
            value = [self.chartView.calculator maxValuePointsOfLinesPointSet:self.chartView.points].value;
            break;
        case 2:
            value = [self.chartView.calculator calculateAverageForPointsSet:self.chartView.points];
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%lu", (NSInteger)value];
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToYAxisLabelAtIndex:(NSInteger)index {
    
    CGFloat value;
    switch (index) {
        case 0:
            value = [self.chartView.calculator minValuePointsOfLinesPointSet:self.chartView.points].value;
            break;
        case 1:
            value = [self.chartView.calculator maxValuePointsOfLinesPointSet:self.chartView.points].value;
            break;
        case 2:
            value = [self.chartView.calculator calculateAverageForPointsSet:self.chartView.points];
            break;
        default:
            break;
    }
    return value;
}

- (CGFloat)lineChartView:(WYLineChartView *)chartView valueReferToHorizontalReferenceLineAtIndex:(NSInteger)index {
    
    CGFloat value;
    switch (index) {
        case 0:
            value = [self.chartView.calculator minValuePointsOfLinesPointSet:self.chartView.points].value;
            break;
        case 1:
            value = [self.chartView.calculator maxValuePointsOfLinesPointSet:self.chartView.points].value;
            break;
        case 2:
            value = [self.chartView.calculator calculateAverageForPointsSet:self.chartView.points];
            break;
        default:
            break;
    }
    return value;
}

- (NSDictionary *)lineChartView:(WYLineChartView *)chartView attributesForLineAtIndex:(NSUInteger)index {
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionary];
    resultAttributes[kWYLineChartLineAttributeLineStyle] = @(kWYLineChartMainBezierWaveLine);
    resultAttributes[kWYLineChartLineAttributeDrawGradient] = @(false);
    resultAttributes[kWYLineChartLineAttributeJunctionStyle] = @(kWYLineChartJunctionShapeSolidCircle);
    
    UIColor *lineColor = [UIColor colorWithRed:165.f/255.f green:203.f/255.f blue:211.f/255.f alpha:0.9];

//    switch (index%3) {
//        case 0:
//            lineColor = [UIColor colorWithRed:165.f/255.f green:203.f/255.f blue:211.f/255.f alpha:0.9];
//            break;
//        case 1:
//            lineColor = [UIColor colorWithRed:250.f/255.f green:134.f/255.f blue:94.f/255.f alpha:0.9];
//            break;
//        case 2:
//            lineColor = [UIColor colorWithRed:242.f/255.f green:188.f/255.f blue:13.f/255.f alpha:0.9];
//            break;
//        default:
//            break;
//    }
    
    resultAttributes[kWYLineChartLineAttributeLineColor] = lineColor;
    resultAttributes[kWYLineChartLineAttributeJunctionColor] = lineColor;
    
    return resultAttributes;
}

@end
