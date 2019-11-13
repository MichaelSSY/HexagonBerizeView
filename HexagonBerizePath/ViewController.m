//
//  ViewController.m
//  HexagonBerizePath
//
//  Created by shiyu Sun on 2019/11/12.
//  Copyright © 2019 shiyu Sun. All rights reserved.
//

#import "ViewController.h"
#import "HexagonBerizeView.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) HexagonBerizeView *hexagonView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.hexagonView];
}

#pragma mark - lazy

- (HexagonBerizeView *)hexagonView
{
    if (_hexagonView == nil) {
        _hexagonView = [[HexagonBerizeView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 300)];
        _hexagonView.textArray = @[@"客户关系",@"产品",@"价格",@"品牌",@"服务",@"其他"];;
        _hexagonView.valueFillColors = @[[UIColor colorWithRed:7/ 256.0 green:71/256.0 blue:151 / 256.0 alpha:0.4],[UIColor colorWithRed:255/ 256.0 green:0/256.0 blue:0 / 256.0 alpha:0.4]];
        _hexagonView.valueStrokeColors = @[[UIColor colorWithRed:7/ 256.0 green:71/256.0 blue:151 / 256.0 alpha:0.7],[UIColor colorWithRed:255/ 256.0 green:0/256.0 blue:0 / 256.0 alpha:0.7]];
        //这里最大值取100 (根据需求而定)
        _hexagonView.values = @[@[@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100)],
                                  @[@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100)]];
    }
    return _hexagonView;
}

#pragma mark - method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.hexagonView.values = @[@[@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100)],
                                   @[@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100),@(arc4random() % 100)]];
}

@end
