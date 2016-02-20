//
//  NearDetailInfoCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/10/11.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Pay <NSObject>

-(void)payClick;

@end

@interface NearDetailInfoCell : UITableViewCell

@property(nonatomic,strong)NSString *cellBranchName;
@property(nonatomic,strong)NSString *cellImages;
@property(nonatomic,strong)NSString *cellSellPrice;
@property(nonatomic,strong)NSString *cellPayType;
@property(nonatomic,strong)NSString *cellInfo;
@property(nonatomic,strong)NSString *cellRoomArea;
@property(nonatomic,strong)NSString *cellFloor;


@property(nonatomic,strong)id<Pay>delegate;


@end
