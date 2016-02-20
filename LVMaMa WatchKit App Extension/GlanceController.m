//
//  GlanceController.m
//  LVMaMa WatchKit Extension
//
//  Created by 武超杰 on 15/9/1.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}
-(void)updateUserActivity:(NSString *)type userInfo:(NSDictionary *)userInfo webpageURL:(NSURL *)webpageURL
{
    
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



