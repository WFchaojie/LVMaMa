//
//  DemoRowController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/2.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "DemoRowController.h"
#import "JRWKdemoRow.h"
#define WKdemoDETAILCONTROLLERIDENTIFIER @"demoDetailController"

@interface DemoRowController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *demoRowTabel;

@end

@implementation DemoRowController
{
    //当前index
    NSInteger _currentIndex;
    
    BOOL whetherfirstopen;
    
    NSString *_picName;
    
    NSInteger _index;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _picName = [context objectForKey:@"PicName"];
    NSNumber *indexNum = [context objectForKey:@"index"];
    _index = [indexNum integerValue];
    NSString *isGlancedemo = [context objectForKey:@"isGlancedemo"];
    if ([isGlancedemo isEqualToString:@"YES"]) {
        [self becomeCurrentPage];
    }
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if (!whetherfirstopen) {
        whetherfirstopen = YES;
        [self setUpUI];
    }
}
#pragma mark - UI
- (void)setUpUI
{
    [self.demoRowTabel setNumberOfRows:1 withRowType:@"RowForOnedemo"];
    for (int i = 0; i < self.demoRowTabel.numberOfRows; i++) {
        JRWKdemoRow *demoRow = [self.demoRowTabel rowControllerAtIndex:i];
        [demoRow.demoCategory setText:[NSString stringWithFormat:@"第%ld张",_index+1]];
        
        [demoRow.demoTitle setText:@"Apple Watch图片鉴赏"];
        
        [demoRow.demoImage setBackgroundImageNamed:_picName];
        
        [demoRow.demoCommentsCount setText:[NSString stringWithFormat:@"已有%li评论",200+_index]];
        
        //2015-01-16 11:46:25
        NSString *dateString = @"2015-03-10 11:46:25";
        static NSDateFormatter *parser = nil;
        static NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
        if (parser == nil) {
            parser = [[NSDateFormatter alloc] init];
            [parser setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];//设置为中国时区
            [parser setDateFormat:dateFormat];
        }
        if (dateString.length > dateFormat.length) {
            dateString = [dateString substringToIndex:dateFormat.length];
        }
        
        NSDate *date = [parser dateFromString:dateString];
        [demoRow.demoTimer setDate:date];
        [demoRow.demoTimer start];
    }
}

#pragma mark - Table Row Select
-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSDictionary *contextDic = @{@"PicName":_picName,@"index":[NSNumber numberWithInteger:_index]};
    [self presentControllerWithName:WKdemoDETAILCONTROLLERIDENTIFIER context:contextDic];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



