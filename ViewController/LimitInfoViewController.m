//
//  LimitInfoViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LimitInfoViewController.h"
#import "LogInViewController.h"
#import "LimitCommentCell.h"
#import "HomeTopDetailViewController.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#define TITLE @"秒杀详情"

@interface LimitInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,PicComment>

@end

@implementation LimitInfoViewController
{
    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_commentArray;
    UIPageControl *_pageControl;
    UIScrollView *_scrol;
    UIView *_headerView;
    NSTimer *_restTimeTimer;
    UILabel *_restLabel;
    UIView *_headView;
    int _webViewHeight;
    int _webViewHeight2;
    int _webViewHeight3;
    //计算head视图下控件的位置
    int _restHeight;
    BOOL _long;
    UIView *_blackView;
    UIScrollView *_picScrollView;
    UIImageView *_capture;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
    if (!_LVTableView) {
        [self hudShow];
        [self createTableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=TITLE;
    _webViewHeight=10;
    _webViewHeight2=10;
    _webViewHeight3=10;
    _long=NO;
    
    [self leftButton];
    [self rightButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(limitInfoDownloadFinish) name:[NSString stringWithFormat:LIMIT_INFO,self.productId,self.suppGoodsId,self.branchType] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:LIMIT_INFO,self.productId,self.suppGoodsId,self.branchType] and:17];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _commentArray=[[NSMutableArray alloc]initWithCapacity:0];

    NSLog(@"%@",[NSString stringWithFormat:LIMIT_INFO,self.productId,self.suppGoodsId,self.branchType]);
    
    // Do any additional setup after loading the view.
}
-(void)limitInfoDownloadFinish
{
    _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:LIMIT_INFO,self.productId,self.suppGoodsId,self.branchType]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(limitCommentDownloadFinish) name:[NSString stringWithFormat:LIMIT_INFO_COMMENT,self.productId] object:nil];
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:LIMIT_INFO_COMMENT,self.productId] and:4];
    
    NSLog(@"comment=%@",[NSString stringWithFormat:LIMIT_INFO_COMMENT,self.productId]);

    [self hudHide];
    [self createTop:[[_dataArray firstObject] objectForKey:@"imageList"]];
    _LVTableView.alpha=1;
    [self createPayButton];

    [_LVTableView reloadData];
}

-(void)createPayButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 41);
    [button setBackgroundImage:[UIImage imageNamed:@"middleRedBtnBg.png"] forState:UIControlStateNormal];
    [button setTitle:[[_dataArray firstObject] objectForKey:@"buttonText"]forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [button setTintColor:[UIColor whiteColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:button];
}

-(void)payClick
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}

-(void)limitCommentDownloadFinish
{
    _commentArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:LIMIT_INFO_COMMENT,self.productId]];
}
-(void)createTop:(NSArray *)array
{
    if (!_scrol) {
        [self createHeadViewAndPageControl];
    }
    
    if (array.count&&_scrol) {
        _pageControl.numberOfPages=array.count;
        [self createProductIdLabel];
        [self updateTopImageHead:array];
        [self createRest];
    }
}

