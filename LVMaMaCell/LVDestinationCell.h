//
//  LVDestinationCell.h
//  LVMaMa
//
//  Created by apple on 15-6-4.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol gotoDestination <NSObject>

-(void)destination:(NSInteger)number;

@end

@interface LVDestinationCell : UITableViewCell

@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)id<gotoDestination>delegate;
@end
