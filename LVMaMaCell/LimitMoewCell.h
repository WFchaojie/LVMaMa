//
//  LimitMoewCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/9/7.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitMoewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *cellPic;
@property(nonatomic,strong)NSString *pic;

@property(nonatomic,strong)UILabel *cellProductName;
@property(nonatomic,strong)NSString *productName;

@property(nonatomic,strong)UILabel *cellDiscountV200;
@property(nonatomic,strong)NSString *discountV200;

@property(nonatomic,strong)UILabel *cellAddress;
@property(nonatomic,strong)NSString *address;

@property(nonatomic,strong)UILabel *cellSellPriceYuan;
@property(nonatomic,strong)NSString *sellPriceYuan;

@property(nonatomic,strong)UILabel *cellMarketPriceYuan;
@property(nonatomic,strong)NSString *marketPriceYuan;

@property(nonatomic,strong)UILabel *cellRecommandName;
@property(nonatomic,strong)NSString *recommandName;

@property(nonatomic,strong)UILabel *cellStockCount;
@property(nonatomic,strong)NSString *stockCount;

@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)UIImageView *separateLine;

@property(nonatomic,strong)UILabel *cellHint;

@property(nonatomic,strong)UILabel *cellRestTime;
@property(nonatomic,strong)NSString *restTime;

@property(nonatomic,strong)UIView *backColor;
@property(nonatomic,strong)UILabel *tian;
@property(nonatomic,strong)UILabel *dian;
@property(nonatomic,strong)UILabel *dian1;

@end
