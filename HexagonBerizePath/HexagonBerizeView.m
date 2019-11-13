//
//  HexagonBerizeView.m
//  HexagonBerizePath
//
//  Created by shiyu Sun on 2019/11/12.
//  Copyright © 2019 shiyu Sun. All rights reserved.
//

#import "HexagonBerizeView.h"
#import "UIView+YYExtension.h"

/* 弧度转角度 */
#define Radians_To_Degrees(radian) ((radian) * (180.0 / M_PI))

/* 角度转弧度 */
#define Degrees_To_Radians(angle) ((angle) / 180.0 * M_PI)

/* 边数（六边形） */
#define SideCount 6

@interface HexagonBerizeView ()
{
    CGPoint _centerPoint; ///<六角形中心点坐标（用来确定六边形的位置）
    CGFloat _lineWidth; ///<六边形线宽度
    CGFloat _valueWidth; ///<值线宽度
    CGFloat _sideLength;///<最外层六边形边长（控制六边形的大小）
    CGFloat _maxValue;///<值的最大值（默认100，根据需求而定）
    CGFloat _layerCount;///<层数
    UIColor * _layerStrokeColor;///<绘制六边形边的颜色
    UIColor * _layerFillColor;///<绘制六边形边的填充颜色
    double _perAngle;///<均分内角的大小
}

@property (nonatomic, strong) NSMutableArray *labelArray;///<保存六个顶点上的label
@property (nonatomic, strong) NSMutableArray *outerLayerPoints; ///<最外层六个定点数组
@property (nonatomic, strong) NSMutableArray *layerArray; ///<值layer数组

@end

@implementation HexagonBerizeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureDefaultData];
        [self drawHexagon];
    }
    return self;
}

#pragma mark - lazy

- (NSMutableArray *)labelArray
{
    if (_labelArray == nil) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (NSMutableArray *)outerLayerPoints
{
    if (_outerLayerPoints == nil) {
        _outerLayerPoints = [NSMutableArray array];
    }
    return _outerLayerPoints;
}

- (NSMutableArray *)layerArray
{
    if (_layerArray == nil) {
        _layerArray = [NSMutableArray array];
    }
    return _layerArray;
}

#pragma mark - private

/**
 * 初始化数据
 */
- (void)configureDefaultData
{
    _lineWidth = 0.5;
    _valueWidth = 0.8;
    _maxValue = 100.0;///<最大值，默认100（对应产品需求数据里面的最大值）
    
    _perAngle = 2 * M_PI / SideCount;
    
    //默认六边形在view的中间位置（任意调整）
    _centerPoint = CGPointMake(self.yy_width * 0.5, self.yy_height * 0.5);
    //根据中间点和边长就可以确定六边形最外层六个点坐标；如果知道层数那么就可以确定每一层六边形的每个点的坐标
    _sideLength = 100.0;//默认六边形边长为 100
    _layerCount = 5;//默认层数为 5 层
    
    _layerStrokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    
    _layerFillColor = [UIColor clearColor];
    
}

/**
 * 绘制六边形框架
 */
- (void)drawHexagon
{
    //分割 num 后每格长度
    CGFloat dLength = _sideLength / _layerCount;

//    CGFloat sinV = sin(Degrees_To_Radians(30));//sin30度值
//    CGFloat cosV = cos(Degrees_To_Radians(30));//cos30度值
    
    // 绘制 num 个六边形
    for (NSInteger i = 0; i < _layerCount; i ++) {
        
        //每一层边长
        CGFloat perSideLength = _sideLength - (dLength * i);
        
        //每一层贝塞尔曲线
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        //确定六个顶点坐标
        for (NSInteger j = 0; j < SideCount; j++) {
            CGPoint tempPoint = CGPointMake(_centerPoint.x - perSideLength * cos(_perAngle * (j+1)) ,_centerPoint.y - perSideLength * sin(_perAngle * (j+1)));
            if (j == 0) {
                [bezierPath moveToPoint:tempPoint];
            } else {
                [bezierPath addLineToPoint:tempPoint];
            }
            //保存最外层六边形的六个顶点坐标
            if (i == 0) {
                [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:tempPoint]];
            }
        }
        
        //下面是拆分写法，枚举每个点
        
//        //点1（左上角点开始）
//        CGPoint point1 = CGPointMake(_centerPoint.x - perSideLength * sinV, _centerPoint.y - perSideLength * cosV);
//        //点2
//        CGPoint point2 = CGPointMake(_centerPoint.x + perSideLength * sinV, _centerPoint.y - perSideLength * cosV);
//        //点3
//        CGPoint point3 = CGPointMake(_centerPoint.x + perSideLength, _centerPoint.y);
//        //点4
//        CGPoint point4 = CGPointMake(_centerPoint.x + perSideLength * sinV, _centerPoint.y + perSideLength * cosV);
//        //点5
//        CGPoint point5 = CGPointMake(_centerPoint.x - perSideLength * sinV, _centerPoint.y + perSideLength * cosV);
//        //点6（左部中间点结束）
//        CGPoint point6 = CGPointMake(_centerPoint.x - perSideLength, _centerPoint.y);
//
//        [bezierPath moveToPoint:point1];
//        [bezierPath addLineToPoint:point2];
//        [bezierPath addLineToPoint:point3];
//        [bezierPath addLineToPoint:point4];
//        [bezierPath addLineToPoint:point5];
//        [bezierPath addLineToPoint:point6];
        //调用关闭曲线方法，把曲线封闭（连上起始点和终点）
        [bezierPath closePath];
        
        CAShapeLayer *aLayer = [CAShapeLayer layer];
        aLayer.lineWidth = _lineWidth;
        aLayer.fillColor = _layerFillColor.CGColor;
        aLayer.strokeColor = _layerStrokeColor.CGColor;
        aLayer.lineCap = kCALineCapSquare;
        aLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:aLayer];
        
        
//        if (i == 0) {
//            [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:point1]];
//            [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:point2]];
//            [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:point3]];
//            [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:point4]];
//            [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:point5]];
//            [self.outerLayerPoints addObject:[NSValue valueWithCGPoint:point6]];
//        }
    }
    
    //各个定点向中心点连线 创建label
    for (NSInteger i = 0; i < self.outerLayerPoints.count; i++) {
        CGPoint point = [self.outerLayerPoints[i] CGPointValue];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:point];
        [bezierPath addLineToPoint:_centerPoint];
        
        CAShapeLayer *aLayer = [CAShapeLayer layer];
        aLayer.lineWidth = _lineWidth;
        aLayer.fillColor = _layerFillColor.CGColor;
        aLayer.strokeColor = _layerStrokeColor.CGColor;
        aLayer.lineCap = kCALineCapSquare;
        aLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:aLayer];
    }
}

