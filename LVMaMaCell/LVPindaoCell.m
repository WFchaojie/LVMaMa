//
//  LVPindaoCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVPindaoCell.h"

@implementation LVPindaoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.cellPic) {
        self.cellPic=[[UIImageView alloc]initWithFrame:CGRectMake(6, 7, 80, 66)];
        [self addSubview:self.cellPic];
    }
    
    if (!self.cellTitle) {
        self.cellTitle=[[UILabel alloc]initWithFrame:CGRectMake(6+self.cellPic.bounds.size.width+5,0,self.bounds.size.width-5-91, 40)];
        self.cellTitle.font=[UIFont systemFontOfSize:12];
        self.cellTitle.textColor=[UIColor blackColor];
        self.cellTitle.numberOfLines=2;
        self.cellTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.cellTitle];
    }
    
    if (self.pic) {
        [self.cellPic sd_setImageWithURL:[NSURL URLWithString:self.pic] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
    }
    if(self.title)
    {
        self.cellTitle.text=self.title;
    }
    if (!self.cellSellPriceYuan) {
        self.cellSellPriceYuan=[[UILabel alloc]initWithFrame:CGRectMake(6+self.cellPic.bounds.size.width+5, 40, 200, 20)];
        self.cellSellPriceYuan.text=[NSString stringWithFormat:@"￥%d起",self.sellPriceYuan];
        self.cellSellPriceYuan.font=[UIFont systemFontOfSize:10];
        self.cellSellPriceYuan.textColor=[UIColor grayColor];
        self.cellSellPriceYuan.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.cellSellPriceYuan];
    }
    if (self.sellPriceYuan!=0) {
        NSString *stockCountstring=[NSString stringWithFormat:@"￥%d起",self.sellPriceYuan];
        UIFont *font=[UIFont boldSystemFontOfSize:13];
        NSMutableAttributedString *stockAttribute=[[NSMutableAttributedString alloc]initWithString:stockCountstring];
        NSDictionary *stockColor=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
        [stockAttribute addAttributes:stockColor range:NSMakeRange(0,stockCountstring.length-1)];
        self.cellSellPriceYuan.attributedText=stockAttribute;
        [self.cellSellPriceYuan sizeToFit];

        if (!self.cellMarketPriceYuan) {
            self.cellMarketPriceYuan=[[UILabel alloc]initWithFrame:CGRectMake(6+self.cellPic.bounds.size.width+8+self.cellSellPriceYuan.bounds.size.width, self.cellSellPriceYuan.frame.origin.y+3, 50, 40)];
            self.cellMarketPriceYuan.font=[UIFont systemFontOfSize:10];
            self.cellMarketPriceYuan.textColor=[UIColor lightGrayColor];
            self.cellMarketPriceYuan.textAlignment=NSTextAlignmentLeft;
            [self addSubview:self.cellMarketPriceYuan];
            
            self.line=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.cellMarketPriceYuan.bounds.size.height/2-1, self.cellMarketPriceYuan.bounds.size.width, 1.5)];
            self.line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
            [self.cellMarketPriceYuan addSubview:self.line];
            self.line.alpha=0;
        }
    }

    if (self.marketPriceYuan!=0) {
        self.cellMarketPriceYuan.text=[NSString stringWithFormat:@"￥%d",self.marketPriceYuan];
        self.line.alpha=1;
        [self.cellMarketPriceYuan sizeToFit];
        self.line.frame=CGRectMake(0,self.cellMarketPriceYuan.bounds.size.height/2-1, self.cellMarketPriceYuan.bounds.size.width, 1.5);
    }
    
    if (!self.cellOrderCount) {
        self.cellOrderCount=[[UILabel alloc]initWithFrame:CGRectMake(6+self.cellPic.bounds.size.width+5, 60, 200, 20)];
        self.cellOrderCount.font=[UIFont systemFontOfSize:10];
        self.cellOrderCount.textColor=[UIColor grayColor];
        self.cellOrderCount.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.cellOrderCount];
    }
    if (self.orderCount!=0) {
        self.cellOrderCount.text=[NSString stringWithFormat:@"￥%d人已购买",self.orderCount];
    }
    if (!self.cellPay) {
        self.cellPay=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.cellPay setBackgroundImage:[UIImage imageNamed:@"voiceWindowBtnStartNormal.png"] forState:UIControlStateNormal];
        [self.cellPay setTitle:@"立即购买" forState:UIControlStateNormal];
        [self.cellPay addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        self.cellPay.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        [self.cellPay setTintColor:[UIColor whiteColor]];
        [self addSubview:self.cellPay];
        self.cellPay.frame=CGRectMake(self.bounds.size.width-65, 45, 60, 25);
    }
    
}




-(void)pay
{
    if ([self.delegate respondsToSelector:@selector(pay)]) {
        [self.delegate pay];
    }
}
@end
