//
//  LVHomeSpecialCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/16.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pay <NSObject>

-(void)pay;

@end

@interface LVHomeSpecialCell : UITableViewCell

@property(nonatomic,strong)UILabel *cellProductName;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSArray  *firstTagItems;
@property(nonatomic,strong)UILabel *cellOrderCount;
@property(nonatomic,strong)NSString *orderCount;
@property(nonatomic,strong)UILabel *cellOfflineTime;
@property(nonatomic,strong)NSString *offlineTime;
@property(nonatomic,strong)UILabel *cellProductId;
@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)UILabel *cellSellPriceYuan;
@property(nonatomic,strong)NSString *sellPriceYuan;
@property(nonatomic,strong)id<pay>payDelegate;
@end