/**
 * 绘画值区域
 */
- (void)initValuePoint
{
    //移除之前的值layer
    for (CAShapeLayer *layer in self.layerArray) {
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeAllObjects];
    
    //CGFloat sinValue = sin(Degrees_To_Radians(30));//sin30度值
    //CGFloat cosValue = cos(Degrees_To_Radians(30));//cos30度值

    for (NSInteger i = 0; i < _values.count; i ++) {
        
        NSArray *templeValues = _values[i];
        //绘制
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        for (NSInteger j = 0; j < templeValues.count; j++) {
            
            CGFloat value = [[templeValues objectAtIndex:j] floatValue];
            
            //注意：这里最大值以及边长默认设置都是100
            //value = value > _sideLength ? _sideLength : value;
            //换算
            value = (value / _maxValue) * _sideLength > _sideLength ? _sideLength : (value / _maxValue) * _sideLength;
            
            CGPoint tempPoint = CGPointMake(_centerPoint.x - value * cos(_perAngle * (j+1)) ,_centerPoint.y - value * sin(_perAngle * (j+1)));
            if (j == 0) {
                [path moveToPoint:tempPoint];
            } else {
                [path addLineToPoint:tempPoint];
            }
            
            //上面的简单写法是从下面找规律得来，刚开始写是先枚举出来各个点，然后发现三角函数的规律，得出上面简化写法。
            
//            CGPoint point;
//            switch (j) {
//                case 0:
//                    point = CGPointMake(_centerPoint.x - value * sinValue ,_centerPoint.y - value * cosValue);
//                    [path moveToPoint:point];
//                    break;
//                case 1:
//                    point = CGPointMake(_centerPoint.x + value * sinValue, _centerPoint.y - value * cosValue);
//                    [path addLineToPoint:point];
//                    break;
//                case 2:
//                    point = CGPointMake(_centerPoint.x + value, _centerPoint.y);
//                    [path addLineToPoint:point];
//                    break;
//                case 3:
//                    point = CGPointMake(_centerPoint.x + value * sinValue, _centerPoint.y + value * cosValue);
//                    [path addLineToPoint:point];
//                    break;
//                case 4:
//                    point = CGPointMake(_centerPoint.x - value * sinValue, _centerPoint.y + value * cosValue);
//                    [path addLineToPoint:point];
//                    break;
//                case 5:
//                    point = CGPointMake(_centerPoint.x - value, _centerPoint.y);
//                    [path addLineToPoint:point];
//                    break;
//                default:
//                    point = CGPointMake(0, 0);
//                    break;
//            }
//
//            NSLog(@"%@  %@  %f",NSStringFromCGPoint(tempPoint),NSStringFromCGPoint(point),value);
        }
        
        [path closePath];
        
        CGFloat red = arc4random() % 256;
        CGFloat green = arc4random() % 256;
        CGFloat blue = arc4random() % 256;
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.path = path.CGPath;
        shaper.lineWidth = _valueWidth;
        //如果有颜色就采用用户赋值的颜色；如果没有颜色就随机颜色
        if (self.valueFillColors.count == self.values.count) {
            shaper.fillColor = self.valueFillColors[i].CGColor;
        } else {
            shaper.fillColor = [UIColor colorWithRed:red/256.0 green:green/256.0 blue:blue/256.0 alpha:0.4].CGColor;
        }
        if (self.valueStrokeColors.count == self.values.count) {
            shaper.strokeColor = self.valueStrokeColors[i].CGColor;
        } else {
            shaper.strokeColor = [UIColor colorWithRed:red/256.0 green:green/256.0 blue:blue/256.0 alpha:0.7].CGColor;
        }
        [self.layer addSublayer:shaper];
        
        [self.layerArray addObject:shaper];
    }
}

