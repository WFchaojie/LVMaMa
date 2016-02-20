//
//  LVHomeIntroCell.h
//  LVMaMa
//
//  Created by apple on 15-6-10.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnHeight <NSObject>

-(void)returnHeight:(int)height;

@end

@interface LVHomeIntroCell : UITableViewCell

@property(nonatomic,strong) NSArray *introduction;
@property(nonatomic,strong)id<ReturnHeight>delegate;
@property(nonatomic,strong) UILabel *cellLight;
@property(nonatomic,strong) UILabel *cellLightDetail;
@property(nonatomic,strong) NSString *lightDetail;
@property(nonatomic,strong) UILabel *cellIntroduce;
@property(nonatomic,strong) UILabel *cellIntroduceDetail;
@property(nonatomic,strong) NSString *introduceDetail;
@property(nonatomic,strong) UILabel *cellGame;
@property(nonatomic,assign) int height;

@end


