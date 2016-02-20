//
//  LVTourCell.m
//  LVMaMa
//
//  Created by apple on 15-6-3.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVTourCell.h"
#import "UIImageView+WebCache.h"
@implementation LVTourCell
{
    __block UIImageView *_pic;
    UILabel *_title;
    UIImageView *_thumb;
    UILabel *_userName;
    UILabel *_time;
    __block UIProgressView *_progressView;
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
    if (!_pic) {
        _pic=[[UIImageView alloc]init];
        _pic.frame=CGRectMake(0, 0, self.bounds.size.width, 270);
        [self addSubview:_pic];
    }
    
    if (!_title) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, _pic.bounds.size.height-20, _pic.bounds.size.width, 20)];
        view.backgroundColor=[UIColor blackColor];
        view.alpha=0.6;
        [self addSubview:view];
        _title=[[UILabel alloc]initWithFrame:CGRectMake(10, _pic.bounds.size.height-20, _pic.bounds.size.width-10, 20)];
        _title.textColor=[UIColor whiteColor];
        [self addSubview:_title];
        _title.font=[UIFont boldSystemFontOfSize:14];
    }
    
    if (!_thumb) {
        _thumb=[[UIImageView alloc]initWithFrame:CGRectMake(5, _pic.bounds.size.height+5, 25, 25)];
        _thumb.layer.cornerRadius=_thumb.bounds.size.width/2;
        _thumb.clipsToBounds=YES;
        [self addSubview:_thumb];
    }
    
    if (!_userName) {
        _userName=[[UILabel alloc]initWithFrame:CGRectMake(_thumb.bounds.size.width+_thumb.frame.origin.x+5, _pic.bounds.size.height+5, 100, 15)];
        [self addSubview:_userName];
        _userName.font=[UIFont boldSystemFontOfSize:14];
    }
    
    if (!_time) {
        _time=[[UILabel alloc]initWithFrame:CGRectMake(_thumb.bounds.size.width+_thumb.frame.origin.x, _pic.bounds.size.height+15+_userName.bounds.size.height, 100, 15)];
        [self addSubview:_time];
        _time.font=[UIFont boldSystemFontOfSize:14];
    }
    
    if (!_progressView) {
        _progressView=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame=CGRectMake(0, _pic.frame.size.height, _pic.frame.size.width, 20);
        _progressView.progressTintColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
        [self addSubview:_progressView];
    }
    if (self.cellPic.length!=0) {
        [_pic sd_setImageWithURL:[NSURL URLWithString:self.cellPic]  placeholderImage:[UIImage imageNamed:@"defaultDetailImage.png"] options:SDWebImageCacheMemoryOnly  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (_progressView.hidden==YES) {
                _progressView.hidden=NO;
            }
            _progressView.progress=(float)receivedSize/(float)expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _progressView.hidden=YES;
            
        }];
        
        [_thumb sd_setImageWithURL:[NSURL URLWithString:self.cellThumb] placeholderImage:nil];
        _title.text=self.cellTitle;
        _time.text=self.cellTime;
        _userName.text=self.cellUserName;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
