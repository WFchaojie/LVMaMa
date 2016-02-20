//
//  LVHomeCommentCell.m
//  LVMaMa
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeCommentCell.h"

@implementation LVHomeCommentCell
{
    int _height;
}
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
    if (!self.celluserPic) {
        self.celluserPic=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH, 5, 25, 25)];
        self.celluserPic.layer.cornerRadius=12.5;
        self.celluserPic.clipsToBounds=YES;
        [self addSubview:self.celluserPic];
    }
    if (!self.cellUserName) {
        self.cellUserName=[[UILabel alloc]initWithFrame:CGRectMake(38, 4, 100, 20)];
        self.cellUserName.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.cellUserName];
        self.cellUserName.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    }
    
    if (!self.cellCommnet) {
        self.cellCommnet=[[UILabel alloc]init];
        self.cellCommnet.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.cellCommnet];
        self.cellCommnet.textColor=[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
        self.cellCommnet.numberOfLines=0;
    }
    
    if (!self.cellTime) {
        self.cellTime=[[UILabel alloc]init];
        self.cellTime.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.cellTime];
        self.cellTime.textColor=[UIColor grayColor];
    }
    
    if (self.commnet&&self.picArray.count) {
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.commnet boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        self.cellCommnet.frame=CGRectMake(WIDTH, 85, self.bounds.size.width-WIDTH*2, actualSize.height);
    }else if(self.commnet&&self.picArray.count==0)
    {
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.commnet boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        self.cellCommnet.frame=CGRectMake(WIDTH, 35, self.bounds.size.width-WIDTH*2, actualSize.height);
    }
    
    if (self.time) {
        self.cellTime.frame=CGRectMake(WIDTH, self.bounds.size.height-20, self.bounds.size.width-10, 15);
        self.cellTime.text=self.time;
    }
    

    
    if (self.userPic) {
        [self.celluserPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",self.userPic]] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
    }
    if (self.userName) {
        self.cellUserName.text=self.userName;
    }
    if (self.commnet) {
        self.cellCommnet.text=self.commnet;
    }
    if (self.picArray.count!=0) {
        [self removePic];
        for (int i=0; i<self.picArray.count; i++) {
            UIImageView *back=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH+i*58, 31, 50, 50)];
            [back sd_setImageWithURL:[NSURL URLWithString:[self.picArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"lvDefault.png"]];
            [self addSubview:back];
            back.userInteractionEnabled=YES;
            UIButton *picButton=[UIButton buttonWithType:UIButtonTypeCustom];
            picButton.frame=back.bounds;
            [back addSubview:picButton];
            picButton.tag=i+100;
            [picButton addTarget:self action:@selector(picClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else
    {
        [self removePic];
    }
    
}
-(void)removePic
{
    for (UIImageView *pic in self.subviews) {
        if ([pic isKindOfClass:[UIImageView class]]) {
            if (pic.frame.origin.y==31) {
                pic.frame=CGRectZero;
                [pic removeFromSuperview];
            }
            for (UIButton *button in pic.subviews) {
                if ([button isKindOfClass:[UIButton class]]) {
                    button.frame=CGRectZero;
                    [button removeFromSuperview];
                }
            }
        }
    }
}
-(void)picClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(picClick:andTheCount:)]) {
        [self.delegate picClick:self.picArray andTheCount:(int)(button.tag-100)];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