-(void)createRest
{
    UILabel *cellProductName=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, _scrol.bounds.size.height+7, self.view.bounds.size.width-85, 30)];
    cellProductName.numberOfLines=0;
    [_headerView addSubview:cellProductName];
    cellProductName.font=[UIFont systemFontOfSize:13];
    cellProductName.textColor=[UIColor blackColor];
    
    NSString *string=[NSString stringWithFormat:@"%@",[[_dataArray firstObject] objectForKey:@"productName"]];
    CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH*2, 1000);
    UIFont *font=[UIFont systemFontOfSize:13];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
    cellProductName.attributedText=attribute;
    
    cellProductName.frame=CGRectMake(WIDTH, _scrol.bounds.size.height+7, self.view.bounds.size.width-WIDTH*2, actualSize.height);
    [cellProductName sizeToFit];
    
    UILabel *cellAddress=[[UILabel alloc]init];
    cellAddress.numberOfLines=0;
    [_headerView addSubview:cellAddress];
    cellAddress.font=[UIFont systemFontOfSize:13];
    cellAddress.textColor=[UIColor blackColor];
    cellAddress.frame=CGRectMake(WIDTH, _scrol.bounds.size.height+3+actualSize.height+10, self.view.bounds.size.width-85, 30);
    if ([[[_dataArray firstObject] objectForKey:@"productTypeV2"] length]) {
        cellAddress.text=[NSString stringWithFormat:@"%@ | %@",[[_dataArray firstObject] objectForKey:@"productTypeV2"],[[_dataArray firstObject] objectForKey:@"departurePlace"]];
    }else cellAddress.text=@"";
    
    [cellAddress sizeToFit];
    
    UILabel *cellSellPriceYuan=[[UILabel alloc]init];
    cellSellPriceYuan.numberOfLines=0;
    [_headerView addSubview:cellSellPriceYuan];
    cellSellPriceYuan.textColor=[UIColor grayColor];
    cellSellPriceYuan.font=[UIFont systemFontOfSize:10];
    
    NSString *stockCountstring=[NSString stringWithFormat:@"￥%@起",[NSString stringWithFormat:@"%d",[[[_dataArray firstObject] objectForKey:@"sellPriceYuan"] intValue]]];
    UIFont *stockFont=[UIFont boldSystemFontOfSize:14];
    NSMutableAttributedString *stockAttribute=[[NSMutableAttributedString alloc]initWithString:stockCountstring];
    NSDictionary *stockColor=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,stockFont,NSFontAttributeName,nil];
    [stockAttribute addAttributes:stockColor range:NSMakeRange(0,stockCountstring.length-1)];
    
    cellSellPriceYuan.attributedText=stockAttribute;
    cellSellPriceYuan.frame=CGRectMake(WIDTH,actualSize.height+_scrol.bounds.size.height+cellAddress.bounds.size.height+10, 100, 20);
    [cellSellPriceYuan sizeToFit];
    
    UILabel *cellMarketPriceYuan=[[UILabel alloc]init];
    cellMarketPriceYuan.font=[UIFont boldSystemFontOfSize:10];
    cellMarketPriceYuan.textColor=[UIColor lightGrayColor];
    cellMarketPriceYuan.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:cellMarketPriceYuan];
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0,cellMarketPriceYuan.bounds.size.height/2-1,cellMarketPriceYuan.bounds.size.width, 1.5)];
    line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
    [cellMarketPriceYuan addSubview:line];
    line.alpha=0;
    
    if ([[_dataArray firstObject] objectForKey:@"marketPriceYuan"]) {
        cellMarketPriceYuan.text=[NSString stringWithFormat:@"￥%@",[NSString stringWithFormat:@"%d",[[[_dataArray firstObject] objectForKey:@"marketPriceYuan"] intValue]]];
        cellMarketPriceYuan.frame=CGRectMake(WIDTH+cellSellPriceYuan.bounds.size.width+5, cellSellPriceYuan.frame.origin.y+4, 60, cellSellPriceYuan.bounds.size.height);
        [cellMarketPriceYuan sizeToFit];
        line.alpha=1;
        line.frame=CGRectMake(0,cellMarketPriceYuan.bounds.size.height/2-1, cellMarketPriceYuan.bounds.size.width, 1.5);
    }
    
    UILabel *orderCount=[[UILabel alloc]init];
    orderCount.text=[NSString stringWithFormat:@"%@人已购买",[[_dataArray firstObject] objectForKey:@"orderCount"]];
    orderCount.frame=CGRectMake(10, cellMarketPriceYuan.frame.origin.y, 100, 20);
    [_headerView addSubview:orderCount];
    orderCount.font=[UIFont boldSystemFontOfSize:10];
    orderCount.textColor=[UIColor grayColor];
    [orderCount sizeToFit];
    [self resizeOrderCount:orderCount];
    
    UIImageView *separateLine=[[UIImageView alloc]init];
    separateLine.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
    [_headerView addSubview:separateLine];
    separateLine.frame=CGRectMake(0,cellSellPriceYuan.bounds.size.height+cellSellPriceYuan.frame.origin.y+5, self.view.bounds.size.width, 1);
    
    UILabel *cellHint=[[UILabel alloc]init];
    cellHint.font=[UIFont boldSystemFontOfSize:13];
    cellHint.textColor=[UIColor orangeColor];
    cellHint.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:cellHint];
    cellHint.frame=CGRectMake(WIDTH, separateLine.frame.origin.y+7, 100, 13);
    cellHint.text=@"抢购中";
    
    UILabel *cellRestTime=[[UILabel alloc]init];
    cellRestTime.font=[UIFont systemFontOfSize:14];
    cellRestTime.textColor=[UIColor whiteColor];
    cellRestTime.textAlignment=NSTextAlignmentLeft;
    
    UIView *backColor=[[UIView alloc]init];
    backColor.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    [_headerView addSubview:backColor];
    
    UILabel *tian=[[UILabel alloc]init];
    tian.text=@"天";
    tian.textColor=[UIColor grayColor];
    tian.font=[UIFont systemFontOfSize:14];
    tian.backgroundColor=[UIColor whiteColor];
    tian.textAlignment=NSTextAlignmentCenter;
    [_headerView addSubview:tian];
    
    UILabel *dian=[[UILabel alloc]init];
    dian.text=@":";
    dian.textColor=[UIColor grayColor];
    dian.font=[UIFont systemFontOfSize:14];
    dian.backgroundColor=[UIColor whiteColor];
    dian.textAlignment=NSTextAlignmentCenter;
    [_headerView addSubview:dian];
    
    UILabel *dian1=[[UILabel alloc]init];
    dian1.text=@":";
    dian1.textColor=[UIColor grayColor];
    dian1.font=[UIFont systemFontOfSize:14];
    dian1.backgroundColor=[UIColor whiteColor];
    dian1.textAlignment=NSTextAlignmentCenter;
    [_headerView addSubview:dian1];
    [_headerView addSubview:cellRestTime];
    
    cellRestTime.frame=CGRectMake(self.view.bounds.size.width-120-WIDTH, separateLine.frame.origin.y+5, 120, 20);
    cellRestTime.text=[self getRestTime:[[_dataArray firstObject] objectForKey:@"secKillEndTime"]];
    [cellRestTime sizeToFit];
    
    backColor.frame=CGRectMake(self.view.bounds.size.width-120-WIDTH-3, cellRestTime.frame.origin.y, cellRestTime.frame.size.width+6,cellRestTime.bounds.size.height);
    
    tian.frame=CGRectMake(self.view.bounds.size.width-120-WIDTH+18, cellRestTime.frame.origin.y, 16, cellRestTime.frame.size.height);
    
    dian.frame=CGRectMake(self.view.bounds.size.width-120-WIDTH+57, cellRestTime.frame.origin.y, 12, cellRestTime.frame.size.height);
    
    dian1.frame=CGRectMake(self.view.bounds.size.width-120-WIDTH+89, cellRestTime.frame.origin.y, 12, cellRestTime.frame.size.height);
    [self createRestTimeTimer];
    _restLabel=cellRestTime;
    
    if([[[_dataArray firstObject] objectForKey:@"clientProdActivityVos"] count])
    {
        for (NSInteger i=0; i<_dataArray.count; i++) {
            UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
            grayArear.frame=CGRectMake(0, cellRestTime.frame.origin.y+cellRestTime.frame.size.height+6, self.view.bounds.size.width, 10);
            [_headerView addSubview:grayArear];
            
            UILabel *activityHint=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, grayArear.frame.origin.y+grayArear.frame.size.height+WIDTH, 100, 20)];
            activityHint.backgroundColor=[UIColor colorWithRed:0.3 green:0.67 blue:0.98 alpha:1];
            activityHint.font=[UIFont boldSystemFontOfSize:12];
            activityHint.textAlignment=NSTextAlignmentCenter;
            [_headerView addSubview:activityHint];
            activityHint.text=@"活动";
            activityHint.textColor=[UIColor whiteColor];
            [activityHint sizeToFit];
            [self resize:activityHint];
            
            UILabel *activity=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+activityHint.frame.size.width+activityHint.frame.origin.x, activityHint.frame.origin.y, 100, 20)];
            activity.font=[UIFont systemFontOfSize:12];
            activity.textAlignment=NSTextAlignmentCenter;
            [_headerView addSubview:activity];
            
            activity.text=[[[[_dataArray firstObject] objectForKey:@"clientProdActivityVos"] objectAtIndex:i] objectForKey:@"actTheme"];
            activity.textColor=[UIColor blackColor];
            [activity sizeToFit];
            [self resize:activity];
            
            UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow.png"]];
            arrow.frame=CGRectMake(self.view.bounds.size.width-15, activityHint.frame.origin.y, 9, 13);
            [_headerView addSubview:arrow];
            
            if (i>0) {
                [[[UIAlertView alloc]initWithTitle:@"确定控件位置" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
            _restHeight=activityHint.frame.origin.y+activityHint.frame.size.height+WIDTH;
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0,grayArear.frame.origin.y+grayArear.frame.size.height, self.view.bounds.size.width, activityHint.bounds.size.height+WIDTH*2);
            button.tag=100+i;
            [button addTarget:self action:@selector(clientProdActivityVos:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:button];
        }
    }else
    {
        _restHeight=cellRestTime.frame.origin.y+cellRestTime.frame.size.height+6;
    }
    
    if ([[[_dataArray firstObject] objectForKey:@"address"] length]) {
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear.frame=CGRectMake(0, _restHeight, self.view.bounds.size.width, 10);
        [_headerView addSubview:grayArear];
        
        UIImageView *addressPic=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH, grayArear.frame.origin.y+grayArear.frame.size.height+WIDTH, 15, 15)];
        addressPic.image=[UIImage imageNamed:@"placeAddress.png"];
        [_headerView addSubview:addressPic];
        
        UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+addressPic.frame.origin.x+addressPic.frame.size.width, addressPic.frame.origin.y, 100, 20)];
        address.font=[UIFont systemFontOfSize:12];
        address.textAlignment=NSTextAlignmentCenter;
        [_headerView addSubview:address];
        
        address.text=[[_dataArray firstObject] objectForKey:@"address"];
        address.textColor=[UIColor blackColor];
        [address sizeToFit];
        [self resize:address];
        
        UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow.png"]];
        arrow.frame=CGRectMake(self.view.bounds.size.width-15, address.frame.origin.y, 9, 13);
        [_headerView addSubview:arrow];
     
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, _restHeight+10, self.view.bounds.size.width, addressPic.bounds.size.height+WIDTH*2);
        button.tag=100;
        [button addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:button];
        
        _restHeight=address.frame.origin.y+address.frame.size.height+WIDTH;
    }
    
    
    if ([[[_dataArray firstObject] objectForKey:@"secondTagItems"] count]) {
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear.frame=CGRectMake(0, _restHeight, self.view.bounds.size.width, 30);
        [_headerView addSubview:grayArear];
        UILabel *hint=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, 0, grayArear.frame.size.width, grayArear.frame.size.height)];
        hint.text=@"活动优惠";
        hint.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hint];
        
        NSArray * secondTagItems=[[_dataArray firstObject]objectForKey:@"secondTagItems"];
        
        for (int i=0; i<secondTagItems.count;i++) {
            NSDictionary *dict=[secondTagItems objectAtIndex:i];
            
            if ([[dict objectForKey:@"tagType"]isEqualToString:@"refund"]) {
                UILabel *refound=[[UILabel alloc]init];
                if (i==0) {
                    refound.frame=CGRectMake(WIDTH, 5+grayArear.frame.origin.y+grayArear.frame.size.height, 100, 20);
                }else
                {
                    refound.frame=CGRectMake(WIDTH, 5+_restHeight, 100, 20);
                }
                refound.textColor=[UIColor whiteColor];
                [_headerView addSubview:refound];
                refound.text=[dict objectForKey:@"name"];
                refound.backgroundColor=[self colorWithHexString:[dict objectForKey:@"color"]];
                refound.font=[UIFont boldSystemFontOfSize:10];
                [refound sizeToFit];
                refound.textAlignment=NSTextAlignmentCenter;
                [self resize:refound];
                
                UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(refound.frame.origin.x+refound.frame.size.width+WIDTH, refound.frame.origin.y-1, self.view.bounds.size.width-WIDTH-refound.frame.origin.x-refound.frame.size.width, 30)];
                desc.font=[UIFont systemFontOfSize:12];
                desc.numberOfLines=0;
                desc.text=[dict objectForKey:@"desc"];
                [desc sizeToFit];
                [_headerView addSubview:desc];
                if (i==0) {
                    _restHeight+=grayArear.bounds.size.height+5+desc.bounds.size.height+5;
                }else
                {
                    _restHeight+=5+desc.bounds.size.height+5;
                }
            }
            else if ([[dict objectForKey:@"tagType"]isEqualToString:@"moreRefund"])
            {
                UIImageView *phone=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"routePhoneIcon.png"]];
                phone.contentMode=UIViewContentModeCenter;
                if (i==0) {
                    phone.frame=CGRectMake(WIDTH, 5+grayArear.frame.origin.y+grayArear.frame.size.height, 13, 12);
                }else
                {
                    phone.frame=CGRectMake(WIDTH, _restHeight, 13, 12);
                }
                [_headerView addSubview:phone];
                phone.backgroundColor=[self colorWithHexString:[dict objectForKey:@"color"]];
                
                UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(phone.frame.origin.x+phone.frame.size.width+WIDTH, phone.frame.origin.y-1, self.view.bounds.size.width-WIDTH-phone.frame.origin.x-phone.frame.size.width, 30)];
                desc.font=[UIFont systemFontOfSize:12];
                desc.numberOfLines=0;
                desc.text=[dict objectForKey:@"desc"];
                [desc sizeToFit];
                [_headerView addSubview:desc];
                if (i==0) {
                    _restHeight+=grayArear.bounds.size.height+5+desc.bounds.size.height;
                }else
                {
                    _restHeight+=5+desc.bounds.size.height;
                }
            }
            
            
        }

    }
    
    if ([[[_dataArray firstObject] objectForKey:@"announcement"] length]) {
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear.frame=CGRectMake(0, _restHeight, self.view.bounds.size.width, 30);
        [_headerView addSubview:grayArear];
        UILabel *hint=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, 0, grayArear.frame.size.width, grayArear.frame.size.height)];
        hint.text=@"公告";
        hint.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hint];
        
        
        
        UILabel *announcement=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, grayArear.frame.origin.y+grayArear.frame.size.height+5, self.view.bounds.size.width-WIDTH*2, 60)];
        announcement.font=[UIFont systemFontOfSize:12];
        [_headerView addSubview:announcement];
        announcement.numberOfLines=0;
        announcement.text=[[_dataArray firstObject] objectForKey:@"announcement"];
        announcement.textColor=[UIColor blackColor];
        announcement.userInteractionEnabled=YES;
        
        CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[[[_dataArray firstObject] objectForKey:@"announcement"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=announcement.bounds;
        button.tag=100;
        [button addTarget:self action:@selector(announcement:) forControlEvents:UIControlEventTouchUpInside];
        [announcement addSubview:button];
        
        if (actualSize.height>60) {
            [announcement sizeThatFits:CGSizeMake(announcement.frame.size.width, 60)];
            
        }else
        {
            [announcement sizeToFit];
            button.enabled=NO;
        }

        _restHeight=announcement.frame.origin.y+announcement.frame.size.height+WIDTH;
    }
    
    if ([[[_dataArray firstObject] objectForKey:@"managerRecommend"] length]) {
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear.frame=CGRectMake(0, _restHeight, self.view.bounds.size.width, 30);
        grayArear.tag=10000;
        [_headerView addSubview:grayArear];
        UILabel *hint=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, 0, grayArear.frame.size.width, grayArear.frame.size.height)];
        hint.text=@"推荐理由";
        hint.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hint];
        
        UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH,grayArear.bounds.size.height+grayArear.frame.origin.y+5, self.view.bounds.size.width-WIDTH*2,30)];
        desc.font=[UIFont systemFontOfSize:12];
        desc.numberOfLines=0;
        desc.tag=10001;
        desc.text=[[_dataArray firstObject] objectForKey:@"managerRecommend"];
        [desc sizeToFit];
        [_headerView addSubview:desc];
        _restHeight=desc.frame.origin.y+desc.frame.size.height+5;
    }
    
    if ([[[_dataArray firstObject]objectForKey:@"prodGroupDateVoList"] count]) {
        
        UIView *headDate=[[UIView alloc]init];
        headDate.tag=10002;
        headDate.frame=CGRectMake(0,_restHeight,self.view.bounds.size.width, 60);
        [_headerView addSubview:headDate];
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear.frame=CGRectMake(0, 0, self.view.bounds.size.width, 30);
        [headDate addSubview:grayArear];
        
        UILabel *hint=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH, 0, grayArear.frame.size.width, grayArear.frame.size.height)];
        hint.text=@"出行价格日历";
        hint.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hint];
        
        UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow.png"]];
        arrow.frame=CGRectMake(self.view.bounds.size.width-15, grayArear.frame.origin.y+WIDTH+grayArear.bounds.size.height, 9, 13);
        [headDate addSubview:arrow];
        
        NSArray *prodGroupDateVoList=[[_dataArray firstObject]objectForKey:@"prodGroupDateVoList"] ;
        for(int i=0;i<prodGroupDateVoList.count;i++)
        {
            NSDictionary *dict=[prodGroupDateVoList objectAtIndex:i];
            
            UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+i*50, grayArear.frame.origin.y+grayArear.frame.size.height+5, 40, 20)];
            date.font=[UIFont systemFontOfSize:12];
            [headDate addSubview:date];
            date.text=[self convertToDate:[dict objectForKey:@"departureDate"]];
        }
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, grayArear.frame.origin.y+grayArear.frame.size.height, self.view.bounds.size.width, 30);
        [button addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
        [headDate addSubview:button];
        
        _restHeight+=55;

        UIImageView *grayline=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayline.frame=CGRectMake(0, 60, self.view.bounds.size.width, 10);
        [headDate addSubview:grayline];
        
        _restHeight+=grayline.frame.size.height+5;
        
    }
    
    _headerView=_LVTableView.tableHeaderView;
    _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width,_restHeight);
    _LVTableView.tableHeaderView=_headerView;

}

