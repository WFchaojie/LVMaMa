//
//  LVProductCell.m
//  LVMaMa
//
//  Created by apple on 15-6-14.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVProductCell.h"

@implementation LVProductCell

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
        self.cellPic=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            self.cellPic.frame=CGRectMake(5, 5, 100, 80);
        }else
        {
            self.cellPic.frame=CGRectMake(5, 5, 70, 60);
        }
        [self addSubview:self.cellPic];
    }
    if (!self.cellTitle) {
        self.cellTitle=[[UILabel alloc]initWithFrame:CGRectMake(self.cellPic.bounds.size.width+10, 0, self.bounds.size.width-self.cellPic.bounds.size.width-10, 50)];
        
        self.cellTitle.numberOfLines=0;
        [self addSubview:self.cellTitle];
        if (iPhone6Plus) {
            self.cellTitle.font=[UIFont systemFontOfSize:14];
        }else
        {
            self.cellTitle.font=[UIFont systemFontOfSize:12];
        }
    }
    if (self.pic) {
        [self.cellPic sd_setImageWithURL:[NSURL URLWithString:self.pic] placeholderImage:[UIImage imageNamed:@"defaultDestImageS.png"]];
    }
    if (self.title) {
        self.cellTitle.text=self.title;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
