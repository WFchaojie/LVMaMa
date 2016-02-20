//
//  LVHomeCommentCell.h
//  LVMaMa
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicComment <NSObject>

-(void)picClick:(NSArray *)array andTheCount:(int)count;

@end

@interface LVHomeCommentCell : UITableViewCell

@property(nonatomic,strong)NSString *userPic;
@property(nonatomic,strong)UIImageView *celluserPic;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)UILabel *cellUserName;
@property(nonatomic,strong)NSString *commnet;
@property(nonatomic,strong)UILabel *cellCommnet;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)UILabel *cellTime;
@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)id<PicComment>delegate;

@end
