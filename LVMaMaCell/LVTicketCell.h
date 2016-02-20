//
//  LVTicketCell.h
//  LVMaMa
//
//  Created by apple on 15-6-6.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVTicketCell : UITableViewCell
@property(nonatomic,strong)NSString *cellPic;
@property(nonatomic,strong)NSString *cellTitle;
@property(nonatomic,strong)UIImageView *pic;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)NSString *cellPrice;
@property(nonatomic,strong)UILabel *price;
@property(nonatomic,strong)NSString *cellPriceMarket;
@property(nonatomic,strong)UILabel *priceMarket;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)UILabel *type;
@property(nonatomic,strong)NSString *cellType;
@end
