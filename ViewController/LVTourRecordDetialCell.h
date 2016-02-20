//
//  LVTourRecordDetialCell.h
//  LVMaMa
//
//  Created by apple on 15-6-13.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVTourRecordDetialCell : UITableViewCell

@property(nonatomic,strong)UILabel *cellPoiDesc;
@property(nonatomic,copy)NSString *poiDesc;

@property(nonatomic,strong)UIImageView *cellAddressPic;
@property(nonatomic,strong)UILabel *cellAddressLabel;
@property(nonatomic,copy)NSString *poiName;

@property(nonatomic,strong)UIImageView *likePic;
@property(nonatomic,strong)UILabel *likeLabel;
@property(nonatomic,strong)NSNumber *like;

@property(nonatomic,strong)UIImageView *commentPic;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)NSNumber *comment;

@property(nonatomic,strong)UIImageView *cellPic;
@property(nonatomic,copy)NSString *pic;
//图片附带的描述
@property(nonatomic,strong)UILabel *cellMemoLabel;
@property(nonatomic,copy)NSString *memo;

//无图片时的描述
@property(nonatomic,strong)UILabel *cellDiscrip;
@property(nonatomic,copy) NSString *discrip;



@end
