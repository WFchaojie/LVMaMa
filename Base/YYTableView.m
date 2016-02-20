//
//  YYTableView.m
//  YYKitExample
//
//  Created by ibireme on 15/9/7.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTableView.h"

@implementation YYTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // Remove touch delay (since iOS 8)
    UIView *wrapView = self.subviews.firstObject;
    //NSLog(@"self.subviews=%@",self.subviews);
    //NSLog(@"wrap.subviews=%@",wrapView.subviews);
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        NSLog(@"ges=%@",wrapView.gestureRecognizers);
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
     
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
