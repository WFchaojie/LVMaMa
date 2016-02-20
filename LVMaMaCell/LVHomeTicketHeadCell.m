//
//  LVHomeTicketHeadCell.m
//  LVMaMa
//
//  Created by apple on 15-6-9.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeTicketHeadCell.h"

@implementation LVHomeTicketHeadCell

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
    if (!self.title) {
        self.title=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.title];
        self.title.font=[UIFont boldSystemFontOfSize:12];
        self.title.textColor=[UIColor grayColor];
        
        self.pic=[[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-20, 5, 10, 10)];
        [self addSubview:self.pic];
    }
    if (self.title&&self.ticketTitle.length) {
        self.title.text=self.ticketTitle;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
