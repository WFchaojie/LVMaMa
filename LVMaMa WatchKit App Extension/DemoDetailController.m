//
//  DemoDetailController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/2.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "DemoDetailController.h"
//NSNotification Key
#define AW_demoDETAILPAGE_TO_MAINPAGE @"notification_for_demodetail_to_mainpage"
#define AW_JUMP_FROM_INDICATEPAGE_TO_MAINPAGE @"notification_to_indicatepage_to_mainpage"

//Controller Identifier
#define WKdemoPAGECONTROLLERIDENTIFIER @"PagedemoRowController"
#define WKdemoDETAILCONTROLLERIDENTIFIER @"demoDetailController"
#define WKINDICATECONTROLLERIDENTIFIER @"StateIndicateController"
#define is38mm ([[WKInterfaceDevice currentDevice] screenBounds].size.width == 136)
#define is42mm ([[WKInterfaceDevice currentDevice] screenBounds].size.width == 156)
@interface DemoDetailController ()
//标题
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *demoDetailTitle;
//评论数
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *comment;
//发生时间
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *demoTimer;
//图片
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *demoImageGroup;
//正文
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *demoContent;
//handoff Tips
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *tipsLabel;

@end

@implementation DemoDetailController
{
    BOOL _whetherJumpToMainPage;
    
    //是否收藏
    BOOL _whetherFavorite;
    
    NSString *_picName;
    
    NSInteger _index;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _picName = [context objectForKey:@"PicName"];
    NSNumber *indexNum = [context objectForKey:@"index"];
    _index = [indexNum integerValue];
    [self setUpUI];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
        [self addMenuItems];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    if (_whetherJumpToMainPage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AW_demoDETAILPAGE_TO_MAINPAGE object:nil];
    }
}
#pragma mark - UI
- (void)addMenuItems
{
    //Fouce Touch Item Button
    //收藏Item
    NSDictionary *paraDic = @{@"PicName":_picName};
    [WKInterfaceController openParentApplication:@{@"type":@"isFavorite",@"para":paraDic} reply:^(NSDictionary *replyInfo, NSError *error) {
        if (error || !replyInfo) {
            [self addMenuItemWithCommentTitile:@"评论" withFavorite:@"收藏"];
            return;
        }
        NSString *favoriteItemName;
        BOOL whetherFavorite = [[replyInfo objectForKey:@"isFavorite"] boolValue];
        _whetherFavorite = (whetherFavorite)?YES:NO;
        if (whetherFavorite) {
            favoriteItemName = @"取消收藏";
        }else
        {
            favoriteItemName = @"收藏";
        }
        [self addMenuItemWithCommentTitile:@"评论" withFavorite:favoriteItemName];
    }];
}

-(void)setUpUI
{
    //图片 可以在这里设置不同尺寸
    if (is38mm) {
        [self.demoImageGroup setBackgroundImageNamed:_picName];
    }else
    {
        [self.demoImageGroup setBackgroundImageNamed:_picName];
    }
    
    //配置评论数
    [self.comment setText:[NSString stringWithFormat:@"已有%li评论",200+_index]];
    //配置新闻标题
    [self.demoDetailTitle setText:@"Apple Watch图片鉴赏"];
    //配置新闻时间
    //2015-01-16 11:46:25
    NSString *dateString = @"2015-03-10 11:46:25";
    static NSDateFormatter *parser = nil;
    static NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if (parser == nil) {
        parser = [[NSDateFormatter alloc] init];
        [parser setDateFormat:dateFormat];
    }
    if (dateString.length > dateFormat.length) {
        dateString = [dateString substringToIndex:dateFormat.length];
    }
    NSDate *date = [parser dateFromString:dateString];
    [self.demoTimer setDate:date];
    [self.demoTimer start];
    
    //配置新闻摘要
    [self.demoContent setText:@"Imagine you’re back at September 9, 2014. Tim Cook has been taking a packed audience through the finer details of the new iPhone 6 and 6+, as well as the just- announced Apple Pay service. Just when things appear to be wrapping up, the familiar “One more thing...” keynote slide appears."];
    //配置tips
    [self.tipsLabel setText:@"「请使用HandOff查看更多内容」"];
}

- (void)addMenuItemWithCommentTitile:(NSString *)commentTitle withFavorite:(NSString *)favoriteTitle
{
    [self clearAllMenuItems];

    
}
@end



