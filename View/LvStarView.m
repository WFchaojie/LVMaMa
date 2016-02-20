//
//  LvStarView.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/12.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LvStarView.h"

@implementation LvStarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
    }
    
    return self;
}
-(void)createStarViewWith:(CGFloat)avgScore andTotalScore:(CGFloat)totalScore
{
    int count=0;
    if (avgScore>(int)avgScore) {
        for (int i=0; i<(int)avgScore-1; i++) {
            UIImageView *score=[[UIImageView alloc]initWithFrame:CGRectMake(i*17, 0, 15, 15)];
            score.image=[UIImage imageNamed:@"starColorNew.png"];
            [self addSubview:score];
            count++;
        }
        UIImageView *score=[[UIImageView alloc]initWithFrame:CGRectMake(count*17, 0, 15, 15)];
        score.image=[UIImage imageNamed:@"starHalfNew.png"];
        [self addSubview:score];
        
    }else
    {
        for (int i=0; i<(int)avgScore; i++) {
            UIImageView *score=[[UIImageView alloc]initWithFrame:CGRectMake(i*17, 0, 15, 15)];
            score.image=[UIImage imageNamed:@"starColorNew.png"];
            [self addSubview:score];
            count++;
        }

    }
    
    for (int i=totalScore-avgScore; i<totalScore; i++) {
        UIImageView *score=[[UIImageView alloc]initWithFrame:CGRectMake(i*17, 0, 15, 15)];
        score.image=[UIImage imageNamed:@"starGrayNew.png"];
        [self addSubview:score];
    }
    
    if (avgScore==0.0) {
        for (int i=avgScore; i<totalScore; i++) {
            UIImageView *score=[[UIImageView alloc]initWithFrame:CGRectMake(i*17, 0, 15, 15)];
            score.image=[UIImage imageNamed:@"starGrayNew.png"];
            [self addSubview:score];
        }
    }
    
}
@end
