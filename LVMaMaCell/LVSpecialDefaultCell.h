//
//  LVSpecialDefaultCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVSpecialDefaultCell : UITableViewCell
@property(nonatomic,strong)UILabel *celltitle;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UILabel *cellComment;
@property(nonatomic,assign)int comment;
@property(nonatomic,strong)NSString *star;
@property(nonatomic,strong)UIImageView *cellStar;
@property(nonatomic,strong)NSString *leftImage;
@property(nonatomic,strong)UIImageView *cellLeftImage;
@end
