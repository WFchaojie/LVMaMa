//
//  LVHomeIntroCell.m
//  LVMaMa
//
//  Created by apple on 15-6-10.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeIntroCell.h"
#define WIDTH 8
#define HEIGHT 120
#define PLUS_HEIGHT 250

@implementation LVHomeIntroCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.introduction=[[NSArray alloc]init];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_cellLight) {
        _cellLight=[[UILabel alloc]init];
        _cellLight.text=@"亮点";
        _cellLight.font=[UIFont systemFontOfSize:14];
        [self addSubview:_cellLight];
        _height=0;
    }

    if (!_cellLightDetail) {
        _cellLightDetail=[[UILabel alloc]init];
         _cellLightDetail.font=[UIFont systemFontOfSize:12];
        _cellLightDetail.numberOfLines=0;
        [self addSubview:_cellLightDetail];
    }
    
    if (!_cellIntroduce) {
        _cellIntroduce=[[UILabel alloc]init];
        _cellIntroduce.text=@"简介";
        _cellIntroduce.font=[UIFont systemFontOfSize:14];
        [self addSubview:_cellIntroduce];
    }
    if (!_cellIntroduceDetail) {
        _cellIntroduceDetail=[[UILabel alloc]init];
        _cellIntroduceDetail.font=[UIFont systemFontOfSize:12];
        _cellIntroduceDetail.numberOfLines=0;
        [self addSubview:_cellIntroduceDetail];
    }
    if (!_cellGame) {
        _cellGame=[[UILabel alloc]init];
        _cellGame.text=@"游玩项目";
        _cellGame.font=[UIFont systemFontOfSize:14];
        [self addSubview:_cellGame];
    }
    
    if (self.introduceDetail.length!=0&&_cellLight.frame.size.height!=15) {
        
        _cellLight.frame=CGRectMake(WIDTH, 0, 100, 15);
        if (self.lightDetail.length!=0)
        {
            _height+=_cellLight.bounds.size.height+_cellLight.frame.origin.y;
        }
        CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[self.lightDetail boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        _cellLightDetail.frame=CGRectMake(WIDTH, _height, self.bounds.size.width-WIDTH*2, actualSize.height);
        _height+=actualSize.height;
        _cellIntroduce.frame=CGRectMake(WIDTH, _height, 100, 15);
        _height+=_cellIntroduce.bounds.size.height;
        
        CGSize size1=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
        UIFont *font1=[UIFont systemFontOfSize:12];
        NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil];
        CGSize actualSize1=[self.introduceDetail boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
        _cellIntroduceDetail.frame=CGRectMake(WIDTH, _height, self.bounds.size.width-WIDTH*2, actualSize1.height);
        if (self.lightDetail.length==0) {
            _cellIntroduceDetail.frame=CGRectMake(WIDTH, 30, self.bounds.size.width-WIDTH*2, actualSize1.height);
        }
        _height+=actualSize1.height;
        
        _cellGame.frame=CGRectMake(WIDTH, _height, 100, 15);
        if (self.introduction.count!=0) {
            _height+=_cellGame.bounds.size.height;
        }
        
        for (NSDictionary *item in self.introduction) {
            
            if ([item objectForKey:@"spotName"]) {
                UILabel *gameDetail=[[UILabel alloc]init];
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
                gameDetail.numberOfLines=0;
                UIFont *font=[UIFont systemFontOfSize:10];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[[item objectForKey:@"spotName"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                gameDetail.frame=CGRectMake(WIDTH, _height+3, self.bounds.size.width-WIDTH*2, actualSize.height);
                gameDetail.text=[item objectForKey:@"spotName"];
                gameDetail.font=[UIFont systemFontOfSize:10];
                [self addSubview:gameDetail];
                _height+=actualSize.height+3;
            }
            
            if ([item objectForKey:@"spotDesc"]) {
                UILabel *gameDetail=[[UILabel alloc]init];
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
                gameDetail.numberOfLines=0;
                UIFont *font=[UIFont systemFontOfSize:10];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[[item objectForKey:@"spotDesc"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                gameDetail.frame=CGRectMake(WIDTH, _height+3, self.bounds.size.width-WIDTH*2, actualSize.height);
                gameDetail.text=[item objectForKey:@"spotDesc"];
                gameDetail.font=[UIFont systemFontOfSize:10];
                [self addSubview:gameDetail];
                _height+=actualSize.height+3;
            }
            
            if ([[item objectForKey:@"imageList"] count]) {
                for (NSDictionary *picDict in [item objectForKey:@"imageList"]) {
                    UIImageView *picImage=[[UIImageView alloc]init];
                    if ([picDict objectForKey:@"photoUrl"]) {
                        [picImage sd_setImageWithURL:[NSURL URLWithString:[picDict objectForKey:@"photoUrl"]] placeholderImage:nil];
                    }else
                        [picImage sd_setImageWithURL:[NSURL URLWithString:[picDict objectForKey:@"compressPicUrl"]] placeholderImage:nil];
                    [self addSubview:picImage];
                    if (iPhone6Plus) {
                        picImage.frame=CGRectMake(WIDTH, _height+3, self.bounds.size.width-WIDTH*2, PLUS_HEIGHT);
                        _height+=PLUS_HEIGHT+3;
                    }else
                    {
                        picImage.frame=CGRectMake(WIDTH, _height+3, self.bounds.size.width-WIDTH*2, HEIGHT);
                        _height+=HEIGHT+3;
                    }
                }
            }
        }
        _height+=20;
        [self.delegate returnHeight:_height];
    }
    _cellLightDetail.text=self.lightDetail;
    _cellIntroduceDetail.text=self.introduceDetail;
    
    if (self.lightDetail.length==0) {
        _cellLight.frame=CGRectZero;
        _cellIntroduce.frame=CGRectMake(8, 5, 100, 20);
    }
    if (self.introduction.count==0) {
        _cellGame.frame=CGRectZero;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