-(void)dateClick
{
    
    
}
-(NSString *)convertToDate:(NSString *)date
{
    NSArray *separate=[date componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@/%@",[separate objectAtIndex:1],[separate objectAtIndex:2]];
}
-(void)announcement:(UIButton *)button
{
    if ([[_dataArray firstObject] objectForKey:@"announcement"]) {
        if (_long==NO) {
            CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH*2, 1000);
            UIFont *font=[UIFont systemFontOfSize:12];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[[[_dataArray firstObject] objectForKey:@"announcement"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;

            UILabel *announcement=(UILabel *)button.superview;
            CGRect rect=announcement.frame;
            _long=YES;
            
            announcement.frame=CGRectMake(WIDTH, rect.origin.y, self.view.bounds.size.width-WIDTH*2, actualSize.height+5);
            button.frame=announcement.bounds;

            _restHeight=announcement.frame.origin.y+announcement.frame.size.height+WIDTH*2;

            if ([[[_dataArray firstObject] objectForKey:@"managerRecommend"] length]) {
                
                
                for (UIView *view in button.superview.superview.subviews) {
                    if (view.tag==10000) {
                        view.frame=CGRectMake(0, _restHeight, self.view.bounds.size.width, 30);
                    }
                    if (view.tag==10001) {
                        CGRect rect=view.frame;
                        rect.origin.y=30+_restHeight+5;
                        view.frame=rect;
                        _restHeight+=30+5+view.frame.size.height;
                    }
                        
                }
            }
            if ([[[_dataArray firstObject]objectForKey:@"prodGroupDateVoList"] count]) {
                for (UIView *view in button.superview.superview.subviews) {
                    if (view.tag==10002) {
                        CGRect rect=view.frame;
                        rect.origin.y=_restHeight;
                        view.frame=rect;
                        _restHeight+=70;
                    }
                }
            }
            _headerView=_LVTableView.tableHeaderView;
            _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width,_restHeight);
            _LVTableView.tableHeaderView=_headerView;

        }else
        {
            _long=NO;
            UILabel *announcement=(UILabel *)button.superview;
            CGRect rect=announcement.frame;

            announcement.frame=CGRectMake(WIDTH, rect.origin.y, self.view.bounds.size.width-WIDTH*2, 60);

            [announcement sizeThatFits:CGSizeMake(announcement.frame.size.width, 60)];
            button.frame=announcement.bounds;

            _restHeight=announcement.frame.origin.y+announcement.frame.size.height+WIDTH*2;
            if ([[[_dataArray firstObject] objectForKey:@"managerRecommend"] length]) {
                
                
                for (UIView *view in button.superview.superview.subviews) {
                    if (view.tag==10000) {
                        view.frame=CGRectMake(0, _restHeight, self.view.bounds.size.width, 30);
                    }
                    if (view.tag==10001) {
                        CGRect rect=view.frame;
                        rect.origin.y=30+_restHeight+5;
                        view.frame=rect;
                        _restHeight+=35+rect.size.height;
                    }
                    
                    if (view.tag==10002)
                    {
                        CGRect rect=view.frame;
                        rect.origin.y=_restHeight;
                        view.frame=rect;
                        _restHeight+=60;
                    }
                }
            }
            if ([[[_dataArray firstObject]objectForKey:@"prodGroupDateVoList"] count]) {
                for (UIView *view in button.superview.superview.subviews) {
                    if (view.tag==10002) {
                        CGRect rect=view.frame;
                        rect.origin.y=_restHeight;
                        view.frame=rect;
                        _restHeight+=70;
                    }
                }
            }
            
            _headerView=_LVTableView.tableHeaderView;
            _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width,_restHeight);
            
            _LVTableView.tableHeaderView=_headerView;
            
        }

    }
}

