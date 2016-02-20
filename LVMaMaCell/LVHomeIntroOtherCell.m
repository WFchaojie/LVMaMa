//
//  LVHomeIntroOtherCell.m
//  LVMaMa
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeIntroOtherCell.h"
@implementation LVHomeIntroOtherCell
{
    UIImageView *_arear;
    UIImageView *_arear2;
    UILabel *_arearLabel;
    UIImageView *_line1;
    int _height;
    UIView *_hotel;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.array=[[NSArray alloc]init];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_arear) {
        _arear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        _arear.frame=CGRectMake(0, 0, self.bounds.size.width, 30);
        [self addSubview:_arear];
        
        _arearLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, 0, self.bounds.size.width, _arear.bounds.size.height)];
        _arearLabel.text=@"交通与到达";
        [self addSubview:_arearLabel];
        _arearLabel.font=[UIFont systemFontOfSize:14];
        _height+=_arear.bounds.size.height;
    }
    if (self.array&&!_line1) {
        if (!_line1) {
            _line1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            _line1.frame=CGRectMake(0, 30, self.bounds.size.width, 1);
            [self addSubview:_line1];
            _height+=1;
        }
        for (NSDictionary *item in self.array) {
            if ([[item objectForKey:@"memo"] length]) {
                UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(8, _height+5, 200, 15)];
                title.text=[item objectForKey:@"name"];
                [self addSubview:title];
                title.font=[UIFont systemFontOfSize:12];
                _height+=title.bounds.size.height+5;
                
                UILabel *titleDetail=[[UILabel alloc]init];
                CGSize size=CGSizeMake(self.bounds.size.width-WIDTH*2, 1000);
                titleDetail.numberOfLines=0;
                UIFont *font=[UIFont systemFontOfSize:10];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[[item objectForKey:@"memo"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                titleDetail.frame=CGRectMake(WIDTH, _height, self.bounds.size.width-WIDTH*2, actualSize.height);
                titleDetail.font=[UIFont systemFontOfSize:10];
                titleDetail.text=[item objectForKey:@"memo"];
                [self addSubview:titleDetail];
                _height+=actualSize.height;
                
                UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
                line.frame=CGRectMake(0, _height+5, self.bounds.size.width, 1);
                [self addSubview:line];
                _height+=5;
            }
        }
        if (!_arear2) {
            _arear2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
            _arear2.frame=CGRectMake(0, _height, self.bounds.size.width, 10);
            [self addSubview:_arear2];
            _height+=10;
        }
        if (!_hotel) {
            _hotel=[[UIView alloc]initWithFrame:CGRectMake(0, _height, self.bounds.size.width, 30)];
            [self addSubview:_hotel];
            NSArray *picArray=[NSArray arrayWithObjects:@"arroundHotel.png",@"arroundPlace.png", nil];
            NSArray *hotelArray=[NSArray arrayWithObjects:@"周边酒店",@"周边景点",nil];
            for (int i=0; i<2; i++) {
                UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(8, _height+5, 20, 20)];
                pic.image=[UIImage imageNamed:[picArray objectAtIndex:i]];
                [self addSubview:pic];
                
                UILabel *hotel=[[UILabel alloc]initWithFrame:CGRectMake(pic.frame.origin.x+pic.bounds.size.width+5, 5+_height, 100, 20)];
                hotel.text=[hotelArray objectAtIndex:i];
                [self addSubview:hotel];
                hotel.font=[UIFont systemFontOfSize:12];
                
                //用来接收点击
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, _height+5, self.bounds.size.width, 30)];
                btn.tag=100+i;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                
                UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
                line.frame=CGRectMake(0,_height+30, self.bounds.size.width, 1);
                [self addSubview:line];
                
                UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-20, _height+5, 10, 15)];
                arrow.image=[UIImage imageNamed:@"cellArrow.png"];
                [self addSubview:arrow];
                _height+=30*(i+1);
            }
        }
    }
}

-(void)btnClick:(UIButton *)button
{
    [self.delegate hotelClick:button.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
