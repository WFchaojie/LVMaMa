//
//  LVSpecialDefaultCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVSpecialDefaultCell.h"

@implementation LVSpecialDefaultCell
{
    UIImageView *_grayArear;
    UIImageView *_line;
    UIImageView *_line1;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.cellComment) {
        self.cellComment=[[UILabel alloc]init];
        self.cellComment.numberOfLines=0;
        [self addSubview:self.cellComment];
        self.cellComment.textColor=[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        self.cellComment.font=[UIFont systemFontOfSize:11];
        self.cellComment.alpha=0;
    }
    if (!self.celltitle) {
        self.celltitle=[[UILabel alloc]init];
        self.celltitle.numberOfLines=0;
        [self addSubview:self.celltitle];
        self.cellComment.textColor=[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        self.celltitle.font=[UIFont systemFontOfSize:13];
    }
    if (!self.cellLeftImage) {
        self.cellLeftImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 11, 23, 27)];
        [self addSubview:self.cellLeftImage];
    }
    if (self.leftImage) {
        self.cellLeftImage.image=[UIImage imageNamed:self.leftImage];
    }
    
    if (self.celltitle) {
        self.celltitle.text=self.title;
        self.celltitle.frame=CGRectMake(30, 12, 100, 20);
        if (!_grayArear) {
            _grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
            _grayArear.frame=CGRectMake(0, 40, self.bounds.size.width, 10);
            [self addSubview:_grayArear];
            _line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            _line.frame=CGRectMake(0, 40, self.bounds.size.width, 1);
            [self addSubview:_line];
            _line1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            _line1.frame=CGRectMake(0, 50, self.bounds.size.width, 1);
            [self addSubview:_line1];
        }
    }
    if (self.comment!=0) {
        self.cellComment.alpha=1.0;
        self.cellComment.frame=CGRectMake(self.bounds.size.width-70, 20,60, 20);
        self.cellComment.text=[NSString stringWithFormat:@"%d人点评",self.comment];
        
    }
    
}
@end
