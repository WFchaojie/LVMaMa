//
//  LimitCommentCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/9/11.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LvStarView;

@protocol PicComment <NSObject>

-(void)picClick:(NSArray *)array andTheCount:(int)count;

@end

@protocol PicCommentSpecial <NSObject>

-(void)picClick:(NSArray *)array andTheCount:(int)count andType:(int)type;

@end

@interface LimitCommentCell : UITableViewCell

@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)UILabel *cellUserName;
@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)UILabel *cellComment;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)UILabel *cellTime;
@property(nonatomic,strong)NSArray *picArray;
@property(nonatomic,strong)UIImageView *separateLine;
@property(nonatomic,strong)NSString *avgScore;
@property(nonatomic,strong)LvStarView *starView;
@property(nonatomic,strong)id<PicComment>delegate;
@property(nonatomic,strong)id<PicCommentSpecial>picDelegate;


@end
