//
//  HexagonBerizeView.h
//  HexagonBerizePath
//
//  Created by shiyu Sun on 2019/11/12.
//  Copyright © 2019 shiyu Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HexagonBerizeView : UIView

/**
 * 值填充颜色
 */
@property (nonatomic, copy) NSArray <UIColor *>*valueFillColors;

/**
 * 值边颜色
 */
@property (nonatomic, copy) NSArray <UIColor *>*valueStrokeColors;

/**
 * 值数组
 */
@property (nonatomic, copy) NSArray *values;

/**
 * text数组
 */
@property (nonatomic, copy) NSArray *textArray;

@end

NS_ASSUME_NONNULL_END