-(void)addressClick:(UIButton *)button
{
    NSLog(@"地图");
}
-(void)clientProdActivityVos:(UIButton *)button
{
    HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
    top.url=[[[[_dataArray firstObject] objectForKey:@"clientProdActivityVos"] objectAtIndex:button.tag-100] objectForKey:@"actUrl"];
    [self.navigationController pushViewController:top animated:YES];
}
-(NSString *)getRestTime:(NSString *)timeString
{
    NSString *restTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSDate * newdate = [formatter dateFromString:timeString];
    long dd =[newdate timeIntervalSince1970]- (long)[datenow timeIntervalSince1970];
    
    restTime=[NSString stringWithFormat:@"%.2ld     %.2ld    %.2ld    %.2ld",dd/86400,dd%86400/3600,dd%86400%3600/60,dd%86400%3600%60];
    //    NSLog(@"%@",restTime);
    
    return restTime;
}
-(void)createRestTimeTimer
{
    _restTimeTimer=[NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(restTimeUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_restTimeTimer forMode:NSRunLoopCommonModes];
}
-(void)restTimeUpdate
{
    _restLabel.text=[self getRestTime:[[_dataArray firstObject] objectForKey:@"secKillEndTime"]];
}

-(void)resizeOrderCount:(UIView *)view
{
    CGRect rect=view.frame;
    rect.size.width+=5;
    rect.origin.x=self.view.bounds.size.width-rect.size.width;
    view.frame=rect;
    
}

-(void)resize:(UIView *)view
{
    CGRect rect=view.frame;
    rect.size.width+=3;
    view.frame=rect;
}

-(void)createHeadViewAndPageControl
{
    if (!_headerView) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 278)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _LVTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        _scrol.pagingEnabled=YES;
        _scrol.bounces=NO;
        _scrol.showsHorizontalScrollIndicator=NO;
        _scrol.showsVerticalScrollIndicator=NO;
        [_headerView addSubview:_scrol];
        _scrol.delegate=self;
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, _scrol.bounds.size.height-20, self.view.bounds.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }
}

