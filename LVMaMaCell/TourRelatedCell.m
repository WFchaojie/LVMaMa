//
//  TourRelatedCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/19.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "TourRelatedCell.h"

@implementation TourRelatedCell
{
    UIImageView *_LVpic;
    UILabel *_LVtitle;
    UILabel *_LVDetail;
    UILabel *_LVprice;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_LVpic) {
        _LVpic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width-10, 150)];
        [self.contentView addSubview:_LVpic];
    }
    if (!_LVDetail) {
        _LVDetail=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, self.bounds.size.width-30, 30)];
        _LVDetail.numberOfLines=0;
        _LVDetail.textColor=[UIColor grayColor];
        _LVDetail.font=[UIFont systemFontOfSize:10];
        [self.contentView addSubview:_LVDetail];
    }

    if (self.Lvpic.length!=0) {
        [_LVpic sd_setImageWithURL:[NSURL URLWithString:self.Lvpic] placeholderImage:[UIImage imageNamed:@"defaultCellImage.png"]];
        CGSize size=CGSizeMake(self.bounds.size.width-30, 1000);
        UIFont *font=[UIFont systemFontOfSize:10];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing=1;
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
        CGSize actualSize=[self.LvDetail boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        _LVDetail.frame=CGRectMake(10, 160, self.bounds.size.width-30, actualSize.height);
        NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:self.LvDetail];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.LvDetail.length)];
        _LVDetail.attributedText=str;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
