//
//  NearDetailHeadCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/10/10.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import "NearDetailHeadCell.h"

@implementation NearDetailHeadCell
{
    UIImageView *_rateImageView;
    UIImageView *_commentImageView;
    UIImageView *_priceImageView;
    UILabel *_rateLabel;
    UILabel *_commentLabel;
    UILabel *_priceLabel;
    UIImageView *_lineImageView;
    UIImageView *_line2ImageView;
    
    UILabel *_userRateLabel;
    UILabel *_userCommentLabel;
    UILabel *_userPriceLabel;
}
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_rateImageView) {
        _rateImageView=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _rateImageView.frame=CGRectMake(self.bounds.size.width/3-100, 20, 21, 21);
        }else
        {
            _rateImageView.frame=CGRectMake(self.bounds.size.width/3-50, 20, 21, 21);
        }
        _rateImageView.image=[UIImage imageNamed:@"detailHotelIconEvaluate.png"];
        [self.contentView addSubview:_rateImageView];
        
        _rateLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _rateLabel.frame=CGRectMake(_rateImageView.bounds.size.width+_rateImageView.frame.origin.x+10, 20, 100, 21);
            _rateLabel.font=[UIFont boldSystemFontOfSize:16];
        }else
        {
            _rateLabel.frame=CGRectMake(_rateImageView.bounds.size.width+_rateImageView.frame.origin.x+10, 20, 100, 21);
            _rateLabel.font=[UIFont boldSystemFontOfSize:14];
        }
        [self.contentView addSubview:_rateLabel];
        _rateLabel.textColor=[UIColor blackColor];
        _rateLabel.text=@"好评率";
    }
    
    if (!_commentImageView) {
        _commentImageView=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _commentImageView.frame=CGRectMake(self.bounds.size.width/3*2-100, 20, 21, 21);
        }else
        {
            _commentImageView.frame=CGRectMake(self.bounds.size.width/3-50, 20, 21, 21);
        }
        [self.contentView addSubview:_commentImageView];
        _commentImageView.image=[UIImage imageNamed:@"detailHotelIconComment.png"];

        _commentLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _commentLabel.frame=CGRectMake(_commentImageView.bounds.size.width+_commentImageView.frame.origin.x+10, 20, 100, 21);
            _commentLabel.font=[UIFont boldSystemFontOfSize:16];
        }else
        {
            _commentLabel.frame=CGRectMake(_commentImageView.bounds.size.width+_commentImageView.frame.origin.x+10, 20, 100, 21);
            _commentLabel.font=[UIFont boldSystemFontOfSize:14];
        }
        [self.contentView addSubview:_commentLabel];
        _commentLabel.textColor=[UIColor blackColor];
        _commentLabel.text=@"点评数";

    }

    if (!_priceImageView) {
        _priceImageView=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _priceImageView.frame=CGRectMake(self.bounds.size.width-100, 20, 21, 21);
        }else
        {
            _priceImageView.frame=CGRectMake(self.bounds.size.width-50, 20, 21, 21);
        }
        [self.contentView addSubview:_priceImageView];
        _priceImageView.image=[UIImage imageNamed:@"detailHotelIconPrice.png"];

        _priceLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _priceLabel.frame=CGRectMake(_priceImageView.bounds.size.width+_priceImageView.frame.origin.x+10, 20, 100, 21);
            _priceLabel.font=[UIFont boldSystemFontOfSize:16];
        }else
        {
            _priceLabel.frame=CGRectMake(_priceImageView.bounds.size.width+_priceImageView.frame.origin.x+10, 20, 100, 21);
            _priceLabel.font=[UIFont boldSystemFontOfSize:14];
        }
        [self.contentView addSubview:_priceLabel];
        _priceLabel.textColor=[UIColor blackColor];
        _priceLabel.text=@"价格";

    }
    
    if (!_userRateLabel) {
        _userRateLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _userRateLabel.frame=CGRectMake(0, _rateLabel.bounds.size.height+20, self.bounds.size.width/3, 40);
            _userRateLabel.font=[UIFont italicSystemFontOfSize:20];
        }else
        {
            _userRateLabel.frame=CGRectMake(0, _rateLabel.bounds.size.height+20, self.bounds.size.width/3, 40);
            _userRateLabel.font=[UIFont italicSystemFontOfSize:16];

        }
        [self.contentView addSubview:_userRateLabel];
        _userRateLabel.textAlignment=NSTextAlignmentCenter;

    }
    
    if (!_userCommentLabel) {
        _userCommentLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _userCommentLabel.frame=CGRectMake(self.bounds.size.width/3, _rateLabel.bounds.size.height+20, self.bounds.size.width/3, 40);
            _userCommentLabel.font=[UIFont italicSystemFontOfSize:20];
        }else
        {
            _userCommentLabel.frame=CGRectMake(self.bounds.size.width/3, _rateLabel.bounds.size.height+20, self.bounds.size.width/3, 40);
            _userCommentLabel.font=[UIFont italicSystemFontOfSize:16];
            
        }
        [self.contentView addSubview:_userCommentLabel];
        _userCommentLabel.textAlignment=NSTextAlignmentCenter;

    }
    
    if (!_userPriceLabel) {
        _userPriceLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _userPriceLabel.frame=CGRectMake(self.bounds.size.width/3*2, _rateLabel.bounds.size.height+20, self.bounds.size.width/3, 40);
            _userPriceLabel.font=[UIFont italicSystemFontOfSize:20];
        }else
        {
            _userPriceLabel.frame=CGRectMake(self.bounds.size.width/3*2, _rateLabel.bounds.size.height+20, self.bounds.size.width/3, 40);
            _userPriceLabel.font=[UIFont italicSystemFontOfSize:16];
            
        }
        [self.contentView addSubview:_userPriceLabel];
        _userPriceLabel.textAlignment=NSTextAlignmentCenter;
    }
    
    if (self.cellCommentCount) {
        _userCommentLabel.text=self.cellCommentCount;
    }
    
    if (self.cellCommentGoodRate) {
        _userRateLabel.text=self.cellCommentGoodRate;
    }
    
    if (self.cellProductSellPrice) {
        _userPriceLabel.text=self.cellProductSellPrice;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
