//
//  LVPindaoHeadCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVPindaoHeadCell.h"
#define PICWIDTH 6
@implementation LVPindaoHeadCell
#define BACKHEIGHT 15
#define FONTSIZE 10
#define ALPHA 0.5
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
    if (!self.cellButton1) {
        self.cellButton1=[UIButton buttonWithType:UIButtonTypeCustom];
        self.cellButton1.frame=CGRectMake(PICWIDTH, 5, self.bounds.size.width/2+10, self.bounds.size.height-10);
        [self addSubview:self.cellButton1];
        [self.cellButton1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.cellButton1.tag=100;

        self.cellBack1=[[UIView alloc]initWithFrame:CGRectMake(0, self.cellButton1.bounds.size.height-BACKHEIGHT, self.cellButton1.bounds.size.width, BACKHEIGHT)];
        self.cellBack1.alpha=ALPHA;
        self.cellBack1.backgroundColor=[UIColor blackColor];
        [self.cellButton1 addSubview:self.cellBack1];
        
        self.cellTitle1=[[UILabel alloc]initWithFrame:CGRectMake(PICWIDTH, self.cellBack1.frame.origin.y, self.cellBack1.bounds.size.width-PICWIDTH, BACKHEIGHT)];
        self.cellTitle1.textColor=[UIColor whiteColor];
        self.cellTitle1.font=[UIFont boldSystemFontOfSize:FONTSIZE];
        [self.cellButton1 addSubview:self.cellTitle1];
    }
    if (!self.cellButton2) {
        self.cellButton2=[UIButton buttonWithType:UIButtonTypeCustom];
        self.cellButton2.frame=CGRectMake(self.cellButton1.bounds.size.width+PICWIDTH+4, 5, self.bounds.size.width/2-10-11-5,self.bounds.size.height/2-10);
        [self addSubview:self.cellButton2];
        [self.cellButton2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.cellButton2.tag=101;

        self.cellBack2=[[UIView alloc]initWithFrame:CGRectMake(0, self.cellButton2.bounds.size.height-BACKHEIGHT, self.cellButton2.bounds.size.width, BACKHEIGHT)];
        self.cellBack2.alpha=ALPHA;
        self.cellBack2.backgroundColor=[UIColor blackColor];
        [self.cellButton2 addSubview:self.cellBack2];

        self.cellTitle2=[[UILabel alloc]initWithFrame:CGRectMake(PICWIDTH, self.cellBack2.frame.origin.y, self.cellBack2.bounds.size.width-PICWIDTH, BACKHEIGHT)];
        self.cellTitle2.textColor=[UIColor whiteColor];
        self.cellTitle2.font=[UIFont boldSystemFontOfSize:FONTSIZE];
        [self.cellButton2 addSubview:self.cellTitle2];
    }
    if (!self.cellButton3) {
        self.cellButton3=[UIButton buttonWithType:UIButtonTypeCustom];
        self.cellButton3.frame=CGRectMake(self.cellButton1.bounds.size.width+PICWIDTH+4, 10+self.cellButton2.bounds.size.height, self.bounds.size.width/2-10-11-5, self.bounds.size.height/2-5);
        [self addSubview:self.cellButton3];
        self.cellButton3.tag=102;
        [self.cellButton3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        self.cellBack3=[[UIView alloc]initWithFrame:CGRectMake(0, self.cellButton3.bounds.size.height-BACKHEIGHT, self.cellButton3.bounds.size.width, BACKHEIGHT)];
        self.cellBack3.alpha=ALPHA;
        self.cellBack3.backgroundColor=[UIColor blackColor];
        [self.cellButton3 addSubview:self.cellBack3];

        self.cellTitle3=[[UILabel alloc]initWithFrame:CGRectMake(PICWIDTH, self.cellBack3.frame.origin.y, self.cellBack3.bounds.size.width-PICWIDTH, BACKHEIGHT)];
        self.cellTitle3.textColor=[UIColor whiteColor];
        self.cellTitle3.font=[UIFont boldSystemFontOfSize:FONTSIZE];
        [self.cellButton3 addSubview:self.cellTitle3];
    }
    if (self.pic1) {
        [self.cellButton1 sd_setBackgroundImageWithURL:[NSURL URLWithString:self.pic1] forState:UIControlStateNormal];
        self.cellTitle1.text=self.title1;
    }
    if (self.pic2) {
        [self.cellButton2 sd_setBackgroundImageWithURL:[NSURL URLWithString:self.pic2] forState:UIControlStateNormal];
        self.cellTitle2.text=self.title2;
    }
    if (self.pic3) {
        [self.cellButton3 sd_setBackgroundImageWithURL:[NSURL URLWithString:self.pic3] forState:UIControlStateNormal];
        self.cellTitle3.text=self.title3;
    }
}

-(void)btnClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(picWithTag:)]) {
        [self.delegate picWithTag:(int)(button.tag-100)];
    }
}

@end
