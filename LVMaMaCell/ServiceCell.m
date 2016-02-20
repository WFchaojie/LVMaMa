//
//  ServiceCell.m
//  LVMaMa
//
//  Created by 武超杰 on 15/10/12.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell
{
    UIImageView *_pic;
    UIImageView *_line;
    UILabel *_titleLabel;
    UILabel *_roomAmenitiesLabel;
    UILabel *_generalAmenitiesLabel;
    UILabel *_roomAmenitiesLabelHint;
    UILabel *_generalAmenitiesLabelHint;
    UIImageView *_arearImageView;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_arearImageView) {
        _arearImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        _arearImageView.frame=CGRectMake(0, 0, self.bounds.size.width, 10);
        [self.contentView addSubview:_arearImageView];
    }
    
    if (!_pic) {
        _pic=[[UIImageView alloc]init];
        _pic.frame=CGRectMake(8,_arearImageView.frame.origin.y+_arearImageView.bounds.size.height + 8, 16, 16);
        _pic.image=[UIImage imageNamed:@"detailHotelIconSet.png"];
        [self.contentView addSubview:_pic];
    }
    
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.frame=CGRectMake(_pic.frame.origin.x+_pic.frame.size.width+5, _pic.frame.origin.y-5, 100, 25);
        _titleLabel.text=@"设施服务";
        _titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_line) {
        _line=[[UIImageView alloc]init];
        _line.frame=CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, self.bounds.size.width, 1);
        _line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [self.contentView addSubview:_line];
    }
    
    if (!_generalAmenitiesLabelHint) {
        _generalAmenitiesLabelHint=[[UILabel alloc]init];
        _generalAmenitiesLabelHint.frame=CGRectMake(15, _line.frame.origin.y+5, self.bounds.size.width-10, 20);
        _generalAmenitiesLabelHint.numberOfLines=0;
        _generalAmenitiesLabelHint.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_generalAmenitiesLabelHint];
        _generalAmenitiesLabelHint.textColor=[UIColor grayColor];
        _generalAmenitiesLabelHint.text=@"服务设施：";
        [_generalAmenitiesLabelHint sizeToFit];
    }
    
    if (!_generalAmenitiesLabel) {
        _generalAmenitiesLabel=[[UILabel alloc]init];
        _generalAmenitiesLabel.frame=CGRectMake(_generalAmenitiesLabelHint.frame.origin.x+_generalAmenitiesLabelHint.frame.size.width+5, _line.frame.origin.y+5, self.bounds.size.width-_generalAmenitiesLabelHint.frame.origin.x-_generalAmenitiesLabelHint.frame.size.width-20, 30);
        _generalAmenitiesLabel.numberOfLines=0;
        _generalAmenitiesLabel.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_generalAmenitiesLabel];
        _generalAmenitiesLabel.textColor=[UIColor grayColor];
        
    }
    
    if (!_roomAmenitiesLabelHint) {
        _roomAmenitiesLabelHint=[[UILabel alloc]init];
        _roomAmenitiesLabelHint.frame=CGRectMake(15, _line.frame.origin.y+5, self.bounds.size.width-10, 20);
        _roomAmenitiesLabelHint.numberOfLines=0;
        _roomAmenitiesLabelHint.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_roomAmenitiesLabelHint];
        _roomAmenitiesLabelHint.textColor=[UIColor grayColor];
        _roomAmenitiesLabelHint.text=@"房间设施：";
        [_roomAmenitiesLabelHint sizeToFit];
    }
    
    if (!_roomAmenitiesLabel) {
        _roomAmenitiesLabel=[[UILabel alloc]init];
        _roomAmenitiesLabel.frame=CGRectMake(_roomAmenitiesLabelHint.frame.origin.x+_roomAmenitiesLabelHint.frame.size.width+5, _line.frame.origin.y+5, self.bounds.size.width-_roomAmenitiesLabelHint.frame.origin.x-_roomAmenitiesLabelHint.frame.size.width-20, 30);
        _roomAmenitiesLabel.numberOfLines=0;
        _roomAmenitiesLabel.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_roomAmenitiesLabel];
        _roomAmenitiesLabel.textColor=[UIColor grayColor];
        
    }
    
    if (self.generalAmenities) {
        if (self.generalAmenities.length) {
            [self resizeContent:self.generalAmenities andTheLabel:_generalAmenitiesLabel andHintLabel:_roomAmenitiesLabelHint andLastLabel:nil];
        }
    }
    
    if (self.roomAmenities) {
        if (self.roomAmenities.length) {
            [self resizeContent:self.roomAmenities andTheLabel:_roomAmenitiesLabel andHintLabel:_roomAmenitiesLabelHint andLastLabel:_generalAmenitiesLabel];
        }
    }
    
}
-(void)resizeContent:(NSString *)string andTheLabel:(UILabel *)label andHintLabel:(UILabel *)hintLabel andLastLabel:(UILabel *)lastLabel;
{
    CGSize size=CGSizeMake(self.bounds.size.width-_generalAmenitiesLabelHint.frame.origin.x-_generalAmenitiesLabelHint.frame.size.width-20, 1000);
    UIFont *font;
    if (iPhone6Plus) {
        font=[UIFont systemFontOfSize:12];
    }else
    {
        font=[UIFont systemFontOfSize:10];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing=0;
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
    CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    CGRect rect=label.frame;
    rect.size.height=actualSize.height;
    
    if (lastLabel!=nil) {
        rect.origin.y=lastLabel.frame.origin.y+lastLabel.bounds.size.height+10;
    }
    
    label.frame=rect;
    label.text=string;
    
    if (lastLabel!=nil) {
        rect=hintLabel.frame;
        rect.origin.y=lastLabel.frame.origin.y+lastLabel.bounds.size.height+10;
        hintLabel.frame=rect;
    }
}


@end
