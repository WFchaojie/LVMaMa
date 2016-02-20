//
//  LVSecialRecommendCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVSecialRecommendCell.h"
@implementation LVSecialRecommendCell
{
    UIImageView *_zan;
    UILabel *_hint;
    UIImageView *_lineSe;
    UIImageView *_arrow;

}
- (void)awakeFromNib {

    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.cellManagerRecommend) {
        self.cellManagerRecommend=[[UILabel alloc]init];
        self.cellManagerRecommend.numberOfLines=0;
        [self addSubview:self.cellManagerRecommend];
        self.cellManagerRecommend.textColor=[UIColor blackColor];
        self.cellManagerRecommend.font=[UIFont systemFontOfSize:11];
    }
    if (!_arrow) {
        _arrow=[[UIImageView alloc]init];
        [self addSubview:_arrow];
    }
    if (self.managerRecommend) {
        if (!_zan) {
            _zan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 23, 27)];
            _zan.image=[UIImage imageNamed:@"routeDetailIcon14.png"];
            [self addSubview:_zan];
        }
        if (!_hint) {
            _hint=[[UILabel alloc]initWithFrame:CGRectMake(32, 0, 200, 37)];
            _hint.text=@"推荐理由";
            _hint.font=[UIFont systemFontOfSize:14];
            _hint.textColor=[UIColor blackColor];
            _hint.textAlignment=NSTextAlignmentLeft;
            [self addSubview:_hint];
        }

        if (!_lineSe) {
            _lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            _lineSe.frame=CGRectMake(0, 35, self.bounds.size.width, 1);
            [self addSubview:_lineSe];
        }
        if (self.managerRecommend) {
            NSLog(@"cell===%d",_show);

            if (_show==NO) {
                self.cellManagerRecommend.frame=CGRectMake(5, 42, self.bounds.size.width-10, 40);
                self.cellManagerRecommend.text=self.managerRecommend;
                _arrow.frame=CGRectMake(self.bounds.size.width-15,82,12, 8);
                _arrow.image=[UIImage imageNamed:@"expandDown.png"];
            }else
            {
                NSString *string=self.managerRecommend;
                CGSize size=CGSizeMake(self.bounds.size.width-5*2, 1000);
                UIFont *font=[UIFont systemFontOfSize:11];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                self.cellManagerRecommend.frame=CGRectMake(5, 42, self.bounds.size.width-10, actualSize.height);
                self.cellManagerRecommend.text=self.managerRecommend;
                _arrow.frame=CGRectMake(self.bounds.size.width-15,42+actualSize.height,12, 8);
                _arrow.image=[UIImage imageNamed:@"expandUp.png"];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure -the view for the selected state
}

@end