-(void)updateTopImageHead:(NSArray *)array
{
    for (int i=0; i<array.count; i++) {
        _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*array.count, 0);
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, _scrol.bounds.size.height)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[array objectAtIndex:i]]placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]] ;
        
        [_scrol addSubview:imageView];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=imageView.frame;
        button.tag=100+i;
        [button addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrol addSubview:button];

    }
}

-(void)createProductIdLabel
{
    UILabel *productId=[[UILabel alloc]initWithFrame:CGRectMake(0, _scrol.bounds.size.height-40, 200, 20)];
    productId.text=[NSString stringWithFormat:@"产品编号:%@",[[[_dataArray firstObject] objectForKey:@"productId"] stringValue]];
    productId.textColor=[UIColor whiteColor];
    productId.textAlignment=NSTextAlignmentCenter;
    productId.font=[UIFont boldSystemFontOfSize:11];
    [productId sizeToFit];
    
    UIView *productView=[[UIView alloc]initWithFrame:productId.frame];
    productId.backgroundColor=[UIColor blackColor];
    productId.alpha=0.75;
    [_LVTableView addSubview:productView];
    [_LVTableView addSubview:productId];
    [self resizeProductIdLabel:productId andProductView:productView];
    
}

-(void)resizeProductIdLabel:(UILabel *)productLabel andProductView:(UIView *)productView
{
    CGRect rect=productLabel.frame;
    rect.size.width+=5;
    rect.size.height+=5;
    rect.origin.x=self.view.bounds.size.width-rect.size.width;
    productLabel.frame=rect;
    productView.frame=rect;
}

