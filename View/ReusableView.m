//
//  ReusableView.m
//  PlainLayout
//
//  Created by hebe on 15/7/30.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//

#import "ReusableView.h"

@implementation ReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:self.bounds];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font=[UIFont boldSystemFontOfSize:12];
        [self addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:self.bounds];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:rightLabel];
        rightLabel.font=[UIFont boldSystemFontOfSize:12];
        rightLabel.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    ((UILabel *)self.subviews[0]).text = text;
}
-(void)setMoreText:(NSString *)moreText
{
    _moreText=moreText;
    ((UILabel *)self.subviews[1]).text = moreText;
}

@end
