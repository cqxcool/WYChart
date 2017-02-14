//
//  WYCViewController.m
//  WYChart
//
//  Created by FreedomKing on 09/14/2016.
//  Copyright (c) 2016 FreedomKing. All rights reserved.
//

#import "WYCViewController.h"
#import "PieChartViewController.h"
#import "LineChartViewController.h"
#import "RadarChartViewController.h"
#import "FRPowerChartView.h"

@interface WYCViewController () <UITableViewDelegate, UITableViewDataSource>
{
    FRPowerChartView *_chartView;
}
@end

@implementation WYCViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"WYChart";
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"PieChart(饼状图)";
            break;
        }
        case 1: {
            cell.textLabel.text = @"LineChart(线型图) v0.2.0";
            break;
        }
        case 2: {
            cell.textLabel.text = @"RadarChart(雷达图) v0.3.0";
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    UIViewController *vc;
    
    switch (indexPath.row) {
        case 0: {
            vc = [[PieChartViewController alloc] init];
            break;
        }
        case 1: {
            vc = [[LineChartViewController alloc] init];
            break;
        }
        case 2: {
            vc = [[RadarChartViewController alloc] init];
            break;
        }
        case 3:{
            _chartView = [[FRPowerChartView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetHeight(self.view.frame) ,CGRectGetWidth(self.view.frame) )];
            _chartView.center = self.view.center;
            [[UIApplication sharedApplication].keyWindow addSubview:_chartView];
            _chartView.backgroundColor = [UIColor redColor];
            CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
            _chartView.transform = transform;
            
            break;
        }
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:true];
}

@end
