//
//  LVTourRecordDetialCell.m
//  LVMaMa
//
//  Created by apple on 15-6-13.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVTourRecordDetialCell.h"

#define ORIGINY 10

@implementation LVTourRecordDetialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.cellPoiDesc) {
        self.cellPoiDesc=[[UILabel alloc]init];
        self.cellPoiDesc.numberOfLines=0;
        self.cellPoiDesc.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.cellPoiDesc];
        self.cellPoiDesc.textColor = [UIColor blackColor];
    }
    if (!self.cellMemoLabel) {
        self.cellMemoLabel=[[UILabel alloc]init];
        self.cellMemoLabel.numberOfLines=0;
        self.cellMemoLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.cellMemoLabel];
        self.cellMemoLabel.textColor = [UIColor blackColor];
    }
    if (!self.cellDiscrip) {
        self.cellDiscrip=[[UILabel alloc]init];
        self.cellDiscrip.numberOfLines=0;
        self.cellDiscrip.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.cellDiscrip];
        self.cellDiscrip.textColor = [UIColor grayColor];
    }
    
    if (!self.cellAddressPic) {
        self.cellAddressPic=[[UIImageView alloc]init];
        self.cellAddressPic.image=[UIImage imageNamed:@"mtviewspot.png"];
        [self addSubview:self.cellAddressPic];
        self.cellAddressPic.alpha=0;
    }
    
    if (!self.cellAddressLabel) {
        self.cellAddressLabel=[[UILabel alloc]init];
        self.cellAddressLabel.font=[UIFont systemFontOfSize:10];
        self.cellAddressLabel.textColor=[UIColor colorWithRed:0.09f green:0.27f blue:0.97f alpha:1.00f];
        [self addSubview:self.cellAddressLabel];
    }
    
    if (!_likePic) {
        self.likePic=[[UIImageView alloc]init];
        self.likePic.image=[UIImage imageNamed:@"careCount.png"];
        [self addSubview:self.likePic];
        self.likePic.alpha=0;
    }
    if (!self.likeLabel) {
        self.likeLabel=[[UILabel alloc]init];
        self.likeLabel.font=[UIFont systemFontOfSize:12];
        self.likeLabel.textColor=[UIColor grayColor];
        [self addSubview:self.likeLabel];
    }
    if (!self.commentPic) {
        self.commentPic=[[UIImageView alloc]init];
        self.commentPic.image=[UIImage imageNamed:@"mtReview.png"];
        [self addSubview:self.commentPic];
        self.commentPic.alpha=0;
    }
    if (!self.commentLabel) {
        self.commentLabel=[[UILabel alloc]init];
        self.commentLabel.font=[UIFont systemFontOfSize:12];
        self.commentLabel.textColor=[UIColor grayColor];
        [self addSubview:self.commentLabel];
        
    }
    if (!self.cellPic) {
        self.cellPic=[[UIImageView alloc]init];
        [self addSubview:self.cellPic];
    }
    
    if (self.poiDesc.length!=0) {
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH-1, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.poiDesc boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;        self.cellPoiDesc.frame=CGRectMake(3, ORIGINY, self.bounds.size.width-WIDTH-3, actualSize.height);
        self.cellPoiDesc.text=self.poiDesc;
    }else
    {
        if (self.pic.length) {
            self.cellPic.frame=CGRectMake(0, ORIGINY, self.bounds.size.width, 230);
            [self.cellPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",self.pic]] placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
            if (self.poiName.length!=0) {
                self.cellAddressLabel.text=self.poiName;
                self.cellAddressLabel.frame=CGRectMake(25, self.bounds.size.height-20, 200, 15);
                self.cellAddressPic.frame=CGRectMake(5, self.bounds.size.height-20, 15, 15);
                self.cellAddressLabel.alpha=1;
                self.cellAddressPic.alpha=1;
            }else
            {
                self.cellAddressLabel.alpha=1;
                self.cellAddressPic.alpha=1;
            }
            if (self.memo) {
                self.cellMemoLabel.alpha=1;
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH-1, 1000);
                UIFont *font=[UIFont systemFontOfSize:12];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[self.memo boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                self.cellMemoLabel.frame=CGRectMake(3, ORIGINY*2+self.cellPic.bounds.size.height, self.bounds.size.width-WIDTH-3, actualSize.height);
                self.cellMemoLabel.text = self.memo;
                
            }else
            {
                self.cellMemoLabel.alpha=0;
            }
            
        }else
        {
            if (self.poiName.length!=0) {
                self.cellAddressLabel.text=self.poiName;
                self.cellAddressLabel.frame=CGRectMake(25, self.bounds.size.height-20, 200, 15);
                self.cellAddressPic.frame=CGRectMake(5, self.bounds.size.height-20, 15, 15);
                self.cellAddressLabel.alpha=1;
                self.cellAddressPic.alpha=1;
            }else
            {
                self.cellAddressLabel.alpha=1;
                self.cellAddressPic.alpha=1;
            }
            if (self.discrip) {
                self.cellDiscrip.alpha=1;
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH-1, 1000);
                UIFont *font=[UIFont systemFontOfSize:12];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[self.discrip boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                self.cellDiscrip.frame=CGRectMake(3, ORIGINY, self.bounds.size.width-WIDTH-3, actualSize.height);
                self.cellDiscrip.text = self.discrip;
            }else
            {
                self.cellDiscrip.alpha=0;
            }
        }
        
        if (self.like) {
            self.likeLabel.text=[NSString stringWithFormat:@"%d",((NSNumber *)self.like).intValue];
            self.likeLabel.frame=CGRectMake(self.bounds.size.width-42, self.bounds.size.height-21-5,20, 15);
            self.likePic.alpha=1.0;
            self.likePic.frame=CGRectMake(self.bounds.size.width-60, self.bounds.size.height-21-5, 17, 15);
        }
        
        if (self.comment) {
            self.commentLabel.text=[NSString stringWithFormat:@"%d",((NSNumber *)self.comment).intValue];
            self.commentLabel.frame=CGRectMake(self.bounds.size.width-23+12, self.bounds.size.height-21-5, 20, 15);
            self.commentPic.alpha=1.0;
            self.commentPic.frame=CGRectMake(self.bounds.size.width-43+15, self.bounds.size.height-20-5, 15, 15);
        }
        if (self.poiName.length!=0&&self.poiName!=nil&&self.poiName!=NULL&&(![self.poiName isKindOfClass:[NSNull class]])&&[[self.poiName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]!=0) {
            NSLog(@"%@",self.poiName);
            self.cellAddressLabel.text=self.poiName;
            self.cellAddressLabel.frame=CGRectMake(20, self.bounds.size.height-20-5, 200, 15);
            self.cellAddressPic.frame=CGRectMake(5, self.bounds.size.height-20-5, 15, 15);
            self.cellAddressLabel.alpha=1;
            self.cellAddressPic.alpha=1;
        }else
        {
            self.cellAddressLabel.alpha=0;
            self.cellAddressPic.alpha=0;
        }
    }
    /*
    if (self.dict) {
        if ([[self.dict objectForKey:@"segments"] count]) {
            NSDictionary *segments=[[self.dict objectForKey:@"segments"] objectAtIndex:0];
            NSDictionary *image=[segments objectForKey:@"image"];
            
            if (![image objectForKey:@"imgUrl"]) {
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH-1, 1000);
                UIFont *font=[UIFont systemFontOfSize:12];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[[[[self.dict objectForKey:@"segments"] objectAtIndex:0] objectForKey:@"text"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                self.describe.frame=CGRectMake(1, 5, self.bounds.size.width-WIDTH-1, actualSize.height);
                self.describe.text=[[[self.dict objectForKey:@"segments"] objectAtIndex:0] objectForKey:@"text"];
                
            }else{
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH-1, 1000);
                UIFont *font=[UIFont systemFontOfSize:12];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[[self.dict objectForKey:@"poiDesc"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                self.describe.text=[self.dict objectForKey:@"poiDesc"];
                self.describe.frame=CGRectMake(1, 5, self.bounds.size.width-WIDTH-1, actualSize.height);
                
                UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
                line.frame=CGRectMake(0, 5+10+self.describe.bounds.size.height, self.bounds.size.width, 1);
                [self addSubview:line];
                
                self.pic.frame=CGRectMake(0, line.frame.origin.y+10, self.bounds.size.width, 250);
                [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[image objectForKey:@"imgUrl"]]] placeholderImage:nil];
                
            }
            if ([segments objectForKey:@"likeCount"]) {
                self.likeLabel.text=[NSString stringWithFormat:@"%d",((NSNumber *)[segments objectForKey:@"likeCount"]).intValue];
                self.likeLabel.frame=CGRectMake(self.bounds.size.width-73, self.bounds.size.height-20,20, 15);
                self.likePic.alpha=1.0;
                self.likePic.frame=CGRectMake(self.bounds.size.width-90, self.bounds.size.height-20, 15, 15);
            }
            if ([segments objectForKey:@"commentCount"]) {
                self.commentLabel.text=[NSString stringWithFormat:@"%d",((NSNumber *)[segments objectForKey:@"commentCount"]).intValue];
                self.commentLabel.frame=CGRectMake(self.bounds.size.width-25, self.bounds.size.height-20, 20, 15);
                self.commentPic.alpha=1.0;
                self.commentPic.frame=CGRectMake(self.bounds.size.width-43, self.bounds.size.height-20, 15, 15);
            }



        }
        
        if (![[self.dict objectForKey:@"poiName"]isEqualToString:@""]) {
            self.addressLabel.text=[self.dict objectForKey:@"poiName"];
            self.addressLabel.frame=CGRectMake(25, self.bounds.size.height-20, 200, 15);
            self.addressPic.frame=CGRectMake(5, self.bounds.size.height-20, 15, 15);
            self.addressLabel.alpha=1;
            self.addressPic.alpha=1;
        }
    }
     */
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