-(void)scrollViewClick:(UIButton *)button
{
    [self animationWithPicClick:[[_dataArray firstObject] objectForKey:@"imageList"] andTheCurrent:(int)button.tag-100 andtype:0];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_scrol) {
        int count=scrollView.contentOffset.x/self.view.bounds.size.width;
        _pageControl.currentPage=count;
    }
}


-(void)rightButton
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[NSArray arrayWithObjects:@"placeDetailUncollected.png",@"shareBtn.png",nil];
    for (NSInteger i=array.count-1; i>=0; i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage :[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 32, 32);
        button.imageEdgeInsets = UIEdgeInsetsMake(0,18, 0,-18);
        
        [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
        button.tag=100+i;
        [items addObject:item];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -1;
        [items addObject:negativeSpacer];
    }
    
    self.navigationItem.rightBarButtonItems=items;
}

-(void)rightClick:(UIButton *)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];

}
-(void)createTableView
{
    if (!_LVTableView) {
        _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-41) style:UITableViewStylePlain];
        _LVTableView.delegate=self;
        _LVTableView.dataSource=self;
        _LVTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _LVTableView.alpha=0;
        [self.view addSubview:_LVTableView];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        static NSString *cellIde=@"cellFir";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            
        }
        
        for (UIWebView *webView in cell.subviews) {
            if ([webView isKindOfClass:[UIWebView class]]) {
                if (_webViewHeight!=webView.scrollView.contentSize.height) {
                    webView.frame=CGRectMake(0, 0, self.view.bounds.size.width, _webViewHeight);
                }
                return cell;
            }
        }
        
        UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _webViewHeight)];
        [cell addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[[_dataArray firstObject]objectForKey:@"clientProdProductPropBaseVos"] firstObject] objectForKey:@"url"]]]];
        webView.scrollView.scrollEnabled=NO;
        webView.delegate=self;
        
        return cell;
    }
    if (tag==101) {
        static NSString *cellIde=@"cellSec";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        
        for (UIWebView *webView in cell.subviews) {
            if ([webView isKindOfClass:[UIWebView class]]) {
                if (_webViewHeight2!=webView.scrollView.contentSize.height) {
                    webView.frame=CGRectMake(0, 0, self.view.bounds.size.width, _webViewHeight2);
                }
                return cell;
            }
        }
        
        UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _webViewHeight2)];
        [cell addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[[_dataArray firstObject]objectForKey:@"clientProdProductPropBaseVos"] objectAtIndex:1] objectForKey:@"url"]]]];
        webView.scrollView.scrollEnabled=NO;
        webView.delegate=self;
        
        return cell;
    }
    if (tag==102) {
        static NSString *cellIde=@"cellThir";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            
        }
        
        for (UIWebView *webView in cell.subviews) {
            if ([webView isKindOfClass:[UIWebView class]]) {
                if (_webViewHeight3!=webView.scrollView.contentSize.height) {
                    webView.frame=CGRectMake(0, 0, self.view.bounds.size.width, _webViewHeight3);
                }
                return cell;
            }
        }
        
        UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _webViewHeight3)];
        [cell addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[[_dataArray firstObject]objectForKey:@"clientProdProductPropBaseVos"] objectAtIndex:2] objectForKey:@"url"]]]];
        webView.scrollView.scrollEnabled=NO;
        webView.delegate=self;
        
        return cell;
    }else if (tag==103)
    {
        static NSString *cellName=@"cellCommentComment";
        LimitCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[LimitCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
        }
        cell.cellComment.text=@"";
        cell.cellTime.text=@"";
        cell.cellUserName.text=@"";
        cell.picArray=nil;
        cell.comment=@"";
        cell.time=@"";
        cell.userName=@"";
        cell.avgScore=@"";
        NSDictionary *dict=[_commentArray objectAtIndex:indexPath.row];
        cell.comment=[dict objectForKey:@"content"];
        if ([[dict objectForKey:@"cmtPictureList"] count]) {
            cell.picArray=[dict objectForKey:@"cmtPictureList"];
        }else
        {
            cell.picArray=nil;
        }
        
        cell.time=[dict objectForKey:@"createdTime"];
        cell.userName=[dict objectForKey:@"userName"];
        cell.avgScore=[dict objectForKey:@"avgScore"];
        return cell;
        
    }
    else
    {
        static NSString *cellIde=@"cellCost";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        
        
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        return _webViewHeight;
    }else if (tag==101) {
        return _webViewHeight2;
    }else if (tag==102) {
        NSLog(@"%d",_webViewHeight3);
        return _webViewHeight3;
    }else if (tag==103) {
        int height=0;
        NSDictionary *dict=[_commentArray objectAtIndex:indexPath.row];
        CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dictSize=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[[dict objectForKey:@"content"]  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dictSize context:nil].size;
        height+=actualSize.height+68;
        
        if ([[dict objectForKey:@"cmtPictureList"] count] ) {
            height+=45;
        }
        return height;
    }
    else
        return 0;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSInteger tag=[self buttonTag];
    CGRect frame = webView.frame;
    frame.size.height=webView.scrollView.contentSize.height;
    webView.frame = frame;
    if (tag==100) {
        if (_webViewHeight!=webView.scrollView.contentSize.height) {
            _webViewHeight= webView.scrollView.contentSize.height;
            [_LVTableView reloadData];
        }
    }else if (tag==101)
    {
        if (_webViewHeight2!=webView.scrollView.contentSize.height) {
            _webViewHeight2= webView.scrollView.contentSize.height;
            [_LVTableView reloadData];
        }
    }else if (tag==102)
    {
        if (_webViewHeight3!=webView.scrollView.contentSize.height) {
            _webViewHeight3= webView.scrollView.contentSize.height;
            [_LVTableView reloadData];
        }
    }

}

