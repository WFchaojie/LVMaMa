//
//  LVSepecialLineRouteCell.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getMore <NSObject>

-(void)getMore;

@end

@interface LVSepecialLineRouteCell : UITableViewCell
@property(nonatomic,strong)UILabel *cellDay1title;
@property(nonatomic,strong)NSString *day1Title;
@property(nonatomic,strong)UILabel *cellDay1Content;
@property(nonatomic,strong)NSString *day1Content;
@property(nonatomic,strong)UILabel *cellDay1StayDesc;
@property(nonatomic,strong)NSString *day1StayDesc;
@property(nonatomic,strong)UILabel *cellDay2title;
@property(nonatomic,strong)NSString *day2Title;
@property(nonatomic,strong)UILabel *cellDay2Content;
@property(nonatomic,strong)NSString *day2Content;
@property(nonatomic,strong)id<getMore>delegate;
@end
