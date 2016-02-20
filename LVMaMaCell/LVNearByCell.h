//
//  LVNearByCell.h
//  LVMaMa
//
//  Created by apple on 15-6-5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVNearByCell : UITableViewCell
@property(nonatomic,strong)NSString *cellPic;
@property(nonatomic,strong)NSString *cellTitle;
@property(nonatomic,strong)NSString *cellDetail;
@property(nonatomic,strong)NSString *cellDistance;
@property(nonatomic,strong)NSString *cellPlaceType;
@property(nonatomic,strong)UIImageView *wifi;
@property(nonatomic,strong)UIImageView *park;
@property(nonatomic,assign)BOOL cellWifi;
@property(nonatomic,assign)BOOL cellPark;
@property(nonatomic,strong)NSString *cellPrice;
@property(nonatomic,strong)NSString *cellPriceBack;

@end
