//
//  BaseViewController.h
//  LVMaMa
//
//  Created by apple on 15-6-19.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeRefreshControl.h"

@interface BaseViewController : UIViewController

-(void)leftButton;
-(void)rightClick:(UIButton *)button;
-(void)rightBtn:(NSString *)title;
-(void)rightButton:(NSArray *)array;
-(void)rightClick;
- (void)hudShow;
-(void)startAnimate;
-(void)hudHide;


@end