- (void)initLabel
{
    //移除之前的label
    for (UILabel *label in self.labelArray) {
        [label removeFromSuperview];
    }
    [self.labelArray removeAllObjects];
    
    //label的高度这里写死，可以根据需求设置宽度
    CGFloat labelH = 20.0;
    CGFloat fontSize = 15.0;
    CGFloat space = 5.0;
    for (NSInteger i = 0; i < _textArray.count; i++) {
        CGPoint point = [self.outerLayerPoints[i] CGPointValue];
        CGFloat width = [self sizeOfStringWithMaxSize:CGSizeMake(MAXFLOAT, labelH) textFont:fontSize aimString:_textArray[i]].width;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, labelH)];
        titleLabel.font = [UIFont systemFontOfSize:fontSize];
        titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
        titleLabel.text = _textArray[i];
        [self addSubview:titleLabel];
        switch (i) {
            case 0:
                titleLabel.center = CGPointMake(point.x, point.y - labelH / 2 - space);
                break;
            case 1:
                titleLabel.center = CGPointMake(point.x, point.y - labelH / 2 - space);
                break;
            case 2:
                titleLabel.center = CGPointMake(point.x + width / 2 + space, point.y);
                break;
            case 3:
                titleLabel.center = CGPointMake(point.x, point.y + labelH / 2 + space);
                break;
            case 4:
                titleLabel.center = CGPointMake(point.x, point.y + labelH / 2 + space);
                break;
            case 5:
                titleLabel.center = CGPointMake(point.x - width / 2 -space, point.y);
                break;
            default:
                break;
        }
        [self.labelArray addObject:titleLabel];
    }
}

- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString{
    return [[NSString stringWithFormat:@"%@",aimString] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

#pragma mark - setter

- (void)setValues:(NSArray *)values
{
    _values = values;
    
    [self initValuePoint];
}

- (void)setTextArray:(NSArray *)textArray
{
    _textArray = textArray;
    
    [self initLabel];
}

- (void)setValueFillColors:(NSArray<UIColor *> *)valueFillColors
{
    _valueFillColors = valueFillColors;
    
    if (self.layerArray.count == 0) return;
    
    for (NSInteger i = 0; i < valueFillColors.count; i++) {
        CAShapeLayer *layer = self.layerArray[i];
        layer.fillColor = valueFillColors[i].CGColor;
        //默认把边的颜色透明改为0.7（颜色稍深，用以区分填充颜色）
        layer.strokeColor = [valueFillColors[i] colorWithAlphaComponent:0.7].CGColor;
    }
}

- (void)setValueStrokeColors:(NSArray<UIColor *> *)valueStrokeColors
{
    _valueStrokeColors = valueStrokeColors;
    
    if (self.layerArray.count == 0) return;
    
    for (NSInteger i = 0; i < valueStrokeColors.count; i++) {
        CAShapeLayer *layer = self.layerArray[i];
        layer.strokeColor = valueStrokeColors[i].CGColor;
    }
}


- (void)dealloc
{
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}

@end
