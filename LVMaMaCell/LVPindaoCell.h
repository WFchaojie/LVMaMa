//
//  LVPindaoCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Pay <NSObject>

-(void)pay;

@end


@interface LVPindaoCell : UITableViewCell
@property(nonatomic,copy)NSString *pic;
@property(nonatomic,strong)UIImageView *cellPic;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UILabel *cellTitle;
@property(nonatomic,strong)UIButton *cellPay;
@property(nonatomic,assign)int sellPriceYuan;
@property(nonatomic,strong)UILabel *cellSellPriceYuan;
@property(nonatomic,assign)int marketPriceYuan;
@property(nonatomic,strong)UILabel *cellMarketPriceYuan;
@property(nonatomic,assign)int orderCount;
@property(nonatomic,strong)UILabel *cellOrderCount;
@property(nonatomic,strong)UIImageView *line;

@property(nonatomic,strong)id<Pay>delegate;

@end
