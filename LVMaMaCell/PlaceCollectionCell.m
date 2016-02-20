//
//  PlaceCollectionCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/8/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "PlaceCollectionCell.h"

@implementation PlaceCollectionCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_cellPic) {
        _cellPic=[[UIImageView alloc]initWithFrame:self.bounds];
        _cellPic.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:_cellPic];
    }
    if (_pic) {
        [_cellPic sd_setImageWithURL:[NSURL URLWithString:_pic] placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
    }
    
    if (!_cellBack) {
        _cellBack=[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
        _cellBack.alpha=0.5;
        _cellBack.backgroundColor=[UIColor blackColor];
        [self addSubview:_cellBack];
    }
    
    
    if (!_cellTitle) {
        _cellTitle=[[UILabel alloc]initWithFrame:_cellBack.frame];
        _cellTitle.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_cellTitle];
        _cellTitle.textColor=[UIColor whiteColor];
        _cellTitle.font=[UIFont boldSystemFontOfSize:12];
    }
    if (_ctitle) {
        _cellTitle.text=_ctitle;
    }
    
}

@end
