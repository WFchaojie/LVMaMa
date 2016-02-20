//
//  LVTourCommentCell.h
//  LVMaMa
//
//  Created by apple on 15-6-14.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVTourCommentCell : UITableViewCell
@property(nonatomic,strong)UIImageView *cellPic;
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userContent;
@property(nonatomic,strong)UILabel *cellTitle;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)UILabel *cellTime;
@end
