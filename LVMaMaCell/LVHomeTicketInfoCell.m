//
//  LVHomeTicketInfoCell.m
//  LVMaMa
//
//  Created by apple on 15-6-9.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeTicketInfoCell.h"

@implementation LVHomeTicketInfoCell
{
    UIButton *_payButton;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.title) {
        self.title=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 250, 15)];
        [self addSubview:self.title];
        self.title.font=[UIFont boldSystemFontOfSize:13];
        self.title.textColor=[UIColor grayColor];
        self.title.numberOfLines=2;
        
        self.detail=[[UILabel alloc]init];
        [self addSubview:self.detail];
        self.detail.font=[UIFont boldSystemFontOfSize:12];
        self.detail.textColor=[UIColor grayColor];
        
        self.arrow=[[UIImageView alloc]init];
        [self addSubview:self.arrow];
        self.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    }
    
    if (!self.lastOrderLabel) {
        self.lastOrderLabel=[[UILabel alloc]init];
        [self addSubview:self.lastOrderLabel];
        self.lastOrderLabel.font=[UIFont boldSystemFontOfSize:10];
        self.lastOrderLabel.textColor=[UIColor colorWithRed:1 green:0.46 blue:0 alpha:1];
        self.lastOrderLabel.layer.borderColor=[UIColor colorWithRed:1 green:0.46 blue:0 alpha:1].CGColor;
        self.lastOrderLabel.layer.borderWidth=1;
    }
    
    if (!self.firstTagLabel) {
        self.firstTagLabel=[[UILabel alloc]init];
        [self addSubview:self.firstTagLabel];
        self.firstTagLabel.font=[UIFont boldSystemFontOfSize:10];
        self.firstTagLabel.textColor=[UIColor whiteColor];
        self.firstTagLabel.backgroundColor=[UIColor colorWithRed:0.29 green:0.58 blue:0.87 alpha:1];
    }
    
    if (!self.sellPriceLabel) {
        self.sellPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-115-58, 25, 105, 20)];
        self.sellPriceLabel.textColor=[UIColor colorWithRed:0.83 green:0.03 blue:0.46 alpha:1];
        [self addSubview:self.sellPriceLabel];
        self.sellPriceLabel.font=[UIFont boldSystemFontOfSize:14];
        self.sellPriceLabel.textAlignment=NSTextAlignmentRight;
    }
    
    if (!self.refundLabel) {
        self.refundLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-115-70, 40, 105, 20)];
        self.refundLabel.textColor=[UIColor colorWithRed:0.83 green:0.03 blue:0.46 alpha:1];
        [self addSubview:self.refundLabel];
        self.refundLabel.font=[UIFont boldSystemFontOfSize:10];
        self.refundLabel.textAlignment=NSTextAlignmentRight;
    }
    
    if (!self.onLinePic) {
        self.onLinePic=[[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-65, 18, 60, 40)];
        self.onLinePic.image=[UIImage imageNamed:@"payTypeOnline.png"];
        [self addSubview:self.onLinePic];
        self.onLinePic.userInteractionEnabled=YES;

        _payButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame=self.onLinePic.bounds;
        [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [self.onLinePic addSubview:_payButton];
    }
    
    if (!self.deductionLabel) {
        self.deductionLabel=[[UILabel alloc]init];
        [self addSubview:self.deductionLabel];
        self.deductionLabel.font=[UIFont boldSystemFontOfSize:10];
        self.deductionLabel.textColor=[UIColor whiteColor];
        self.deductionLabel.backgroundColor=[UIColor colorWithRed:1 green:0.46 blue:0 alpha:1];
    }
    
    if (!self.promotionLabel) {
        self.promotionLabel=[[UILabel alloc]init];
        [self addSubview:self.promotionLabel];
        self.promotionLabel.font=[UIFont boldSystemFontOfSize:10];
        self.promotionLabel.textColor=[UIColor whiteColor];
        self.promotionLabel.backgroundColor=[UIColor colorWithRed:1 green:0.46 blue:0 alpha:1];
    }
    
    if (!self.marketPriceLabel) {
        self.marketPriceLabel=[[UILabel alloc]init];
        [self addSubview:self.marketPriceLabel];
        self.marketPriceLabel.font=[UIFont boldSystemFontOfSize:10];
        self.marketPriceLabel.textColor=[UIColor grayColor];
        
        self.line=[[UIImageView alloc]init];
        self.line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [self addSubview:self.line];
        
    }
    

    
    if (self.title&&self.ticketTitle.length) {
        CGSize size=CGSizeMake(self.bounds.size.width-120, 1000);
        UIFont *font=[UIFont systemFontOfSize:13];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.ticketTitle boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:self.ticketTitle];
        self.title.attributedText=attribute;
        self.title.text=self.ticketTitle;
        self.title.frame=CGRectMake(5, 5, self.bounds.size.width-120, actualSize.height);
        self.detail.text=@"票型说明";
        self.detail.frame=CGRectMake(5, self.bounds.size.height-20, 100, 15);
        
        self.arrow.image=[UIImage imageNamed:@"inputNextUnable.png"];
        self.arrow.frame=CGRectMake(56, self.bounds.size.height-18, 8, 10);
        
        if (self.firstTag.length!=0) {
            self.firstTagLabel.alpha=1;
            self.firstTagLabel.frame=CGRectMake(5, self.title.bounds.size.height+self.title.frame.origin.y+3, 270, 15);
            self.firstTagLabel.text=self.firstTag;
            [self.firstTagLabel sizeToFit];
            CGRect rect=self.firstTagLabel.frame;
            rect.size.width+=2;
            self.firstTagLabel.frame=rect;
            self.firstTagLabel.textAlignment=NSTextAlignmentCenter;
        }else
        {
            self.firstTagLabel.alpha=0;
        }
        
        if (self.lastOrder.length!=0) {
            self.lastOrderLabel.alpha=1;
            if (self.firstTag.length==0) {
                self.lastOrderLabel.frame=CGRectMake(5, self.title.bounds.size.height+self.title.frame.origin.y+3, 200, 15);
            }else
            {
                self.lastOrderLabel.frame=CGRectMake(7+self.firstTagLabel.bounds.size.width, self.firstTagLabel.frame.origin.y, 200, 15);
            }
            self.lastOrderLabel.text=self.lastOrder;
            [self.lastOrderLabel sizeToFit];
            CGRect rect=self.lastOrderLabel.frame;
            rect.size.width+=2;
            self.lastOrderLabel.frame=rect;
            self.lastOrderLabel.textAlignment=NSTextAlignmentCenter;
            if (self.deduction.length!=0) {
                self.deductionLabel.alpha=1;
                self.deductionLabel.frame=CGRectMake(self.lastOrderLabel.frame.origin.x+self.lastOrderLabel.frame.size.width+3, self.lastOrderLabel.frame.origin.y, 200, 15);
                self.deductionLabel.text=self.deduction;
                [self.deductionLabel sizeToFit];
                CGRect rect=self.deductionLabel.frame;
                rect.size.width+=2;
                self.deductionLabel.frame=rect;
                self.deductionLabel.textAlignment=NSTextAlignmentCenter;
                if (self.promotion.length!=0) {
                    self.promotionLabel.alpha=1;
                    self.promotionLabel.frame=CGRectMake(self.deductionLabel.frame.origin.x+self.deductionLabel.frame.size.width+3, self.deductionLabel.frame.origin.y, 200, 15);
                    self.promotionLabel.text=self.promotion;
                    [self.promotionLabel sizeToFit];
                    CGRect rect=self.promotionLabel.frame;
                    rect.size.width+=2;
                    self.promotionLabel.frame=rect;
                    self.promotionLabel.textAlignment=NSTextAlignmentCenter;
                }else
                {
                    self.promotionLabel.alpha=0;
                }

            }else
            {
                self.deductionLabel.alpha=0;
                if (self.promotion.length!=0) {
                    self.promotionLabel.alpha=1;
                    self.promotionLabel.frame=CGRectMake(self.lastOrderLabel.frame.origin.x+self.lastOrderLabel.frame.size.width+3, self.lastOrderLabel.frame.origin.y, 200, 15);
                    self.promotionLabel.text=self.promotion;
                    [self.promotionLabel sizeToFit];
                    CGRect rect=self.promotionLabel.frame;
                    rect.size.width+=2;
                    self.promotionLabel.frame=rect;
                    self.promotionLabel.textAlignment=NSTextAlignmentCenter;
                }else
                {
                    self.promotionLabel.alpha=0;
                }
            }
        }else
        {
            self.lastOrderLabel.alpha=0;
            if (self.deduction.length!=0&&self.firstTag.length==0) {
                self.deductionLabel.frame=CGRectMake(5,self.title.bounds.size.height+self.title.frame.origin.y+3 , 200, 15);
                self.deductionLabel.text=self.deduction;
                [self.deductionLabel sizeToFit];
                CGRect rect=self.deductionLabel.frame;
                rect.size.width+=2;
                self.deductionLabel.frame=rect;
                self.deductionLabel.textAlignment=NSTextAlignmentCenter;
                if (self.promotion.length!=0) {
                    self.promotionLabel.alpha=1;
                    self.promotionLabel.frame=CGRectMake(self.deductionLabel.frame.origin.x+self.deductionLabel.frame.size.width+3, self.deductionLabel.frame.origin.y, 200, 15);
                    self.promotionLabel.text=self.promotion;
                    [self.promotionLabel sizeToFit];
                    CGRect rect=self.promotionLabel.frame;
                    rect.size.width+=2;
                    self.promotionLabel.frame=rect;
                    self.promotionLabel.textAlignment=NSTextAlignmentCenter;
                }else
                {
                    self.promotionLabel.alpha=0;
                }
            }else if (self.deduction.length!=0&&self.firstTag.length!=0)
            {
                self.deductionLabel.frame=CGRectMake(7+self.firstTagLabel.bounds.size.width,self.title.bounds.size.height+self.title.frame.origin.y+3, 200, 15);
                self.deductionLabel.text=self.deduction;
                [self.deductionLabel sizeToFit];
                CGRect rect=self.deductionLabel.frame;
                rect.size.width+=2;
                self.deductionLabel.frame=rect;
                self.deductionLabel.textAlignment=NSTextAlignmentCenter;
            }
            else
            {
                if (self.promotion.length!=0) {
                    self.promotionLabel.frame=CGRectMake(5,self.title.bounds.size.height+self.title.frame.origin.y+3, 200, 15);
                    self.promotionLabel.text=self.promotion;
                    [self.promotionLabel sizeToFit];
                    CGRect rect=self.promotionLabel.frame;
                    rect.size.width+=2;
                    self.promotionLabel.frame=rect;
                    self.promotionLabel.textAlignment=NSTextAlignmentCenter;
                    self.promotionLabel.alpha=1;
                }else
                {
                    self.promotionLabel.alpha=0;
                }
                self.deductionLabel.alpha=0;
            }
        }
    }
    
    if (self.sellPrice!=0) {
        self.sellPriceLabel.alpha=1;
        NSString *string=[NSString stringWithFormat:@"￥%d",self.sellPrice];
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
        [attribute addAttributes:dict range:NSMakeRange(0,1)];
        self.sellPriceLabel.attributedText=attribute;
    }
    else
    {
        self.sellPriceLabel.alpha=0;
    }
    
    if (self.refund.length!=0) {
        self.refundLabel.text=self.refund;
        [self.refundLabel sizeToFit];
        
        CGRect rect=self.refundLabel.frame;
        rect.origin.x=self.bounds.size.width-self.refundLabel.bounds.size.width-10-58;
        rect.origin.y=self.sellPriceLabel.frame.origin.y+self.sellPriceLabel.bounds.size.height;
        self.refundLabel.frame=rect;
        if (self.marketPrice!=0) {
            self.marketPriceLabel.text=[NSString stringWithFormat:@"￥%d",self.marketPrice];
            self.marketPriceLabel.frame=self.refundLabel.frame;
            [self .marketPriceLabel sizeToFit];
            
            CGRect rect=self.marketPriceLabel.frame;
            rect.origin.x=self.bounds.size.width-self.refundLabel.bounds.size.width-10-56-self.marketPriceLabel.bounds.size.width-5;
            rect.origin.y=self.sellPriceLabel.frame.origin.y+self.sellPriceLabel.bounds.size.height;
            self.marketPriceLabel.frame=rect;
            
            rect.origin.x-=1;
            rect.size.width+=2;
            rect.size.height=1;
            rect.origin.y=self.marketPriceLabel.center.y-1;
            self.line.frame=rect;
            self.marketPriceLabel.alpha=1;
            self.line.alpha=1;
        }
        else
        {
            self.marketPriceLabel.alpha=0;
            self.line.alpha=0;
        }
        self.refundLabel.alpha=1;

    }else
    {
        if (self.marketPrice!=0) {
            self.marketPriceLabel.text=[NSString stringWithFormat:@"￥%d",self.marketPrice];
            self.marketPriceLabel.frame=CGRectMake(self.bounds.size.width-115-58, 40, 105, 20);
            [self .marketPriceLabel sizeToFit];
            
            CGRect rect=self.marketPriceLabel.frame;
            rect.origin.x=self.bounds.size.width-10-58-self.marketPriceLabel.bounds.size.width;
            rect.origin.y=self.sellPriceLabel.frame.origin.y+self.sellPriceLabel.bounds.size.height;
            self.marketPriceLabel.frame=rect;
            
            rect.origin.x-=1;
            rect.size.width+=2;
            rect.size.height=1;
            rect.origin.y=self.marketPriceLabel.center.y-1;
            self.line.frame=rect;
            self.marketPriceLabel.alpha=1;
            self.line.alpha=1;
        }
        else
        {
            self.marketPriceLabel.alpha=0;
            self.line.alpha=0;
        }
        self.refundLabel.alpha=0;
    }
}

-(void)pay
{
    if ([self.delegate respondsToSelector:@selector(pay)]) {
        [self.delegate pay];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
