//
//  LVHomeSpecialCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/16.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeSpecialCell.h"

@implementation LVHomeSpecialCell

- (void)awakeFromNib {
    // Initialization code
    self.firstTagItems=[[NSArray alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.cellProductName) {
        self.cellProductName=[[UILabel alloc]init];
        self.cellProductName.numberOfLines=0;
        [self addSubview:self.cellProductName];
        self.cellProductName.textColor=[UIColor blackColor];
        self.cellProductName.font=[UIFont systemFontOfSize:13];
    }
    if (!self.cellOrderCount) {
        self.cellOrderCount=[[UILabel alloc]init];
        self.cellOrderCount.numberOfLines=0;
        [self addSubview:self.cellOrderCount];
        self.cellOrderCount.textColor=[UIColor blackColor];
        self.cellOrderCount.font=[UIFont systemFontOfSize:10];
    }
    if (!self.cellOfflineTime) {
        self.cellOfflineTime=[[UILabel alloc]init];
        self.cellOfflineTime.numberOfLines=0;
        [self addSubview:self.cellOfflineTime];
        self.cellOfflineTime.textColor=[UIColor blackColor];
        self.cellOfflineTime.font=[UIFont systemFontOfSize:10];
    }
    if (!self.cellProductId) {
        self.cellProductId=[[UILabel alloc]init];
        self.cellProductId.numberOfLines=0;
        [self addSubview:self.cellProductId];
        self.cellProductId.textColor=[UIColor blackColor];
        self.cellProductId.font=[UIFont systemFontOfSize:10];
        self.cellProductId.textAlignment=NSTextAlignmentRight;
    }
    if (!self.cellSellPriceYuan) {
        self.cellSellPriceYuan=[[UILabel alloc]init];
        self.cellSellPriceYuan.numberOfLines=0;
        [self addSubview:self.cellSellPriceYuan];
        self.cellSellPriceYuan.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
        self.cellSellPriceYuan.font=[UIFont systemFontOfSize:16];
    }
    
    if (self.productName&&self.firstTagItems&&self.orderCount&&self.offlineTime&&self.productId&&self.sellPriceYuan) {
        NSString *string=[NSString stringWithFormat:@"%@",self.productName];
        CGSize size=CGSizeMake(self.bounds.size.width-5*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:13];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
        self.cellProductName.attributedText=attribute;
        self.cellProductName.frame=CGRectMake(5, 2, self.bounds.size.width-10, actualSize.height);
        
        for (int i=0; i<self.firstTagItems.count; i++) {
            UIImageView *backTag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"routeTagBg.png"]];
            backTag.frame=CGRectMake(5+i*57, actualSize.height+5, 54, 15);
            [self addSubview:backTag];
            
            UILabel *tag=[[UILabel alloc]initWithFrame:CGRectMake(2, 0, backTag.bounds.size.width-2, backTag.bounds.size.height)];
            tag.textColor=[UIColor whiteColor];
            tag.font=[UIFont boldSystemFontOfSize:10];
            tag.textAlignment=NSTextAlignmentLeft;
            [backTag addSubview:tag];
            NSDictionary *dict=[self.firstTagItems objectAtIndex:i];
            tag.text=[dict objectForKey:@"name"];
        }
        
        self.cellOrderCount.text=[NSString stringWithFormat:@"%@人已购",self.orderCount];
        self.cellOrderCount.frame=CGRectMake(20, actualSize.height+3+23, 1000, 15);
        [self.cellOrderCount sizeToFit];
        UIImageView *backTag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grouponDetailIcon0.png"]];
        backTag.frame=CGRectMake(5, actualSize.height+2+23, 15, 15);
        [self addSubview:backTag];
        
        UIImageView *time=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grouponDetailIcon1.png"]];
        time.frame=CGRectMake(self.cellOrderCount.frame.size.width+28, actualSize.height+1+23, 15, 15);
        [self addSubview:time];
        
        self.cellOfflineTime.text=[NSString stringWithFormat:@"%@",[self getRestTime:self.offlineTime]];
        self.cellOfflineTime.frame=CGRectMake(self.cellOrderCount.frame.size.width+23+20, actualSize.height+3+23, 1000, 15);
        [self.cellOfflineTime sizeToFit];
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dottedLineImage.png"]];
        line.frame=CGRectMake(0, actualSize.height+3+23+5+13, self.bounds.size.width, 1);
        [self addSubview:line];
        
        self.cellProductId.text=[NSString stringWithFormat:@"产品编号:%@",self.productId];
        self.cellProductId.frame=CGRectMake(self.bounds.size.width-200, actualSize.height+3+23, 195, 15);
        
        NSString *attributeString=[NSString stringWithFormat:@"￥ %@",self.sellPriceYuan];
        UIFont *font1=[UIFont boldSystemFontOfSize:12];
        NSDictionary *fontDict=[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil];
        NSMutableAttributedString *attributeFont=[[NSMutableAttributedString alloc]initWithString:attributeString];
        [attributeFont addAttributes:fontDict range:NSMakeRange(0, 1)];
        self.cellSellPriceYuan.attributedText=attributeFont;
        self.cellSellPriceYuan.frame=CGRectMake(5,actualSize.height+3+23+5+15+10, 100, 20);
        
        UIButton *payButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [payButton setBackgroundImage:[UIImage imageNamed:@"btnRedCorner.png"] forState:UIControlStateNormal];
        payButton.frame=CGRectMake(self.bounds.size.width-125, actualSize.height+3+23+5+15+5, 120, 30);
        [payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [payButton setTitle:@"立刻预定" forState:UIControlStateNormal];
        [self addSubview:payButton];
        payButton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        grayArear.frame=CGRectMake(0, actualSize.height+5+23+5+15+5+30+5, self.bounds.size.width, 10);
        [self addSubview:grayArear];
        
        UIImageView *lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        lineSe.frame=CGRectMake(0, actualSize.height+5+23+5+15+5+30+5, self.bounds.size.width, 1);
        [self addSubview:lineSe];
    }
}

-(void)pay
{
    if ([self.payDelegate respondsToSelector:@selector(pay)]) {
        [self.payDelegate pay];
    }
}

#pragma mark 获取剩余时间
-(NSString *)getRestTime:(NSString *)timeString
{
    NSString *restTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSDate * newdate = [formatter dateFromString:timeString];
    long dd =[newdate timeIntervalSince1970]- (long)[datenow timeIntervalSince1970];
    
    restTime=[NSString stringWithFormat:@"%.2ld天%.2ld时%.2ld分",dd/86400,dd%86400/3600,dd%86400%3600/60];
    //    NSLog(@"%@",restTime);
    return restTime;
}


@end
