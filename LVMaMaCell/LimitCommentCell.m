//
//  LimitCommentCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/11.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LimitCommentCell.h"
#import "LvStarView.h"
#define TOTALSCORE 5.0

@implementation LimitCommentCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.cellUserName) {
        self.cellUserName=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, 4, 200, 20)];
        self.cellUserName.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.cellUserName];
        self.cellUserName.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    }
    if (!self.starView) {
        self.starView=[[LvStarView alloc]initWithFrame:CGRectMake(WIDTH, 20, 100, 17)];
        [self addSubview:self.starView];
    }
    if (!self.separateLine) {
        self.separateLine=[[UIImageView alloc]init];
        self.separateLine.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [self addSubview:self.separateLine];
    }
    
    if (!self.cellComment) {
        self.cellComment=[[UILabel alloc]init];
        self.cellComment.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.cellComment];
        self.cellComment.textColor=[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
        self.cellComment.numberOfLines=0;
    }
    if (!self.cellTime) {
        self.cellTime=[[UILabel alloc]init];
        self.cellTime.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.cellTime];
        self.cellTime.textColor=[UIColor grayColor];
    }
    
    if (self.comment&&self.picArray.count) {
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        self.cellComment.frame=CGRectMake(WIDTH, 89, self.bounds.size.width-WIDTH*2, actualSize.height);
    }else if(self.comment&&self.picArray.count==0)
    {
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.comment boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        self.cellComment.frame=CGRectMake(WIDTH, 39, self.bounds.size.width-WIDTH*2, actualSize.height);
    }
    if (self.time) {
        self.cellTime.frame=CGRectMake(WIDTH, self.bounds.size.height-20, self.bounds.size.width-10, 15);
        self.cellTime.text=self.time;
    }
    
    
    if (self.userName) {
        self.cellUserName.text=self.userName;
    }
    if (self.comment) {
        self.cellComment.text=self.comment;
    }
    if (self.picArray.count!=0) {
        for (int i=0; i<self.picArray.count; i++) {
            if (i>4) {
                return;
            }
            UIImageView *back=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH+i*58, 30+9, 50, 50)];
            [back sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[[self.picArray objectAtIndex:i] objectForKey:@"picUrl"]]] placeholderImage:[UIImage imageNamed:@"lvDefault.png"]];
            [self addSubview:back];
            back.contentMode=UIViewContentModeScaleToFill;
            
            back.userInteractionEnabled=YES;
            UIButton *picButton=[UIButton buttonWithType:UIButtonTypeCustom];
            picButton.frame=back.bounds;
            [back addSubview:picButton];
            picButton.tag=i+100;
            [picButton addTarget:self action:@selector(picClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else
    {
        for (UIImageView *pic in self.subviews) {
            if ([pic isKindOfClass:[UIImageView class]]) {
                if (pic.frame.origin.y==39) {
                    pic.frame=CGRectZero;
                }
            }
        }
    }
    
    if (self.avgScore) {
        [self.starView createStarViewWith:self.avgScore.floatValue andTotalScore:TOTALSCORE];
    }
    self.separateLine.frame=CGRectMake(0,self.bounds.size.height, self.bounds.size.width, 1);

    
}

-(void)picClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(picClick:andTheCount:)]) {
        [self.delegate picClick:self.picArray andTheCount:(int)(button.tag-100)];
    }else if([self.picDelegate respondsToSelector:@selector(picClick:andTheCount:andType:)])
    {
        [self.picDelegate picClick:self.picArray andTheCount:(int)(button.tag-100) andType:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
