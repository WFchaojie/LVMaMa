//
//  LVHomeIntroOtherCell.h
//  LVMaMa
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol hotelDetail <NSObject>

-(void)hotelClick:(NSInteger)tag;

@end


@interface LVHomeIntroOtherCell : UITableViewCell

@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)id<hotelDetail>delegate;
@end
