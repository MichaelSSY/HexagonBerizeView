//
//  UIView+YYExtension.h
//  YZPhotoBrowser
//
//  Created by shiyu Sun on 2019/10/21.
//  Copyright © 2019 shiyu Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YYExtension)

@property (nonatomic, assign) CGSize yy_size;
@property (nonatomic, assign) CGFloat yy_width;
@property (nonatomic, assign) CGFloat yy_height;
@property (nonatomic, assign) CGFloat yy_x;
@property (nonatomic, assign) CGFloat yy_y;
@property (nonatomic, assign) CGFloat yy_centerX;
@property (nonatomic, assign) CGFloat yy_centerY;

//判断是否包含某个类的subview
- (BOOL)doHaveSubViewOfSubViewClassName:(NSString *)subViewClassName;

//删除某个类的subview
- (void)removeSomeSubViewOfSubViewClassName:(NSString *)subViewClassName;

//得到某个类的subview
- (void)getTheSubViewOfSubViewClassName:(NSString *)subViewClassName block:(void(^)(UIView *subView))block;

@end