-(NSInteger)buttonTag
{
    NSInteger tag;
    for (UILabel *label in _headView.subviews) {
        for (UIButton *button in label.subviews) {
            if (button.selected==YES) {
                tag=button.tag;
            }
        }
    }
    return tag;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tag = [self buttonTag];
    if (tag==100) {
        return 1;
    }else if (tag==101)
        return 1;
    else if (tag==102)
        return 1;
    else if(tag==103){
        return _commentArray.count-1;
    }
    else
        return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_headView.bounds.size.height!=40) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,40)];
        _headView.userInteractionEnabled=YES;
        _headView.backgroundColor=[UIColor whiteColor];
        
        UIButton *ticket=[UIButton buttonWithType:UIButtonTypeCustom];
        ticket.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [ticket addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        ticket.tag=100;
        
        UILabel *ticketLabel=[[UILabel alloc]initWithFrame:ticket.frame];
        ticketLabel.text=@"详情";
        ticketLabel.userInteractionEnabled=YES;
        [_headView addSubview:ticketLabel];
        ticketLabel.textColor=[UIColor grayColor];
        ticketLabel.textAlignment=NSTextAlignmentCenter;
        ticketLabel.font=[UIFont systemFontOfSize:12];
        [ticketLabel addSubview:ticket];
        
        
        UIButton *introduction=[UIButton buttonWithType:UIButtonTypeCustom];
        introduction.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [introduction addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        introduction.tag=101;
        
        UILabel *vacaLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4, 0, self.view.bounds.size.width/4, _headView.bounds.size.height)];
        vacaLabel.text=@"行程";
        vacaLabel.userInteractionEnabled=YES;
        [_headView addSubview:vacaLabel];
        vacaLabel.textColor=[UIColor grayColor];
        vacaLabel.textAlignment=NSTextAlignmentCenter;
        vacaLabel.font=[UIFont systemFontOfSize:12];
        [vacaLabel addSubview:introduction];
        
        UIButton *cost=[UIButton buttonWithType:UIButtonTypeCustom];
        cost.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [cost addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        cost.tag=102;
        
        UILabel *costLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4*2, 0, self.view.bounds.size.width/4, _headView.bounds.size.height)];
        costLabel.text=@"须知";
        costLabel.userInteractionEnabled=YES;
        [_headView addSubview:costLabel];
        costLabel.textColor=[UIColor grayColor];
        costLabel.textAlignment=NSTextAlignmentCenter;
        costLabel.font=[UIFont systemFontOfSize:12];
        [costLabel addSubview:cost];
        
        ticket.selected=YES;
        ticketLabel.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
        
        UIImageView *lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        lineSe.frame=CGRectMake(0,_headView.bounds.size.height-1, self.view.bounds.size.width, 1);
        lineSe.alpha=0.3;
        [_headView addSubview:lineSe];
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabLeftSel.png"]];
        line.frame=CGRectMake(ticketLabel.center.x-11, _headView.bounds.size.height-3, 23, 3);
        [_headView addSubview:line];
    }
    
    if (_dataArray.count&&_headView.subviews.count==5) {
        UIButton *comment=[UIButton buttonWithType:UIButtonTypeCustom];
        comment.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [comment addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        comment.tag=103;
        
        UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4*3, 0, self.view.bounds.size.width/4, _headView.bounds.size.height)];
        commentLabel.userInteractionEnabled=YES;
        [_headView addSubview:commentLabel];
        commentLabel.textColor=[UIColor grayColor];
        commentLabel.textAlignment=NSTextAlignmentCenter;
        commentLabel.font=[UIFont systemFontOfSize:12];
        [commentLabel addSubview:comment];
        
        if ([[[_dataArray firstObject] objectForKey:@"commentCount"] intValue]>999) {
            commentLabel.text=[NSString stringWithFormat:@"点评(999+)"];
        }else
        {
            commentLabel.text=[NSString stringWithFormat:@"点评(%@)",[[_dataArray firstObject] objectForKey:@"commentCount"]];
        }
    }
    
    return _headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)sectionClick:(UIButton *)button
{
    for (UILabel *label in button.superview.superview.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor grayColor];
            for (UIButton *btn in label.subviews) {
                btn.selected=NO;
            }
        }
    }
    for (UIImageView *line in button.superview.superview.subviews) {
        if ([line isKindOfClass:[UIImageView class]]) {
            if (line.frame.size.height==3) {
                [UIView animateWithDuration:0.2f animations:^{
                    if (button.tag==100) {
                        line.frame=CGRectMake(button.superview.center.x-10, _headView.bounds.size.height-3, 22, 3);
                    }else if (button.tag==101)
                    {
                        line.frame=CGRectMake(button.superview.center.x-10, _headView.bounds.size.height-3, 22, 3);
                    }else if (button.tag==102)
                    {
                        line.frame=CGRectMake(button.superview.center.x-10, _headView.bounds.size.height-3, 22, 3);
                    }
                    else if (button.tag==103)
                    {
                        line.frame=CGRectMake(button.superview.center.x-10, _headView.bounds.size.height-3, 22, 3);
                    }
                }];
            }
        }
    }
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    [_LVTableView reloadData];
}



