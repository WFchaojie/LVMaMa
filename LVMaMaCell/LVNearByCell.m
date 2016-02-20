//
//  LVNearByCell.m
//  LVMaMa
//
//  Created by apple on 15-6-5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVNearByCell.h"
#import "UIImageView+WebCache.h"
@implementation LVNearByCell
{
    UIImageView *_pic;
    UILabel *_title;
    UIImageView *_thumb;
    UILabel *_detail;
    UILabel *_distance;
    UILabel *_placeType;
    UILabel *_price;
    UILabel *_priceBack;

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
    if (!_pic) {
        _pic=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _pic.frame=CGRectMake(10,10, 100, 75);
        }else
        {
            _pic.frame=CGRectMake(10,10, 80, 55);
        }
        [self addSubview:_pic];
    }
    
    if (!_title) {
        _title=[[UILabel alloc]initWithFrame:CGRectMake(_pic.bounds.size.width+10+10, 2, self.bounds.size.width-90, 25)];
        if (iPhone6Plus) {
            _title.font=[UIFont boldSystemFontOfSize:15];
        }else
        {
            _title.font=[UIFont boldSystemFontOfSize:12];
        }
        _title.textColor=[UIColor blackColor];
        [self addSubview:_title];
    }
    
    if (!_detail) {
        _detail=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _detail.frame=CGRectMake(_pic.bounds.size.width+10+10, self.bounds.size.height-22, self.bounds.size.width-160, 12);
        }else
        {
            _detail.frame=CGRectMake(_pic.bounds.size.width+10+10, self.bounds.size.height-22, self.bounds.size.width-130, 12);
        }
        _detail.textColor=[UIColor grayColor];
        [self addSubview:_detail];
        _detail.font=[UIFont systemFontOfSize:10];
    }
    
    if (!_distance) {
        _distance=[[UILabel alloc]init];
        _distance.textColor=[UIColor grayColor];
        [self addSubview:_distance];
        if (iPhone6Plus) {
            _distance.font=[UIFont systemFontOfSize:12];
            _distance.frame=CGRectMake(self.bounds.size.width-55, self.bounds.size.height-22, 60, 12);
        }else
        {
            _distance.font=[UIFont systemFontOfSize:10];
            _distance.frame=CGRectMake(self.bounds.size.width-35, self.bounds.size.height-22, 40, 12);
        }
    }
    
    if (!_placeType) {
        _placeType=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _placeType.frame=CGRectMake(100+20, 33+8, 50, 15);
        }else
        {
            _placeType.frame=CGRectMake(100, 33, 50, 15);
        }
        _placeType.textColor=[UIColor whiteColor];
        [self addSubview:_placeType];
        _placeType.backgroundColor=[UIColor colorWithRed:0.24 green:0.67 blue:1 alpha:1];
        _placeType.font=[UIFont boldSystemFontOfSize:11];
        _placeType.textAlignment=NSTextAlignmentCenter;
    }
    
    if (!_wifi) {
        _wifi=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _wifi.frame=CGRectMake(160+20,33+8, 16, 16);
        }else
        {
            _wifi.frame=CGRectMake(160,33, 16, 16);
        }
        _wifi.image=[UIImage imageNamed:@"detailHotelIconSet.png"];
        [self addSubview:_wifi];
        _wifi.alpha=0;
    }
    
    if (!_park) {
        _park=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _park.frame=CGRectMake(176+20,33+8, 16, 16);
        }else
        {
            _park.frame=CGRectMake(176,33, 16, 16);
        }
        _park.image=[UIImage imageNamed:@"listHotelIconP.png"];
        [self addSubview:_park];
        _park.alpha=0;
    }
    
    if (!_price) {
        _price=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _price.font=[UIFont boldSystemFontOfSize:11];
            _price.frame=CGRectMake(self.bounds.size.width-65, 25, 60, 20);
        }else
        {
            _price.font=[UIFont boldSystemFontOfSize:11];
            _price.frame=CGRectMake(self.bounds.size.width-65, 20, 60, 20);
        }
        _price.textColor=[UIColor grayColor];
        [self addSubview:_price];
        _price.textAlignment=NSTextAlignmentRight;
    }
    
    if (!_priceBack) {
        _priceBack=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-45, 40+5, 40, 9)];
        _priceBack.textColor=[UIColor whiteColor];
        _priceBack.backgroundColor=[UIColor colorWithRed:1 green:0 blue:0.53 alpha:1];
        [self addSubview:_priceBack];
        _priceBack.font=[UIFont boldSystemFontOfSize:9];
    }
    
    if (self.cellTitle.length!=0) {
        _title.text=self.cellTitle;
    }
    
    if (self.cellDistance.length!=0) {
        _distance.text=self.cellDistance;
    }
    
    if (self.cellDetail.length!=0) {
        _detail.text=self.cellDetail;
    }
    
    if (self.cellPlaceType.length!=0) {
        _placeType.text=self.cellPlaceType;
    }
    
    if (_cellWifi==YES) {
        _wifi.alpha=1;
    }
    
    if (_cellPark==YES) {
        _park.alpha=1;
    }
    
    if (self.cellPrice.length!=0) {
        
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_cellPrice];
        NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15.0],NSFontAttributeName,[UIColor colorWithRed:1 green:0 blue:0.53 alpha:1],NSForegroundColorAttributeName,nil];
        
        [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0, _cellPrice.length-1)];
        
        _price.attributedText=attributedStr;
        _priceBack.text=_cellPriceBack;
        [_priceBack sizeToFit];
        CGRect rect=_priceBack.frame;
        rect.origin.x=[UIScreen mainScreen].bounds.size.width-5-rect.size.width;
        
        if (iPhone6Plus) {
            rect.origin.y=_price.frame.origin.y+25;
        }
        
        _priceBack.frame=rect;
    }
    
    [_pic sd_setImageWithURL:[NSURL URLWithString:self.cellPic] placeholderImage:[UIImage imageNamed:@"defaultCellImage.png"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
