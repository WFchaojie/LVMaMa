//
//  LVHomeCell.m
//  LVMaMa
//
//  Created by apple on 15-5-31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeCell.h"
#import "UIImageView+WebCache.h"
@implementation LVHomeCell
{
    UIImageView *_LVpic;
    UILabel *_LVtitle;
    UILabel *_LVDetail;
    UILabel *_LVprice;
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
    
    if (!_LVpic) {
        _LVpic=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            _LVpic.frame=CGRectMake(0, 0, self.bounds.size.width, HomeCellHeight);
        }else
        {
            _LVpic.frame=CGRectMake(0, 0, self.bounds.size.width, 130);
        }
        _LVpic.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_LVpic];
    }
    
    if (!_LVtitle) {
        _LVtitle=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _LVtitle.font=[UIFont boldSystemFontOfSize:13];
            _LVtitle.frame=CGRectMake(10, _LVpic.bounds.size.height, 200, 30);
        }else
        {
            _LVtitle.font=[UIFont boldSystemFontOfSize:12];
            _LVtitle.frame=CGRectMake(10, _LVpic.bounds.size.height, 200, 20);
        }
        [self.contentView addSubview:_LVtitle];
    }
    
    if (!_LVDetail) {
        _LVDetail=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _LVDetail.font=[UIFont boldSystemFontOfSize:12];
            _LVDetail.frame=CGRectMake(10, _LVtitle.bounds.size.height+30, self.bounds.size.width-30, 30);
        }else
        {
            _LVDetail.font=[UIFont boldSystemFontOfSize:10];
            _LVDetail.frame=CGRectMake(10, _LVtitle.bounds.size.height+20, self.bounds.size.width-30, 30);
        }
        _LVDetail.numberOfLines=0;
        _LVDetail.textColor=[UIColor grayColor];
        [self.contentView addSubview:_LVDetail];
    }
    
    if (!_area) {
        _area=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        [self.contentView addSubview:_area];
    }
    
    if (self.Lvpic.length!=0) {
        [_LVpic sd_setImageWithURL:[NSURL URLWithString:self.Lvpic] placeholderImage:[UIImage imageNamed:@"defaultCellImage.png"]];
        CGSize size=CGSizeMake(self.bounds.size.width-30, 1000);
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
        CGSize actualSize=[self.LvDetail boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        if (iPhone6Plus) {
            _LVDetail.frame=CGRectMake(10, _LVpic.bounds.size.height+26, self.bounds.size.width-30, actualSize.height);
        }else
        {
            _LVDetail.frame=CGRectMake(10, _LVpic.bounds.size.height+20, self.bounds.size.width-30, actualSize.height);
        }
        
        NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:self.LvDetail];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.LvDetail.length)];
        _LVDetail.attributedText=str;
        _LVtitle.text=self.Lvtitle;
        if (iPhone6Plus) {
            _area.frame=CGRectMake(0,_LVpic.bounds.size.height+30+actualSize.height+5, self.bounds.size.width, 10);
        }else
        {
            _area.frame=CGRectMake(0,_LVpic.bounds.size.height+20+actualSize.height+5, self.bounds.size.width, 10);
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
