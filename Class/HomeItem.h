//
//  HomeItem.h
//  LVMaMa
//
//  Created by apple on 15-6-21.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeItem : UIView
@property (nonatomic) CGFloat translationX;

- (instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
- (void)setupWithFrame:(CGRect)rect;
- (void)setHorizontalRandomness:(int)horizontalRandomness dropHeight:(CGFloat)dropHeight;

@end
