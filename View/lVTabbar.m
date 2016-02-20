//
//  lVTabbar.m
//  LvMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "lVTabbar.h"

@interface lVTabbar ()

@end

@implementation lVTabbar
{
    int _itemCount;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)createSECTabbarWithBackgroundImageName:(NSString *)imageName andItemArray:(NSArray *)itemsArray andClass:(id)classObject andSEL:(SEL)sel
{
    _itemCount=(int)itemsArray.count;
    for (int i=0; i<_itemCount; i++) {
        [self createItemWithItemDict:[itemsArray objectAtIndex:i] andItemTag:i andClass:classObject andSEL:sel];
    }
}
-(void)createItemWithItemDict:(NSDictionary *)itemDict andItemTag:(int)itemTag andClass:(id)classObject andSEL:(SEL)sel
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/4*itemTag, 0, self.frame.size.width/4, 46)];
    backView.backgroundColor=[UIColor whiteColor];
    [self addSubview:backView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, self.frame.size.width/4, 46);
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"image"]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"imageselect"]] forState:UIControlStateSelected];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag=itemTag;
    [backView addSubview:btn];
}



@end