-(void)animationWithPicClick:(NSArray *)pic andTheCurrent:(int)current andtype:(int)type
{
    if (_capture) {
        [_capture removeFromSuperview];
        _capture=nil;
    }
    
    if (!_capture) {
        _capture=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _capture.image=[self capture:self.navigationController.view];
        _capture.contentMode=UIViewContentModeScaleAspectFill;
        [self.navigationController.view addSubview:_capture];
    }
    
    if (!_blackView) {
        _blackView=[[UIView alloc]initWithFrame:self.navigationController.view.bounds];
        _blackView.backgroundColor=[UIColor blackColor];
        [self.navigationController.view addSubview:_blackView];
        [self.navigationController.view insertSubview:_blackView belowSubview: _capture];
    }
    
    [self createPicScrollView:pic andTheCurrent:current andType:type];
    
    CGRect rect=_capture.frame;
    rect.origin.x+=10;
    rect.origin.y+=10;
    rect.size.width-=20;
    rect.size.height-=20;
    
    [UIView animateWithDuration:0.6 animations:^{
        _capture.frame=rect;
        _capture.alpha=0;
    } completion:^(BOOL finished) {
        _picScrollView.alpha=1;
    }];
}

-(void)createPicScrollView:(NSArray *)pic andTheCurrent:(int)current andType:(int)type
{
    if (!_picScrollView) {
        _picScrollView=[[UIScrollView alloc]initWithFrame:self.navigationController.view.bounds];
        _picScrollView.alpha=0;
        _picScrollView.pagingEnabled=YES;
        _picScrollView.bounces=NO;
        _picScrollView.showsHorizontalScrollIndicator=NO;
        _picScrollView.showsVerticalScrollIndicator=NO;
        [self.navigationController.view addSubview:_picScrollView];
        _picScrollView.delegate=self;
        _picScrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*pic.count, 0);
        for (int i=0; i<pic.count; i++) {
            UIImageView *picture=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [_picScrollView addSubview:picture];
            if (type==0) {
                [picture sd_setImageWithURL:[NSURL URLWithString:[pic objectAtIndex:i]] placeholderImage:nil];
            }else
            [picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[[pic objectAtIndex:i] objectForKey:@"picUrl"]]] placeholderImage:nil];
            picture.userInteractionEnabled=YES;
            picture.contentMode=UIViewContentModeScaleAspectFit;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(picture.frame.origin.x, 0, _picScrollView.bounds.size.width, _picScrollView.bounds.size.height);
            [button addTarget:self action:@selector(picClick) forControlEvents:UIControlEventTouchUpInside];
            button.tag=100+i;
            [_picScrollView addSubview:button];
        }
    }
    [_picScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*current, 0) animated:NO];
}

-(void)picClick
{
    [UIView animateWithDuration:0.2 animations:^{
        _picScrollView.alpha=0;
    } completion:^(BOOL finished) {
        [_picScrollView removeFromSuperview];
        for (UIView *view in _picScrollView.subviews) {
            [view removeFromSuperview];
        }
        _picScrollView=nil;
        _capture.alpha=1;
        [UIView animateWithDuration:0.3 animations:^{
            _capture.frame=self.navigationController.view.bounds;
        } completion:^(BOOL finished) {
            [_blackView removeFromSuperview];
            _blackView=nil;
            [_capture removeFromSuperview];
            _capture =nil;
        }];
    }];
}

#pragma mark 截图到UIImage

-(UIImage *)capture:(UIView *)cocoView
{
    UIGraphicsBeginImageContextWithOptions(cocoView.bounds.size,cocoView.opaque, 0.0);
    [cocoView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *centerImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return centerImage;
}


-(UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma pic delegate
-(void)picClick:(NSArray *)array andTheCount:(int)count
{
    [self animationWithPicClick:array andTheCurrent:count andtype:1];
}



@end
