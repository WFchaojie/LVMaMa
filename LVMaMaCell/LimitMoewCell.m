//
//  LimitMoewCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/7.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LimitMoewCell.h"
#define PicHeight 150
#define Width     8
#define Font      13
@implementation LimitMoewCell
{
    NSTimer *_restTimeTimer;
    int _height;
    UIView *_grayView;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _height=0;
    if (!_grayView) {
        _grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10)];
        _grayView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
        [self addSubview:_grayView];
    }
    if (!self.cellPic) {
        self.cellPic=[[UIImageView alloc]initWithFrame:CGRectMake(0,10,self.bounds.size.width, PicHeight)];
        [self addSubview:self.cellPic];
    }
    
    if (!self.cellProductName) {
        self.cellProductName=[[UILabel alloc]initWithFrame:CGRectMake(Width, PicHeight+10, self.bounds.size.width-85, 30)];
        self.cellProductName.numberOfLines=0;
        [self addSubview:self.cellProductName];
        self.cellProductName.font=[UIFont systemFontOfSize:Font];
        self.cellProductName.textColor=[UIColor blackColor];
    }
    
    if (!self.cellDiscountV200) {
        self.cellDiscountV200=[[UILabel alloc]initWithFrame:CGRectMake(Width, PicHeight+10+7, self.bounds.size.width-85, 30)];
        self.cellDiscountV200.backgroundColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
        self.cellDiscountV200.textColor=[UIColor whiteColor];
        self.cellDiscountV200.numberOfLines=1;
        [self addSubview:self.cellDiscountV200];
        self.cellDiscountV200.font=[UIFont boldSystemFontOfSize:9];
    }
    
    if (!self.cellAddress) {
        self.cellAddress=[[UILabel alloc]init];
        self.cellAddress.numberOfLines=0;
        [self addSubview:self.cellAddress];
        self.cellAddress.font=[UIFont systemFontOfSize:Font];
        self.cellAddress.textColor=[UIColor blackColor];
    }
    
    if (self.pic) {
        [self.cellPic sd_setImageWithURL:[NSURL URLWithString:self.pic] placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
    }
    
    if (self.discountV200) {
        self.cellDiscountV200.text=self.discountV200;
        self.cellDiscountV200.textAlignment=NSTextAlignmentCenter;
        [self.cellDiscountV200 sizeToFit];
        [self resize:self.cellDiscountV200];
    }
    if (!self.cellSellPriceYuan) {
        self.cellSellPriceYuan=[[UILabel alloc]init];
        self.cellSellPriceYuan.numberOfLines=0;
        [self addSubview:self.cellSellPriceYuan];
        self.cellSellPriceYuan.textColor=[UIColor grayColor];
        self.cellSellPriceYuan.font=[UIFont systemFontOfSize:11];
    }
    if (!self.separateLine) {
        self.separateLine=[[UIImageView alloc]init];
        self.separateLine.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [self addSubview:self.separateLine];
    }
    
    if (!self.cellHint) {
        self.cellHint=[[UILabel alloc]init];
        self.cellHint.font=[UIFont boldSystemFontOfSize:13];
        self.cellHint.textColor=[UIColor orangeColor];
        self.cellHint.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.cellHint];
    }
    
    if (!self.cellRestTime) {
        self.cellRestTime=[[UILabel alloc]init];
        self.cellRestTime.font=[UIFont systemFontOfSize:14];
        self.cellRestTime.textColor=[UIColor whiteColor];
        self.cellRestTime.textAlignment=NSTextAlignmentLeft;
        
        self.backColor=[[UIView alloc]init];
        self.backColor.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [self addSubview:self.backColor];
        
        self.tian=[[UILabel alloc]init];
        self.tian.text=@"天";
        self.tian.textColor=[UIColor grayColor];
        self.tian.font=[UIFont systemFontOfSize:14];
        self.tian.backgroundColor=[UIColor whiteColor];
        self.tian.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.tian];
        
        self.dian=[[UILabel alloc]init];
        self.dian.text=@":";
        self.dian.textColor=[UIColor grayColor];
        self.dian.font=[UIFont systemFontOfSize:14];
        self.dian.backgroundColor=[UIColor whiteColor];
        self.dian.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.dian];
        
        self.dian1=[[UILabel alloc]init];
        self.dian1.text=@":";
        self.dian1.textColor=[UIColor grayColor];
        self.dian1.font=[UIFont systemFontOfSize:14];
        self.dian1.backgroundColor=[UIColor whiteColor];
        self.dian1.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.dian1];
        [self addSubview:self.cellRestTime];

    }
    
    if (self.productName) {
        NSString *string=[NSString stringWithFormat:@"         %@",self.productName];
        CGSize size=CGSizeMake(self.bounds.size.width-Width*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:Font];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
        self.cellProductName.attributedText=attribute;
        
        self.cellProductName.frame=CGRectMake(Width, PicHeight+10+5, self.bounds.size.width-Width*2, actualSize.height);
        
        if (self.address) {
            self.cellAddress.frame=CGRectMake(Width, PicHeight+3+actualSize.height+10, self.bounds.size.width-85, 30);
            self.cellAddress.text=self.address;
        }
        
        if(self.sellPriceYuan)
        {
            NSString *stockCountstring=[NSString stringWithFormat:@"￥%@起",self.sellPriceYuan];
            UIFont *font=[UIFont boldSystemFontOfSize:13];
            NSMutableAttributedString *stockAttribute=[[NSMutableAttributedString alloc]initWithString:stockCountstring];
            NSDictionary *stockColor=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
            [stockAttribute addAttributes:stockColor range:NSMakeRange(0,stockCountstring.length-1)];
            
            self.cellSellPriceYuan.attributedText=stockAttribute;
            self.cellSellPriceYuan.frame=CGRectMake(2,actualSize.height+PicHeight+30+10, 100, 20);
            [self.cellSellPriceYuan sizeToFit];
	
            
            if (!self.cellMarketPriceYuan) {
                self.cellMarketPriceYuan=[[UILabel alloc]init];
                self.cellMarketPriceYuan.font=[UIFont boldSystemFontOfSize:10];
                self.cellMarketPriceYuan.textColor=[UIColor lightGrayColor];
                self.cellMarketPriceYuan.textAlignment=NSTextAlignmentLeft;
                [self addSubview:self.cellMarketPriceYuan];
                
                self.line=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.cellMarketPriceYuan.bounds.size.height/2-1, self.cellMarketPriceYuan.bounds.size.width, 1.5)];
                self.line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
                [self.cellMarketPriceYuan addSubview:self.line];
                self.line.alpha=0;
            }
            
            if (!self.cellStockCount) {
                self.cellStockCount=[[UILabel alloc]init];
                self.cellStockCount.font=[UIFont boldSystemFontOfSize:12];
                self.cellStockCount.textColor=[UIColor lightGrayColor];
                self.cellStockCount.textAlignment=NSTextAlignmentRight;
                [self addSubview:self.cellStockCount];
            }
            
            if (!self.cellRecommandName) {
                self.cellRecommandName=[[UILabel alloc]init];
                self.cellRecommandName.font=[UIFont boldSystemFontOfSize:13];
                self.cellRecommandName.textColor=[UIColor grayColor];
                self.cellRecommandName.textAlignment=NSTextAlignmentLeft;
                self.cellRecommandName.numberOfLines=0;
                [self addSubview:self.cellRecommandName];
            }
            

        
        }
        if (self.marketPriceYuan) {
            self.cellMarketPriceYuan.text=[NSString stringWithFormat:@"￥%@",self.marketPriceYuan];
            self.cellMarketPriceYuan.frame=CGRectMake(6+self.cellSellPriceYuan.bounds.size.width, self.cellSellPriceYuan.frame.origin.y+3, 50, self.cellSellPriceYuan.bounds.size.height);
            [self.cellMarketPriceYuan sizeToFit];
            self.line.alpha=1;
            self.line.frame=CGRectMake(0,self.cellMarketPriceYuan.bounds.size.height/2-1, self.cellMarketPriceYuan.bounds.size.width, 1.5);
        }
        
        if (self.stockCount) {
            NSString *stockCountstring=[NSString stringWithFormat:@"仅余%@份",self.stockCount];
            UIFont *font=[UIFont boldSystemFontOfSize:12];
            NSMutableAttributedString *stockAttribute=[[NSMutableAttributedString alloc]initWithString:stockCountstring];
            NSDictionary *stockColor=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
            [stockAttribute addAttributes:stockColor range:NSMakeRange(2,self.stockCount.length)];
            
            self.cellStockCount.attributedText=stockAttribute;
            
            self.cellStockCount.frame=CGRectMake(0, self.cellSellPriceYuan.frame.origin.y, self.bounds.size.width-8, 12);
        }
        
        if (self.recommandName) {
            NSString *string=self.recommandName;
            CGSize size=CGSizeMake(self.bounds.size.width-Width*2, 1000);
            UIFont *font=[UIFont systemFontOfSize:Font];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
            self.cellRecommandName.frame=CGRectMake(Width,self.cellSellPriceYuan.frame.origin.y+self.cellSellPriceYuan.bounds.size.height+5, self.bounds.size.width-Width*2, actualSize.height);
            _height+=actualSize.height;
            self.cellRecommandName.attributedText=attribute;
            
            self.separateLine.frame=CGRectMake(0,self.cellRecommandName.bounds.size.height+self.cellRecommandName.frame.origin.y+5, self.bounds.size.width, 1);
            
            self.cellHint.frame=CGRectMake(Width, self.separateLine.frame.origin.y+7, 100, 13);
            self.cellHint.text=@"抢购中";
        }
        
        if (self.restTime) {
            self.cellRestTime.frame=CGRectMake(self.bounds.size.width-120-Width, self.separateLine.frame.origin.y+5, 120, 20);
            self.cellRestTime.text=[self getRestTime:self.restTime];
            [self.cellRestTime sizeToFit];

            self.backColor.frame=CGRectMake(self.bounds.size.width-120-Width-3, self.cellRestTime.frame.origin.y, self.cellRestTime.frame.size.width+6, self.cellRestTime.bounds.size.height);
            
            self.tian.frame=CGRectMake(self.bounds.size.width-120-Width+18, self.cellRestTime.frame.origin.y, 16, self.cellRestTime.frame.size.height);
            
            self.dian.frame=CGRectMake(self.bounds.size.width-120-Width+57, self.cellRestTime.frame.origin.y, 12, self.cellRestTime.frame.size.height);
            
            self.dian1.frame=CGRectMake(self.bounds.size.width-120-Width+89, self.cellRestTime.frame.origin.y, 12, self.cellRestTime.frame.size.height);
            [self createRestTimeTimer];
            
           // NSLog(@"%.f",self.cellRestTime.bounds.size.height+self.cellRestTime.frame.origin.y-150-_height);
            NSLog(@"cell=%d",_height);
        }
    }
}
-(void)createRestTimeTimer
{
    _restTimeTimer=[NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(restTimeUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_restTimeTimer forMode:NSRunLoopCommonModes];
}
-(void)restTimeUpdate
{
    self.cellRestTime.text=[self getRestTime:self.restTime];
}
#pragma mark 获取限时抢购的剩余时间
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
    
    restTime=[NSString stringWithFormat:@"%.2ld     %.2ld    %.2ld    %.2ld",dd/86400,dd%86400/3600,dd%86400%3600/60,dd%86400%3600%60];
    //    NSLog(@"%@",restTime);
    
    return restTime;
}

-(void)resize:(UIView *)view
{
    CGRect rect=view.frame;
    rect.size.width+=3;
    view.frame=rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
