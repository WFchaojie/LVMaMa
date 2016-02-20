//
//  LVTourRecordCommentCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVTourRecordCommentCell.h"

@implementation LVTourRecordCommentCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.cellUserPic) {
        self.cellUserPic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        [self addSubview:self.cellUserPic];
        self.cellUserPic.layer.cornerRadius=10;
        self.cellUserPic.clipsToBounds=YES;
    }
    if (!self.cellComment) {
        self.cellComment=[[UILabel alloc]initWithFrame:CGRectMake(20, 5,self.bounds.size.width-30, 20)];
        self.cellComment.font=[UIFont boldSystemFontOfSize:11];
        self.cellComment.textColor=[UIColor grayColor];
        self.cellComment.textAlignment=NSTextAlignmentLeft;
        self.cellComment.numberOfLines=0;
        [self addSubview:self.cellComment];
    }
    if (!self.cellTime) {
        self.cellTime=[[UILabel alloc]initWithFrame:CGRectMake(30, self.bounds.size.height-20, self.bounds.size.width-30, 20)];
        self.cellTime.font=[UIFont boldSystemFontOfSize:10];
        self.cellTime.textColor=[UIColor lightGrayColor];
        self.cellTime.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.cellTime];
    }
    if (self.userPic) {
        [self.cellUserPic sd_setImageWithURL:[NSURL URLWithString:self.userPic] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
    }
    if (self.comment&&self.userName&&self.time) {
        NSString *string=[NSString stringWithFormat:@"%@：%@",self.userName,self.comment];
        CGSize size=CGSizeMake(self.bounds.size.width-30, 1000);
        UIFont *font=[UIFont systemFontOfSize:11];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
        NSDictionary *color=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
        [attribute addAttributes:color range:NSMakeRange(0, self.userName.length)];
        self.cellComment.attributedText=attribute;
        self.cellComment.frame=CGRectMake(30, 5,self.bounds.size.width-30, actualSize.height);
        
        self.cellTime.text=[self getTimeToShowWithTimestamp:self.time];
        self.cellTime.frame=CGRectMake(30, actualSize.height+5, self.bounds.size.width-30, 20);
    }
  
    
}
-(NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp
{
    /*
    NSTimeInterval publishString = [timestamp doubleValue]+28800;
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString * returnString = [formatter stringFromDate:publishDate];
    
    return returnString;
    */
    NSTimeInterval publishString = [timestamp doubleValue];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:publishString];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    
    NSDate *now = [NSDate date];
    NSTimeInterval aInterval =[now timeIntervalSince1970];

    NSString *dateNow = [dateFormatter stringFromDate:now];
    NSDate *yestoday = [NSDate dateWithTimeIntervalSince1970:(aInterval-secondsPerDay)];
    NSString *dateYestoday = [dateFormatter stringFromDate:yestoday];
    NSLog(@"%@",dateYestoday);
    NSLog(@"%@",dateSMS);
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"今天 HH:mm"];
    }else if ([dateSMS isEqualToString:dateYestoday])
    {
        [dateFormatter setDateFormat:@"昨天 HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"MM月dd日"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    return dateSMS;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
