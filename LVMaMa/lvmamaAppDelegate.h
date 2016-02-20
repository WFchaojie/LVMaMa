//
//  lvmamaAppDelegate.h
//  LVMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//  微游目的地点击以后的页面  周边页面的点击页面。


#import <UIKit/UIKit.h>
#import "lVTabbar.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@protocol adDownLoad <NSObject>

-(void)adDownloadFinish:(NSArray *)adArray;

@end

@interface lvmamaAppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)lVTabbar *lvTabbar;
@property(nonatomic,strong)id<adDownLoad>delegate;



@end
