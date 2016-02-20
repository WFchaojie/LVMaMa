//
//  LVTourRecordCommentCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVTourRecordCommentCell : UITableViewCell
@property(nonatomic,strong)UIImageView *cellUserPic;
@property(nonatomic,strong)UILabel *cellComment;
@property(nonatomic,strong)UILabel *cellTime;
@property(nonatomic,strong)NSString *userPic;
@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *userName;

@end
