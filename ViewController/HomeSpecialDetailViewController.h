//
//  HomeSpecialDetailViewController.h
//  LVMaMa
//
//  Created by 武超杰 on 15/7/16.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSpecialDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *homeTitle;


@end