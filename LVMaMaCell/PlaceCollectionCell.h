//
//  PlaceCollectionCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/8/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *cellPic;
@property(nonatomic,copy)NSString *pic;

@property(nonatomic,strong)UILabel *cellTitle;
@property(nonatomic,copy)NSString *ctitle;

@property(nonatomic,strong)UIView *cellBack;

@end
