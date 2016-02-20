//
//  LVTicketCell.m
//  LVMaMa
//
//  Created by apple on 15-6-6.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVTicketCell.h"

@implementation LVTicketCell

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
    if (!_pic) {
        _pic=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _pic.frame=CGRectMake(10,10, 120, 80);
        }else
        {
            _pic.frame=CGRectMake(10,10, 80, 55);
        }
        [self addSubview:_pic];
    }
    if (!_title) {
        _title=[[UILabel alloc]initWithFrame:CGRectMake(_pic.bounds.size.width+10+10, 10, self.bounds.size.width-90, 25)];
        _title.textColor=[UIColor blackColor];
        [self addSubview:_title];
        if (iPhone6Plus) {
            _title.font=[UIFont boldSystemFontOfSize:16];
        }else
        {
            _title.font=[UIFont boldSystemFontOfSize:12];
        }
    }
    
    if (!_price) {
        _price=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-70, 13, 60, 20)];
        _price.textColor=[UIColor grayColor];
        [self addSubview:_price];
        if (iPhone6Plus) {
            _price.font=[UIFont boldSystemFontOfSize:15];
        }else
        {
            _price.font=[UIFont boldSystemFontOfSize:11];
        }
        _price.textAlignment=NSTextAlignmentRight;
    }
    
    if (!_type) {
        _type=[[UILabel alloc]initWithFrame:CGRectMake(_pic.bounds.size.width+10+10, 49, self.bounds.size.width/2, 20)];
        _type.textColor=[UIColor grayColor];
        [self addSubview:_type];
        _type.textAlignment=NSTextAlignmentLeft;
        if (iPhone6Plus) {
            _type.font=[UIFont boldSystemFontOfSize:13];
            
        }else
        {
            _type.font=[UIFont boldSystemFontOfSize:11];
        }
    }
    
    if (_cellType) {
        _type.text=_cellType;
    }
    
    if (self.cellPrice.length!=0) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_cellPrice];
        NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15.0],NSFontAttributeName,[UIColor colorWithRed:1 green:0 blue:0.53 alpha:1],NSForegroundColorAttributeName,nil];
        
        [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0, _cellPrice.length-1)];
        
        _price.attributedText=attributedStr;
    }
    if (!_priceMarket) {
        _priceMarket=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-38, _type.frame.origin.y, 20, 12)];
        _priceMarket.textColor=[UIColor lightGrayColor];
        [self addSubview:_priceMarket];
        _priceMarket.font=[UIFont boldSystemFontOfSize:12];
        _priceMarket.textAlignment=NSTextAlignmentLeft;
        
        
        _line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        [self addSubview:_line];
    }
    
    if (self.cellPriceMarket) {
        _priceMarket.text=self.cellPriceMarket;
        [_priceMarket sizeToFit];
        _line.frame=CGRectMake(_priceMarket.frame.origin.x-1, _type.frame.origin.y+6, _priceMarket.bounds.size.width+3, 1);


    }
    
    if (self.cellPic.length!=0||self.cellTitle.length!=0) {
        [_pic sd_setImageWithURL:[NSURL URLWithString:self.cellPic] placeholderImage:[UIImage imageNamed:@"defaultCellImage.png"]];
        _title.text=self.cellTitle;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
