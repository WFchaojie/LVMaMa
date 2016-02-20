//
//  LVSepecialLineRouteCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVSepecialLineRouteCell.h"

@implementation LVSepecialLineRouteCell
{
    UIImageView *_zan;
    UILabel *_hint;
    UIImageView *_lineSe;
    UILabel *_day1;
    UILabel *_day2;
    UIImageView *_bed;
    UIButton *_more;
    UIImageView *_grayArear;
    UIImageView *_line;
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
    if (!self.cellDay1title) {
        self.cellDay1title=[[UILabel alloc]init];
        self.cellDay1title.numberOfLines=0;
        [self addSubview:self.cellDay1title];
        self.cellDay1title.textColor=[UIColor blackColor];
        self.cellDay1title.font=[UIFont systemFontOfSize:11];
    }
    if (!self.cellDay1Content) {
        self.cellDay1Content=[[UILabel alloc]init];
        self.cellDay1Content.numberOfLines=0;
        [self addSubview:self.cellDay1Content];
        self.cellDay1Content.textColor=[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        self.cellDay1Content.font=[UIFont systemFontOfSize:11];
    }
    if (!self.cellDay1StayDesc) {
        self.cellDay1StayDesc=[[UILabel alloc]init];
        self.cellDay1StayDesc.numberOfLines=0;
        [self addSubview:self.cellDay1StayDesc];
        self.cellDay1StayDesc.textColor=[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        self.cellDay1StayDesc.font=[UIFont systemFontOfSize:11];
    }
    if (!self.cellDay2title) {
        self.cellDay2title=[[UILabel alloc]init];
        self.cellDay2title.numberOfLines=0;
        [self addSubview:self.cellDay2title];
        self.cellDay2title.textColor=[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        self.cellDay2title.font=[UIFont systemFontOfSize:11];
    }
    if (!self.cellDay2Content) {
        self.cellDay2Content=[[UILabel alloc]init];
        self.cellDay2Content.numberOfLines=0;
        [self addSubview:self.cellDay2Content];
        self.cellDay2Content.textColor=[UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        self.cellDay2Content.font=[UIFont systemFontOfSize:11];
    }
    if (!_more) {
        _more=[UIButton buttonWithType:UIButtonTypeSystem];
        [_more addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
        _more.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [_more setTintColor:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f]];
        [self addSubview:_more];
        [_more setTitle:@"查看更多行程" forState:UIControlStateNormal];
    }
    if (self.day1Content) {
        if (!_zan) {
            _zan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 23, 27)];
            _zan.image=[UIImage imageNamed:@"routeDetailIcon2.png"];
            [self addSubview:_zan];
        }
        if (!_hint) {
            _hint=[[UILabel alloc]initWithFrame:CGRectMake(32, 0, 200, 37)];
            _hint.text=@"行程说明";
            _hint.font=[UIFont systemFontOfSize:14];
            _hint.textColor=[UIColor blackColor];
            _hint.textAlignment=NSTextAlignmentLeft;
            [self addSubview:_hint];
        }
        if (!_day1) {
            _day1=[[UILabel alloc]initWithFrame:CGRectMake(5, 42, 200, 20)];
            _day1.text=@"DAY 1";
            _day1.font=[UIFont boldSystemFontOfSize:14];
            _day1.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
            _day1.textAlignment=NSTextAlignmentLeft;
            [self addSubview:_day1];
            [_day1 sizeToFit];
        }
        self.cellDay1title.frame=CGRectMake(5+_day1.bounds.size.width+5, 42, [UIScreen mainScreen].bounds.size.width-_day1.bounds.size.width-20, 20);
        self.cellDay1title.text=self.day1Title;
        

        _lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];


        if (!_day2) {
            _day2=[[UILabel alloc]init];
            _day2.text=@"DAY 2";
            _day2.font=[UIFont boldSystemFontOfSize:14];
            _day2.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
            _day2.textAlignment=NSTextAlignmentLeft;
            [self addSubview:_day2];
            [_day2 sizeToFit];
        }
        self.cellDay2title.text=self.day2Title;
        
        self.cellDay2Content.text=self.day2Content;
        
        UIImageView *lineSe1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        [self addSubview:lineSe1];
        
        
        if (!_lineSe) {
            _lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            [self addSubview:_lineSe];
        }
        if (!_grayArear) {
            _grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
            [self addSubview:_grayArear];
            _line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            [self addSubview:_line];
        }
        if (self.day1StayDesc.length==0) {
            self.cellDay1StayDesc.frame=CGRectZero;
            NSString *string=self.day1Content;
            CGSize size=CGSizeMake(self.bounds.size.width-5*2, 1000);
            UIFont *font=[UIFont systemFontOfSize:11];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            self.cellDay1Content.frame=CGRectMake(5, 41+20, self.bounds.size.width-10, actualSize.height);
            self.cellDay1Content.text=self.day1Content;
            _lineSe.frame=CGRectMake(5, 61+actualSize.height+3, self.bounds.size.width-5, 1);
            _day2.frame=CGRectMake(5, 61+actualSize.height+8+1, 200, 20);
            [_day2 sizeToFit];
            self.cellDay2Content.frame=CGRectMake(5, 70+actualSize.height+3+20, self.bounds.size.width-10, 30);
            lineSe1.frame=CGRectMake(5, 70+actualSize.height+8+30+5+15, self.bounds.size.width, 1);
            _line.frame=CGRectMake(5, 35, self.bounds.size.width-5, 1);
            _more.frame=CGRectMake(0, 70+actualSize.height+8+30+5+15, self.bounds.size.width, 30);
            _grayArear.frame=CGRectMake(0, 70+actualSize.height+8+30+5+15+30, self.bounds.size.width, 10);
            self.cellDay2title.frame=CGRectMake(5+_day2.bounds.size.width+5, 61+actualSize.height+8+1, self.bounds.size.width-_day2.bounds.size.width-20, 20);


        }else
        {
            self.cellDay1Content.frame=CGRectMake(5, 41+30, self.bounds.size.width-10, 30);
            self.cellDay1Content.text=self.day1Content;
            self.cellDay1StayDesc.frame=CGRectMake(25, 102, self.bounds.size.width-100, 20);
            self.cellDay1StayDesc.text=[NSString stringWithFormat:@"住宿:%@",self.day1StayDesc];
            if (!_bed) {
                _bed=[[UIImageView alloc]initWithFrame:CGRectMake(5, 103, 15, 15)];
                _bed.image=[UIImage imageNamed:@"detailRoomIconBed.png"];
                [self addSubview:_bed];
            }
            _lineSe.frame=CGRectMake(5, 125, self.bounds.size.width-5, 1);
            _grayArear.frame=CGRectMake(0, 226, self.bounds.size.width, 10);
            _day2.frame=CGRectMake(5, 131, 200, 20);
            self.cellDay2Content.frame=CGRectMake(5, 160, self.bounds.size.width-10, 30);
            lineSe1.frame=CGRectMake(5, 195, self.bounds.size.width-5, 1);
            _line.frame=CGRectMake(5, 35, self.bounds.size.width-5, 1);
            _more.frame=CGRectMake(0, 196, self.bounds.size.width, 30);
            
            self.cellDay2title.frame=CGRectMake(5+_day2.bounds.size.width+5, 130, self.bounds.size.width-_day2.bounds.size.width-20, 30);

        }
        [self addSubview:_lineSe];

    }
}
-(void)getMore
{
    NSLog(@"more");
    if ([self.delegate respondsToSelector:@selector(getMore)]) {
        [self.delegate getMore];
    }
}
@end
