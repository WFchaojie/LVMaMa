//
//  LVPindaoHeadCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Pic <NSObject>

-(void)picWithTag:(int)tag;

@end

@interface LVPindaoHeadCell : UITableViewCell

@property(nonatomic,strong)UIButton *cellButton1;
@property(nonatomic,strong)UIButton *cellButton2;
@property(nonatomic,strong)UIButton *cellButton3;

@property(nonatomic,copy)NSString *pic1;
@property(nonatomic,copy)NSString *pic2;
@property(nonatomic,copy)NSString *pic3;

@property(nonatomic,copy)NSString *title1;
@property(nonatomic,copy)NSString *title2;
@property(nonatomic,copy)NSString *title3;

@property(nonatomic,strong)UILabel *cellTitle1;
@property(nonatomic,strong)UILabel *cellTitle2;
@property(nonatomic,strong)UILabel *cellTitle3;

@property(nonatomic,strong)UIView *cellBack1;
@property(nonatomic,strong)UIView *cellBack2;
@property(nonatomic,strong)UIView *cellBack3;
@property(nonatomic,strong)id<Pic>delegate;
@end
