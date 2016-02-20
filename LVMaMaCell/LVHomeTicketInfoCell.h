//
//  LVHomeTicketInfoCell.h
//  LVMaMa
//
//  Created by apple on 15-6-9.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Pay <NSObject>

-(void)pay;

@end

@interface LVHomeTicketInfoCell : UITableViewCell
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)NSString *ticketTitle;
@property(nonatomic,strong)UILabel *detail;
@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,strong)UILabel *firstTagLabel;
@property(nonatomic,strong)NSString *firstTag;;
@property(nonatomic,strong)UILabel *lastOrderLabel;
@property(nonatomic,strong)NSString *lastOrder;
@property(nonatomic,strong)UILabel *deductionLabel;
@property(nonatomic,strong)NSString *deduction;
@property(nonatomic,strong)UILabel *promotionLabel;
@property(nonatomic,strong)NSString *promotion;
@property(nonatomic,strong)UIImageView *onLinePic;
@property(nonatomic,strong)UILabel *sellPriceLabel;
@property(nonatomic,assign)int sellPrice;
//market refund 共用一个label
@property(nonatomic,strong)UILabel *marketPriceLabel;
@property(nonatomic,assign)int marketPrice;
@property(nonatomic,strong)UILabel *refundLabel;
@property(nonatomic,strong)NSString *refund;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)id<Pay>delegate;
//送保险

@end
