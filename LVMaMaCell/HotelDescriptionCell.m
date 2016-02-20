//
//  HotelDescriptionCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/10/12.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import "HotelDescriptionCell.h"

@implementation HotelDescriptionCell
{
    UIImageView *_pic;
    UIImageView *_line;
    UILabel *_titleLabel;
    UILabel *_infoLabel;
    UIImageView *_arearImageView;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_arearImageView) {
        _arearImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        _arearImageView.frame=CGRectMake(0, 0, self.bounds.size.width, 10);
        [self.contentView addSubview:_arearImageView];
    }
    
    if (!_pic) {
        _pic=[[UIImageView alloc]init];
        _pic.frame=CGRectMake(8,_arearImageView.frame.origin.y+_arearImageView.bounds.size.height + 8, 16, 16);
        [self.contentView addSubview:_pic];
    }
    
    if (_picString) {
        _pic.image=[UIImage imageNamed:_picString];
    }
    
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.frame=CGRectMake(_pic.frame.origin.x+_pic.frame.size.width+5, _pic.frame.origin.y-5, 100, 25);
        _titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (self.titleHint) {
        _titleLabel.text=self.titleHint;
    }
    
    if (!_line) {
        _line=[[UIImageView alloc]init];
        _line.frame=CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.bounds.size.width, 1);
        _line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [self.contentView addSubview:_line];
    }
    
    if (!_infoLabel) {
        _infoLabel=[[UILabel alloc]init];
        _infoLabel.frame=CGRectMake(10, _line.frame.origin.y+5, self.bounds.size.width-10*2, 30);
        _infoLabel.numberOfLines=0;
        _infoLabel.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_infoLabel];
        _infoLabel.textColor=[UIColor grayColor];
    }
    
    if (self.info) {
        if (self.info.length) {
            [self resizeContent];
            _infoLabel.text=self.info;
        }
    }
}

-(void)resizeContent
{
    CGSize size=CGSizeMake(self.bounds.size.width-10*2, 1000);
    UIFont *font;
    if (iPhone6Plus) {
        font=[UIFont systemFontOfSize:12];
    }else
    {
        font=[UIFont systemFontOfSize:10];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing=1;
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
    CGSize actualSize=[self.info boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    CGRect rect=_infoLabel.frame;
    rect.size.height=actualSize.height;
    _infoLabel.frame=rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
