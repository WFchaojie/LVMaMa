//
//  LVTourCommentCell.m
//  LVMaMa
//
//  Created by apple on 15-6-14.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVTourCommentCell.h"

@implementation LVTourCommentCell

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
    if (!self.cellPic) {
        self.cellPic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
        self.cellPic.layer.cornerRadius=15;
        self.cellPic.clipsToBounds=YES;
        [self addSubview:self.cellPic];
    }
    if (!self.cellTitle) {
        self.cellTitle=[[UILabel alloc]init];
        self.cellTitle.numberOfLines=0;
        [self addSubview:self.cellTitle];
        self.cellTitle.font=[UIFont systemFontOfSize:12];
    }
    
    if (self.pic) {
        [self.cellPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",self.pic]] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
    }
    if (self.userName&&self.userContent) {
        NSString *string=[NSString stringWithFormat:@"%@：%@",self.userName,self.userContent];
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
        NSDictionary *color=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
        [attribute addAttributes:color range:NSMakeRange(0, self.userName.length)];
        self.cellTitle.attributedText=attribute;
        self.cellTitle.frame=CGRectMake(40, 10, self.bounds.size.width-50, actualSize.height);
    }
    
    if (!self.cellTime) {
        self.cellTime=[[UILabel alloc]initWithFrame:CGRectMake(40, self.bounds.size.height-20, self.bounds.size.width-8200, 15)];
        [self addSubview:self.cellTime];
        self.cellTime.font=[UIFont systemFontOfSize:12];
        self.cellTime.textColor=[UIColor grayColor];
    }
    if (self.time) {
        self.cellTime.text=[self getTimeToShowWithTimestamp:self.time];
        self.cellTime.frame=CGRectMake(40, self.bounds.size.height-20,200, 15);
    }
}
-(NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp
{
    NSTimeInterval publishString = [timestamp doubleValue]+28800;
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString * returnString = [formatter stringFromDate:publishDate];
    
    return returnString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
