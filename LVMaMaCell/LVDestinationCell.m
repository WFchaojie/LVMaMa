//
//  LVDestinationCell.m
//  LVMaMa
//
//  Created by apple on 15-6-4.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVDestinationCell.h"
#import "UIImageView+WebCache.h"
@implementation LVDestinationCell

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
    if (self.array.count) {
        int count=0;
        for (int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                NSDictionary *dict=[self.array objectAtIndex:count];
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*((self.bounds.size.width-30)/3+5), 10+j*((self.bounds.size.width-30)/3+5), (self.bounds.size.width-30)/3,(self.bounds.size.width-30)/3)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com//%@",[dict objectForKey:@"image"]]] placeholderImage:nil];
                image.userInteractionEnabled=YES;
                [self addSubview:image];
                
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, image.bounds.size.height-20, image.bounds.size.width, 20)];
                view.backgroundColor=[UIColor blackColor];
                view.alpha=0.6;
                [image addSubview:view];
                
                UILabel *place=[[UILabel alloc]initWithFrame:view.frame];
                [image addSubview:place];
                place.text=[dict objectForKey:@"title"];
                place.textColor=[UIColor whiteColor];
                place.textAlignment=NSTextAlignmentCenter;
                place.font=[UIFont boldSystemFontOfSize:12];
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.tag=100+count;
                button.frame=image.bounds;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [image addSubview:button];
                count++;
            }
        }
    }
}



-(void)buttonClick:(UIButton *)button
{
    [self.delegate destination:button.tag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
