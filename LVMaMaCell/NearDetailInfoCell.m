//
//  NearDetailInfoCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/10/11.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import "NearDetailInfoCell.h"

@implementation NearDetailInfoCell
{
    UILabel *_titleLabel;
    UIImageView *_picImageView;
    UILabel *_priceLabel;
    UIButton  *_payButton;
    UILabel *_payType;
    UILabel *_infoLabel;
    UILabel *_roomAreaLabel;
    UILabel *_floorLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _titleLabel.frame=CGRectMake(5, 5, 200, 30);
            _titleLabel.font=[UIFont boldSystemFontOfSize:16];
        }else
        {
            _titleLabel.frame=CGRectMake(5, 5, 200, 30);
            _titleLabel.font=[UIFont boldSystemFontOfSize:16];
        }
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_picImageView) {
        _picImageView=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _picImageView.frame=CGRectMake(5, _titleLabel.bounds.size.height+5, 120, 100);
        }else
        {
            _picImageView.frame=CGRectMake(5, _titleLabel.bounds.size.height+5, 130, 100);
        }
        [self.contentView addSubview:_picImageView];
    }
    
    if (!_priceLabel) {
        _priceLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _priceLabel.frame=CGRectMake(self.bounds.size.width-65, 30, 60, 20);
        }else
        {
            _priceLabel.frame=CGRectMake(self.bounds.size.width-50, 30, 40, 20);
        }
        [self.contentView addSubview:_priceLabel];
    }
    
    if (!_payType) {
        _payType=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _payType.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _picImageView.frame.origin.y, 50, 20);
            _payType.font=[UIFont boldSystemFontOfSize:16];
        }else
        {
            _payType.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _picImageView.frame.origin.y, 50, 20);
            _payType.font=[UIFont boldSystemFontOfSize:14];
        }
        [self.contentView addSubview:_payType];
    }
    
    if (!_infoLabel) {
        _infoLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _infoLabel.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _picImageView.frame.origin.y+_payType.bounds.size.height, 100, 20);
            _infoLabel.font=[UIFont boldSystemFontOfSize:12];
        }else
        {
            _infoLabel.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _picImageView.frame.origin.y, 50, 20);
            _infoLabel.font=[UIFont boldSystemFontOfSize:10];
        }
        _infoLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_infoLabel];
    }
    
    if (!_roomAreaLabel) {
        _roomAreaLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _roomAreaLabel.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _infoLabel.frame.origin.y+_infoLabel.bounds.size.height, 100, 20);
            _roomAreaLabel.font=[UIFont boldSystemFontOfSize:12];
        }else
        {
            _roomAreaLabel.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _infoLabel.frame.origin.y+_infoLabel.bounds.size.height, 100, 20);
            _roomAreaLabel.font=[UIFont boldSystemFontOfSize:10];
        }
        _roomAreaLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_roomAreaLabel];
    }
    
    if (!_floorLabel) {
        _floorLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _floorLabel.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _roomAreaLabel.frame.origin.y+_roomAreaLabel.bounds.size.height, 100, 20);
            _floorLabel.font=[UIFont boldSystemFontOfSize:12];
        }else
        {
            _floorLabel.frame=CGRectMake(_picImageView.bounds.size.width+5+10, _roomAreaLabel.frame.origin.y+_roomAreaLabel.bounds.size.height, 100, 20);
            _floorLabel.font=[UIFont boldSystemFontOfSize:10];
        }
        _floorLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_floorLabel];
    }
    
    if (!_payButton) {
        _payButton=[UIButton buttonWithType:UIButtonTypeCustom];
        if (iPhone6Plus) {
            _payButton.frame=CGRectMake(self.bounds.size.width-80, self.bounds.size.height-60, 68, 50);
        }else
        {
            _payButton.frame=CGRectMake(self.bounds.size.width-70, self.bounds.size.height-55, 68, 50);
        }
        [_payButton setImage:[UIImage imageNamed:@"payTypeOnline.png"] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payButton];
    }
    
    if (self.cellBranchName) {
        _titleLabel.text=self.cellBranchName;
    }
    
    [_picImageView sd_setImageWithURL:[NSURL URLWithString:self.cellImages] placeholderImage:[UIImage imageNamed:@"defaultCellImage.png"]];
    
    if (self.cellSellPrice) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_cellSellPrice];
        
        UIFont *font;
        if (iPhone6Plus) {
            font=[UIFont boldSystemFontOfSize:20];
        }else
        {
            font=[UIFont boldSystemFontOfSize:18];
        }
        NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
        
        [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0, _cellSellPrice.length)];
        
        _priceLabel.attributedText=attributedStr;
    }
    
    
    
    if ([self.cellPayType isEqualToString:@"PAY"]) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"到付"];
        
        UIFont *font;
        if (iPhone6Plus) {
            font=[UIFont boldSystemFontOfSize:12];
        }else
        {
            font=[UIFont boldSystemFontOfSize:10];
        }
        NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor colorWithRed:0.25 green:0.71 blue:0.98 alpha:1],NSForegroundColorAttributeName,nil];
        
        [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0, 2)];
        
        _payType.attributedText=attributedStr;
    }
    
    if (self.cellInfo) {
        _infoLabel.text=self.cellInfo;
    }
    
    if (self.cellRoomArea) {
        _roomAreaLabel.text=self.cellRoomArea;
    }
    
    if (self.cellFloor) {
        _floorLabel.text=self.cellFloor;
    }
}
-(void)pay
{
    if ([self.delegate respondsToSelector:@selector(payClick)]) {
        [self.delegate payClick];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
