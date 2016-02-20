//
//  HomeViewController.m
//  LvMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//  展示 1:景点门票的景点详情 动画效果 评论界面
//      2:国内游
//      3:火车票
//      4：首页活动界面

#import "HomeViewController.h"
#import "LVDownLoadManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "LVHomeCell.h"
#import "HomeTopDetailViewController.h"
#import "HomeTicketViewController.h"
#import "HomeNearViewController.h"
#import "HomeChinaViewController.h"
#import "HomeAbroadViewController.h"
#import "HomeShipViewController.h"
#import "HomeTrainViewController.h"
#import "HomeTourViewController.h"
#import "HomeTempViewController.h"
#import "HomeTripForMyselfViewController.h"
#import "HomeSummerViewController.h"
#import "lvmamaAppDelegate.h"
#import "HomeActivityDetailViewController.h"
#import "HomeOnePriceViewController.h"
#import "HomeHotActivityViewController.h"
#import "HomeDetailViewController.h"
#import "CBHomeRefreshControl.h"
#import "HomePindaoViewController.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "LimitMoreViewController.h"
#import "LimitInfoViewController.h"
#import "UIButton+NMCategory.h"
@interface HomeViewController ()
<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,MBProgressHUDDelegate,adDownLoad>

@property (nonatomic,strong) UITableView *lvTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *heightArray;
@property (nonatomic,strong) NSArray *adArray;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrol;
//顶部滚动条数据
@property (nonatomic,strong) NSMutableArray *headerArray;
//顶部scrollview上面滚动广告的个数
@property (nonatomic,assign) int scollCount;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int timerCount;
//滚动条下button
@property (nonatomic,strong) NSMutableArray *buttonArray;
//tableview的headerView
@property (nonatomic,strong) UIView *headerView;
//计算tableviewheader的高度
@property (nonatomic,assign) NSInteger headHeight;
//section的headview
@property (nonatomic,strong) UIView *headView;
//判断是否有限时活动
@property (nonatomic,assign) BOOL isLimit;
@property (nonatomic,strong) NSMutableArray *activityArray;
@property (nonatomic,strong) NSMutableArray *limitArray;
@property (nonatomic,strong) CBHomeRefreshControl *storeHouseRefreshControl;
@property (nonatomic,assign) int page;
//用来判断防止page一直++
@property (nonatomic,assign) int countPage;
//判断数据是否全部加载
@property (nonatomic,assign) BOOL isWeekAllShow;
@property (nonatomic,assign) BOOL isVacationAllShow;
@property (nonatomic,assign) CGPoint weekInSets;
@property (nonatomic,assign) CGPoint vacationInSets;
//是否切换了数据 记录上一次tableview的位置
@property (nonatomic,assign) BOOL isChange;
@property (nonatomic,assign) int scrollHeight;
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,strong) UITableView *searchTableview;
//限时抢购剩余时间相关控件
@property (nonatomic,strong) UILabel *restTimeLabel;
@property (nonatomic,strong) NSTimer *restTimeTimer;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) UIImageView *animate;
@property (nonatomic,assign) long long expectedLength;
@property (nonatomic,assign) long long currentLength;
@property (nonatomic,strong) UIWindow *adWindow;



@end

@implementation HomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, self.view.bounds.size.height-46, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
    if (_timer.valid==NO&&_headerArray.count&&_scrol) {
        [self createTimer];
    }
    if (!_lvTableView) {
        [self createNavigation];
        [self createTableView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (_timer) {
        [_timer invalidate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollHeight=778;
    _page=1;
    _countPage=1;
    _isWeekAllShow=NO;
    _isVacationAllShow=NO;
    _weekInSets=CGPointMake(0, _scrollHeight);
    _vacationInSets=CGPointMake(0, _scrollHeight);
    self.navigationController.navigationBarHidden=YES;
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).delegate=self;
    [self createHeaderView];
    [self downloadAndAddObserver];
    NSLog(@"%@",[NSString stringWithFormat:INFOURL,_page]);
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _heightArray=[[NSMutableArray alloc]initWithCapacity:0];
    

    //[btn addTarget:self action:@selector(showTag:) forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
}

-(void)createHeaderView
{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1000)];
    _headerView.backgroundColor=[UIColor whiteColor];
    //
}

-(void)downloadAndAddObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(limitDownloadFinish) name:LIMITBJ object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:LIMITBJ and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollDownloadFinish) name:SCROLLURL object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:SCROLLURL and:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonDownloadFinish) name:BUTTONURL object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:BUTTONURL and:1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityDownloadFinish) name:ACTIVITY object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:ACTIVITY and:2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoDownLoadFinish) name:[NSString stringWithFormat:INFOURL,_page] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:INFOURL,_page] and:9];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NoInternet) name:@"NOINTERNET" object:nil];
}

-(void)createWindow:(NSArray *)adArray
{
    if (adArray.count) {
        _adWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _adWindow.windowLevel=UIWindowLevelNormal;
        UIImageView *back=[[UIImageView alloc]initWithFrame:_adWindow.bounds];
        NSDictionary *dict =[adArray objectAtIndex:0];
        [back sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"imgUrl"]] placeholderImage:nil];

        [_adWindow addSubview:back];
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        adButton.frame=_adWindow.bounds;
        [adButton addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
        [_adWindow addSubview:adButton];
        
        [_adWindow makeKeyAndVisible];
        _adWindow.userInteractionEnabled=YES;
        back.userInteractionEnabled=YES;

        _adWindow.alpha=1;
        [self performSelector:@selector(windowHide) withObject:nil afterDelay:3.0];
    }else
    {
        _lvTableView.alpha=1;
    }
}

-(void)adClick:(UIButton *)button
{
    HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
    NSString *url=[((NSDictionary *)[_adArray objectAtIndex:0])objectForKey:@"clickUrl"];
    top.url=url;
    top.homeTitle=[((NSDictionary *)[_adArray objectAtIndex:0])objectForKey:@"name"];
    [self.navigationController pushViewController:top animated:YES];
    for (UIView *subView in _adWindow.subviews) {
        [subView removeFromSuperview];
    }
    [_adWindow resignKeyWindow];
    _adWindow.hidden=YES;
    _lvTableView.alpha=1;
}

-(void)windowHide
{
    if (_adWindow) {
        for (UIView *subView in _adWindow.subviews) {
            [subView removeFromSuperview];
        }
        [_adWindow resignKeyWindow];

        [UIView animateWithDuration:0.5 animations:^{
            _adWindow.hidden=YES;
            _lvTableView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void)adDownloadFinish:(NSArray *)adArray
{
    HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
    NSString *url=[((NSDictionary *)[adArray objectAtIndex:0])objectForKey:@"clickUrl"];
    top.url=url;
    top.homeTitle=[((NSDictionary *)[adArray objectAtIndex:0])objectForKey:@"name"];
    [self.navigationController pushViewController:top animated:YES];
    _lvTableView.alpha=1;
}

-(void)NoInternet
{
    [self hudHide];
}
- (void)hudShow {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lvmmIcon.png"]];
        _animate=[[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, _HUD.customView.bounds.size.width+20,_HUD.customView.bounds.size.height+20)];
        [_HUD.customView addSubview:_animate];
        // Set custom view mode
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.delegate = self;
        _HUD.labelText=@"驴妈妈去旅游";
    }

    [_HUD show:YES];
    [self startAnimate];
}

-(void)startAnimate
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=1; i<9; i++) {
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png",i]]];
    }
    _animate.animationImages=array;
    _animate.animationDuration=0.8;
    _animate.animationRepeatCount=0;
    [_animate startAnimating];
}

-(void)_HUDHide
{
    [_HUD hide:YES];
}

-(void)infoDownLoadFinish
{
    NSInteger tag=[self weekOrVacation:[self tableView:_lvTableView viewForHeaderInSection:0]];
    if (_lvTableView.tableFooterView) {
        UIView *foot=_lvTableView.tableFooterView;
        [foot removeFromSuperview];
    }

    if (_page==1) {
        _dataArray=(NSMutableArray *)[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:INFOURL,_page]];
        NSLog(@"%@",[NSString stringWithFormat:INFOURL,_page]);
    }else
    {
        if (_page!=_countPage) {
            NSMutableArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:INFOURL,_page]];
            if ([[[array objectAtIndex:0]objectForKey:@"infos"] count]) {
                
                [[[_dataArray objectAtIndex:0]objectForKey:@"infos"] addObjectsFromArray:[[array objectAtIndex:0] objectForKey:@"infos"]];
                
            }
            if ([[[array objectAtIndex:1]objectForKey:@"infos"] count]) {
                [[[_dataArray objectAtIndex:1]objectForKey:@"infos"] addObjectsFromArray:[[array objectAtIndex:1] objectForKey:@"infos"]];

            }
            if ([[[array objectAtIndex:0]objectForKey:@"isLastPage"] boolValue]==YES) {
                _isWeekAllShow=YES;
            }else
                _isWeekAllShow=NO;
            
            if ([[[array objectAtIndex:1]objectForKey:@"isLastPage"] boolValue]==YES) {
                _isVacationAllShow=YES;
            }else
                _isVacationAllShow=NO;
        }
    }
    
    _heightArray=[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"];

    [_lvTableView reloadData];
    
    [self _HUDHide];
    
    if ((_isWeekAllShow==YES&&tag==100)||(_isVacationAllShow==YES&&tag==101)) {
        UIView *footView;
        footView=_lvTableView.tableFooterView;
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _lvTableView.tableFooterView=footView;
        UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
        label.text=@"已经加载显示完全部内容";
        [footView addSubview:label];
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        CGSize size= _lvTableView.contentSize;
        size.height+=20;
        _lvTableView.contentSize=size;
    }
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}

-(void)limitDownloadFinish
{
    _limitArray=[[NSMutableArray alloc]initWithCapacity:0];
    _limitArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:LIMITBJ];
    
    if (_limitArray.count!=0) {
        [self createLimit:_limitArray];
        _isLimit=YES;
    }else _isLimit=NO;
    if (_buttonArray.count) {
        NSLog(@"limitButton");
        [self createHeadButton];
    }
    if (_activityArray.count) {
        [self createActivity:_activityArray];
    }
}

-(void)createLimit:(NSArray *)array
{
    NSDictionary *dict=[array objectAtIndex:0];
    UILabel *leftLabel=[[UILabel alloc]init];
    if (iPhone6Plus) {
        leftLabel.frame=CGRectMake(10, 240+70+80*2+1+10+3+160+18, 60, 15);
        leftLabel.font=[UIFont systemFontOfSize:12];
    }else
    {
        leftLabel.frame=CGRectMake(10, 376+131+5, 60, 15);
        leftLabel.font=[UIFont systemFontOfSize:11];
    }
    leftLabel.text=@"限时抢购";
    [_headerView addSubview:leftLabel];
    
    UILabel *getMore=[[UILabel alloc]init];
    if (iPhone6Plus) {
        getMore.frame=CGRectMake(self.view.bounds.size.width-40, 240+70+80*2+1+10+3+160+18, 60, 15);
        getMore.font=[UIFont systemFontOfSize:12];

    }else
    {
        getMore.frame=CGRectMake(self.view.bounds.size.width-40, 376+131+5, 60, 15);
        getMore.font=[UIFont systemFontOfSize:11];
        
    }
    getMore.text=@"更多";
    getMore.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];

    [_headerView addSubview:getMore];
    
    
    UIImageView *more=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chackMore.png"]];
    if (iPhone6Plus) {
        more.frame=CGRectMake(self.view.bounds.size.width-15, 240+70+80*2+1+10+3+160+20,6,10);
    }else
    {
        more.frame=CGRectMake(self.view.bounds.size.width-15, 376+131+8,6,10);
    }
    [_headerView addSubview:more];
    
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=getMore.frame;
    [moreButton addTarget:self action:@selector(limitGetMore) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:moreButton];
    
    
    UIImageView *limitImage=[[UIImageView alloc]init];
    if (iPhone6Plus) {
        limitImage.frame=CGRectMake(10, 674+9,210,110);
    }else
    {
        limitImage.frame=CGRectMake(10, 526+5,170,80);
    }
    [limitImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]]];
    [limitImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self addProgressView:limitImage andProgressData:(float)receivedSize/(float)expectedSize];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self removeProgressView:limitImage];
    }];
    
    [_headerView addSubview: limitImage];
    
    UILabel *detail=[[UILabel alloc]init];
    
    if (iPhone6Plus) {
        detail.frame=CGRectMake(limitImage.bounds.size.width+20, 674+9, self.view.bounds.size.width-limitImage.bounds.size.width-20, 60);
        detail.font=[UIFont systemFontOfSize:15];

    }else
    {
        detail.frame=CGRectMake(190, 526+5, self.view.bounds.size.width-170-20, 30);
        detail.font=[UIFont systemFontOfSize:11];

    }
    
    detail.text=[dict objectForKey:@"title"];
    detail.numberOfLines=2;
    [_headerView addSubview:detail];
    [detail sizeToFit];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    if (iPhone6Plus) {
        line.frame=CGRectMake(limitImage.bounds.size.width+limitImage.frame.origin.x+10, 674+9+48, self.view.bounds.size.width-limitImage.bounds.size.width-limitImage.frame.origin.x-10, 1);
    }else
    {
        line.frame=CGRectMake(190, 526+5+33, self.view.bounds.size.width-190, 1);
    }
    [_headerView addSubview:line];
    
    UIImageView *line1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    if (iPhone6Plus) {
        line1.frame=CGRectMake(0, 674+99+27, self.view.bounds.size.width, 1);
    }else
    {
        line1.frame=CGRectMake(0, 526+5+90, self.view.bounds.size.width, 1);
    }
    [_headerView addSubview:line1];
    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0,674+99+28, self.view.bounds.size.width, 25);
    }else
    {
        grayArear.frame=CGRectMake(0,526+5+91 , self.view.bounds.size.width, 25);
    }
    [_headerView addSubview:grayArear];
    
    UILabel *price=[[UILabel alloc]init];

    price.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    price.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:price];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"price"]]];
    UIFont *priceFont=[UIFont boldSystemFontOfSize:13];
    if (iPhone6Plus) {
        price.frame=CGRectMake(limitImage.bounds.size.width+limitImage.frame.origin.x+10, 674+71, 100, 20);
        price.font=[UIFont boldSystemFontOfSize:25];
        priceFont=[UIFont boldSystemFontOfSize:16];
    }else
    {
        price.frame=CGRectMake(190, 526+5+30+9, 100, 20);
        price.font=[UIFont boldSystemFontOfSize:19];
        priceFont=[UIFont boldSystemFontOfSize:13];
    }
    
    NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:priceFont,NSFontAttributeName,[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
    
    
    [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0,1)];
    price.attributedText=attributedStr;
    
    UILabel *hotLabel=[[UILabel alloc]init];
    if (iPhone6Plus) {
        hotLabel.frame=CGRectMake(10, grayArear.frame.origin.y, 100, 25);
    }else
    {
        hotLabel.frame=CGRectMake(10, grayArear.frame.origin.y, 100, 25);
    }
    hotLabel.text=@"热门活动";
    hotLabel.font=[UIFont systemFontOfSize:14];
    hotLabel.textColor=[UIColor lightGrayColor];
    [_headerView addSubview:hotLabel];
    
    if (!_restTimeLabel) {
        _restTimeLabel=[[UILabel alloc]init];
        if (iPhone6Plus) {
            _restTimeLabel.frame=CGRectMake(limitImage.bounds.size.width+limitImage.frame.origin.x+15, 674+102, 200, 20);
        }else
        {
            _restTimeLabel.frame=CGRectMake(190, 526+5+30+12+20, 200, 20);
        }
        _restTimeLabel.text=[self getRestTime:[dict objectForKey:@"end_time"]];
        _endTime=[NSString stringWithString:[dict objectForKey:@"end_time"]];
        _restTimeLabel.font=[UIFont systemFontOfSize:14];
        _restTimeLabel.textColor=[UIColor whiteColor];
        _restTimeLabel.textAlignment=NSTextAlignmentLeft;
        [_restTimeLabel sizeToFit];

        UIView *backColor=[[UIView alloc]initWithFrame:CGRectMake(_restTimeLabel.frame.origin.x-3, _restTimeLabel.frame.origin.y, _restTimeLabel.frame.size.width+6, _restTimeLabel.bounds.size.height)];
        backColor.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [_headerView addSubview:backColor];
        
        UILabel *tian=[[UILabel alloc]initWithFrame:CGRectMake(_restTimeLabel.frame.origin.x+18, _restTimeLabel.frame.origin.y, 16, _restTimeLabel.frame.size.height)];
        tian.text=@"天";
        tian.textColor=[UIColor grayColor];
        tian.font=[UIFont systemFontOfSize:14];
        tian.backgroundColor=[UIColor whiteColor];
        tian.textAlignment=NSTextAlignmentCenter;
        [_headerView addSubview:tian];
        
        UILabel *dian=[[UILabel alloc]initWithFrame:CGRectMake(_restTimeLabel.frame.origin.x+54, _restTimeLabel.frame.origin.y, 12, _restTimeLabel.frame.size.height)];
        dian.text=@":";
        dian.textColor=[UIColor grayColor];
        dian.font=[UIFont systemFontOfSize:14];
        dian.backgroundColor=[UIColor whiteColor];
        dian.textAlignment=NSTextAlignmentCenter;
        [_headerView addSubview:dian];
        
        UILabel *dian1=[[UILabel alloc]initWithFrame:CGRectMake(_restTimeLabel.frame.origin.x+87, _restTimeLabel.frame.origin.y, 12, _restTimeLabel.frame.size.height)];
        dian1.text=@":";
        dian1.textColor=[UIColor grayColor];
        dian1.font=[UIFont systemFontOfSize:14];
        dian1.backgroundColor=[UIColor whiteColor];
        dian1.textAlignment=NSTextAlignmentCenter;
        [_headerView addSubview:dian1];
        
        
        [_headerView addSubview:_restTimeLabel];
        [self createRestTimeTimer];

    }

    
    UIButton *limit=[UIButton buttonWithType:UIButtonTypeCustom];
    if (iPhone6Plus) {
        limit.frame=CGRectMake(0, 240+70+80*2+1+10+3+160+20, self.view.bounds.size.width, 115);
    }else
    {
        limit.frame=CGRectMake(0, 376+131+20, self.view.bounds.size.width, 85);
    }
    [limit addTarget:self action:@selector(limitClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:limit];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 170+60,60, 60)];
    //btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"commentStar.png"] forState:UIControlStateNormal];
    btn.tag = 0;
    btn.layer.cornerRadius = 8;
    [btn setDragEnable:YES];
    [btn setAdsorbEnable:YES];
    [self.view addSubview:btn];
}

-(void)limitClick:(UIButton *)button
{
    NSDictionary *dict=[_limitArray objectAtIndex:0];

    LimitInfoViewController *info=[[LimitInfoViewController alloc]init];
    info.productId=[dict objectForKey:@"object_id"];
    info.suppGoodsId=[dict objectForKey:@"sub_object_id"];
    info.branchType=[dict objectForKey:@"branchType"];
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark ProgressView
-(void)addProgressView:(UIImageView*)imageView andProgressData:(float)data
{
    UIProgressView *progressView=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame=CGRectMake(0, 0, imageView.frame.size.height-20, 20);
    [progressView setProgress:data animated:YES];
    [imageView addSubview:progressView];
}

-(void)removeProgressView:(UIImageView *)imageView
{
    for (UIProgressView *progressView in imageView.subviews) {
        if ([progressView isKindOfClass:[UIProgressView class]]) {
            [progressView removeFromSuperview];
        }
    }
}

-(void)createRestTimeTimer
{
    _restTimeTimer=[NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(restTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_restTimeTimer forMode:NSRunLoopCommonModes];
}

-(void)restTime
{
    _restTimeLabel.text=[self getRestTime:_endTime];
}

#pragma mark 获取限时抢购的剩余时间
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

-(void)limitGetMore
{
    LimitMoreViewController *limit=[[LimitMoreViewController alloc]init];
    [self.navigationController pushViewController:limit animated:YES];
}

-(void)activityDownloadFinish
{
    _activityArray=[[NSMutableArray alloc]initWithCapacity:0];
    _activityArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:ACTIVITY];
    if (_limitArray.count) {
        [self createActivity:_activityArray];
    }
}

//驴悦亲子
-(void)createActivity:(NSArray *)array
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    int count=(int)[[array objectAtIndex:0] count];
    [button sd_setImageWithURL:[NSURL URLWithString:[[[array objectAtIndex:0]objectAtIndex:count-1]objectForKey:@"large_image"]] forState:UIControlStateNormal];
    if (iPhone6Plus) {
        button.frame=CGRectMake(0, 240+70+80*2+1+10, 200, 160);
    }else
    {
        button.frame=CGRectMake(0, 376, 170, 120);
    }
    button.tag=100;
    [button addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:button];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 sd_setImageWithURL:[NSURL URLWithString:[[[array objectAtIndex:0]objectAtIndex:0]objectForKey:@"large_image"]] forState:UIControlStateNormal];
    if (iPhone6Plus) {
        button1.frame=CGRectMake(button.frame.size.width, 240+70+80*2+1+10, self.view.bounds.size.width-button.frame.size.width, 80);
    }else
    {
        button1.frame=CGRectMake(button.frame.size.width, 376, self.view.bounds.size.width-button.frame.size.width, 60);
    }
    button1.tag=101;
    [button1 addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:button1];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 sd_setImageWithURL:[NSURL URLWithString:[[[array objectAtIndex:0]objectAtIndex:1]objectForKey:@"large_image"]] forState:UIControlStateNormal];
    if (iPhone6Plus) {
        button2.frame=CGRectMake(button.frame.size.width, 240+70+80*2+1+10+80, self.view.bounds.size.width-button.frame.size.width, 80);
    }else
    {
        button2.frame=CGRectMake(button.frame.size.width, 376+60, self.view.bounds.size.width-button.frame.size.width, 60);
    }
    button2.tag=102;
    [button2 addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:button2];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    if (iPhone6Plus) {
        line.frame=CGRectMake(button.frame.size.width, 240+70+80*2+1+10+80, self.view.bounds.size.width-button.frame.size.width, 1);
    }else
    {
        line.frame=CGRectMake(button.frame.size.width, 376+60, self.view.bounds.size.width-button.frame.size.width, 1);
    }
    [_headerView addSubview:line];
    
    UIImageView *line2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    if (iPhone6Plus) {
        line2.frame=CGRectMake(0, 240+70+80*2+1+10+160, self.view.bounds.size.width, 1);
    }else
    {
        line2.frame=CGRectMake(0, 376+120, self.view.bounds.size.width, 1);
    }
    [_headerView addSubview:line2];
    
    UIImageView *vertical=[[UIImageView alloc]init];
    if (iPhone6Plus) {
        vertical.frame=CGRectMake(button.frame.size.width, 240+70+80*2+1+10, 1, button.bounds.size.height);
    }else
    {
        vertical.frame=CGRectMake(button.frame.size.width, 376, 1, button.bounds.size.height);
    }
    vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
    vertical.alpha=0.5;
    [_headerView addSubview:vertical];
    UIImageView *vertical1=[[UIImageView alloc]init];
    if (iPhone6Plus) {
        vertical1.frame=CGRectMake(button.frame.size.width, 240+70+80*2+1+10+3, 1, button.bounds.size.height);
    }else
    {
        vertical1.frame=CGRectMake(button.frame.size.width, 374, 1, button.bounds.size.height);
    }
    vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
    vertical1.alpha=0.5;
    [_headerView addSubview:vertical1];
    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, 240+70+80*2+1+10+161, self.view.bounds.size.width, 10);
    }else
    {
        grayArear.frame=CGRectMake(0, 376+121, self.view.bounds.size.width, 10);
    }
    [_headerView addSubview:grayArear];
    
    
    int height;
    if (_isLimit==YES) {
        if (iPhone6Plus) {
            height=674+99+28+25;
        }else
        {
            height=526+5+91+25;
        }
    }else
    {
        if (iPhone6Plus) {
            height=240+70+80*2+1+10+3+161;
        }else
        {
            height=376+131;
        }
    }
    _headHeight = height;
    /*
    NSArray *arr2=[array objectAtIndex:1];

    int countHeight=0;
    for (int i=(int)arr2.count-1; i>=0; i--) {
        NSDictionary *dict=[arr2 objectAtIndex:i];
        UIImageView *view=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            view.frame=CGRectMake(0,height+countHeight*80 ,self.view.bounds.size.width,80);
        }else
        {
            view.frame=CGRectMake(0,height+countHeight*65 ,self.view.bounds.size.width,65);
        }
        [view sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]]];
        view.userInteractionEnabled=YES;
       [_headerView addSubview:view];

        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame=view.frame;
        moreButton.tag=100+i;
        [moreButton addTarget:self action:@selector(hotActivityClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:moreButton];
        countHeight++;
    }
    
    for (int i=1; i<=arr2.count; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, height+i*80, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, height+i*65, self.view.bounds.size.width, 1);
        }
        [_headerView addSubview:line];
    }
     
    UIImageView *grayArear1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    
    if (iPhone6Plus) {
        grayArear1.frame=CGRectMake(0, height+arr2.count*80+1, self.view.bounds.size.width, 10);
    }else
    {
        grayArear1.frame=CGRectMake(0, height+arr2.count*65+1, self.view.bounds.size.width, 10);
    }
    
    [_headerView addSubview:grayArear1];
    
    if (iPhone6Plus) {
        _headHeight=height+arr2.count*80+1+10;
    }else
    {
        _headHeight=height+arr2.count*65+1+10;
    }
    */
    UIView *view=_lvTableView.tableHeaderView;
    view.frame=CGRectMake(0, 0, self.view.bounds.size.width, _headHeight);
    _lvTableView.tableHeaderView=view;
    
}
-(void)hotActivityClick:(UIButton *)button
{
    NSArray *arr2=[_activityArray objectAtIndex:1];
    HomeTopDetailViewController *hot=[[HomeTopDetailViewController alloc]init];
    hot.homeTitle=[[arr2 objectAtIndex:(button.tag-100)]objectForKey:@"title"];
    hot.url=[[arr2 objectAtIndex:(button.tag-100)]objectForKey:@"url"];
    [self.navigationController pushViewController:hot animated:YES];
}
-(void)activityClick:(UIButton *)button
{
    if (button.tag==100) {
        if ([[[[_activityArray objectAtIndex:0]objectAtIndex:([[_activityArray objectAtIndex:0] count]-1)] objectForKey:@"type"]isEqualToString:@"url"]) {
            HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
            top.url=[[[_activityArray objectAtIndex:0]objectAtIndex:([[_activityArray objectAtIndex:0] count]-1)] objectForKey:@"url"];
            top.homeTitle=[[[_activityArray objectAtIndex:0]objectAtIndex:([[_activityArray objectAtIndex:0] count]-1)] objectForKey:@"title"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[[_activityArray objectAtIndex:0]objectAtIndex:([[_activityArray objectAtIndex:0] count]-1)] objectForKey:@"type"]isEqualToString:@"place"])
        {
            HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
            detail.ID=[[[_activityArray objectAtIndex:0]objectAtIndex:([[_activityArray objectAtIndex:0] count]-1)] objectForKey:@"object_id"];
            [self.navigationController pushViewController:detail animated:YES];
        }

        
    }else if (button.tag==101)
    {
        if ([[[[_activityArray objectAtIndex:0]objectAtIndex:0] objectForKey:@"type"]isEqualToString:@"url"]) {
            HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
            top.url=[[[_activityArray objectAtIndex:0]objectAtIndex:0] objectForKey:@"url"];
            top.homeTitle=[[[_activityArray objectAtIndex:0]objectAtIndex:0] objectForKey:@"title"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[[_activityArray objectAtIndex:0]objectAtIndex:0] objectForKey:@"type"]isEqualToString:@"place"])
        {
            HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
            detail.ID=[[[_activityArray objectAtIndex:0]objectAtIndex:0] objectForKey:@"object_id"];
            [self.navigationController pushViewController:detail animated:YES];
        }
    }else
    {
        if ([[[[_activityArray objectAtIndex:0]objectAtIndex:1] objectForKey:@"type"]isEqualToString:@"url"]) {
            HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
            top.url=[[[_activityArray objectAtIndex:0]objectAtIndex:1] objectForKey:@"url"];
            top.homeTitle=[[[_activityArray objectAtIndex:0]objectAtIndex:1] objectForKey:@"title"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[[_activityArray objectAtIndex:0]objectAtIndex:1] objectForKey:@"type"]isEqualToString:@"place"])
        {
            HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
            detail.ID=[[[_activityArray objectAtIndex:0]objectAtIndex:1] objectForKey:@"object_id"];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([[[[_activityArray objectAtIndex:0]objectAtIndex:1] objectForKey:@"type"]isEqualToString:@"pindao"])
        {
            HomePindaoViewController *pindao=[[HomePindaoViewController alloc]init];
            [self.navigationController pushViewController:pindao animated:YES];
        }
    }
}

-(void)buttonDownloadFinish
{
    _buttonArray=[[NSMutableArray alloc]initWithCapacity:0];
    _buttonArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:BUTTONURL];
    NSLog(@"button");
    [self createHeadButton];
    
}
-(void)createHeadButton
{
    NSArray *buttonArr=[_buttonArray objectAtIndex:1];
    int count=0;
    for (int j=0; j<2; j++) {
        for (int i=0; i<2; i++) {
            NSDictionary *dict=[buttonArr objectAtIndex:count];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            if (iPhone6Plus)
            {
                button.frame=CGRectMake(5*(i+1)+i*((self.view.bounds.size.width-15)/2), 155+j*(5+70), ((self.view.bounds.size.width-15)/2), 70);
            }else
            {
                button.frame=CGRectMake(5*(i+1)+i*((self.view.bounds.size.width-15)/2), 125+j*(5+50), ((self.view.bounds.size.width-15)/2), 50);
            }
            [button sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=count+100;
            [_headerView addSubview:button];
            count++;
        }
    }
    count=0;
    NSArray *btnArr=[_buttonArray objectAtIndex:0];

    for (int j=0; j<2; j++) {
        for (int i=0; i<4; i++) {
            if (count<_buttonArray.count) {
                NSDictionary *dict=[btnArr objectAtIndex:count];
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                if (iPhone6Plus) {
                    button.frame=CGRectMake(i*(self.view.bounds.size.width/4), 240+70+j*80, (self.view.bounds.size.width/4), 80);
                }else
                {
                    button.frame=CGRectMake(i*(self.view.bounds.size.width/4), 185+50+j*65, (self.view.bounds.size.width/4), 65);
                }
                
                [button sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag=count+104;
                [_headerView addSubview:button];
                count++;
                if(count==btnArr.count-1)
                {
                    break;
                }
            }

        }
    }
    //button之间的线
    for (int i=0; i<3; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, 240+70+i*80, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, 185+50+i*65, self.view.bounds.size.width, 1);
        }
        [_headerView addSubview:line];

        UIImageView *vertical=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical.frame=CGRectMake((i+1)*self.view.bounds.size.width/4, 240+70, 1, 80*2);
        }else
        {
            vertical.frame=CGRectMake((i+1)*self.view.bounds.size.width/4, 185+50, 1, 65*2);
        }
        vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical.alpha=0.5;
        [_headerView addSubview:vertical];
        UIImageView *vertical1=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical1.frame=CGRectMake((i+1)*self.view.bounds.size.width/4, 240+72, 1, 80*2-2);
        }else
        {
            vertical1.frame=CGRectMake((i+1)*self.view.bounds.size.width/4, 185+52, 1, 65*2);
        }
        vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical1.alpha=0.5;
        [_headerView addSubview:vertical1];
    }
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    [_headerView addSubview:grayArear];
    
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, 240+70+80*2+1, self.view.bounds.size.width, 10);
    }else
    {
        grayArear.frame=CGRectMake(0, 366, self.view.bounds.size.width, 10);
    }
}
//景点门票12个按钮被点击
#pragma mark 景点门票12个按钮被点击
-(void)btnClick:(UIButton *)button
{
    NSInteger tag = button.tag-104>0 ? button.tag-104 : 0;
    [self typeButtonClickWithButtonTag:button.tag andDictionary:[[_buttonArray objectAtIndex:0]objectAtIndex:tag]];
}

//
-(void)typeButtonClickWithButtonTag:(NSInteger)tag andDictionary:(NSDictionary *)dict
{
    if (tag==100) {
        HomeTicketViewController *ticket=[[HomeTicketViewController alloc]init];
        [self.navigationController pushViewController:ticket animated:YES];
    }else if (tag==101)
    {
        HomeNearViewController *near=[[HomeNearViewController alloc]init];
        [self.navigationController pushViewController:near animated:YES];
    }else if (tag==102)
    {
        HomeChinaViewController *domestic=[[HomeChinaViewController alloc]init];
        [self.navigationController pushViewController:domestic animated:YES];
    }else if (tag==103)
    {
        HomeAbroadViewController *abroad=[[HomeAbroadViewController alloc]init];
        [self.navigationController pushViewController:abroad animated:YES];
    }else if ([[dict objectForKey:@"title"]isEqualToString:@"邮轮"])
    {
        HomeShipViewController *ship=[[HomeShipViewController alloc]init];
        [self.navigationController pushViewController:ship animated:YES];
    }else if ([[dict objectForKey:@"title"]isEqualToString:@"酒店"]||[[dict objectForKey:@"title"]isEqualToString:@"签证"])
    {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else if ([[dict objectForKey:@"title"]isEqualToString:@"火车票"])
    {
        HomeTrainViewController *train=[[HomeTrainViewController alloc]init];
        [self.navigationController pushViewController:train animated:YES];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"url"])
    {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        top.url=[dict objectForKey:@"url"];
        top.homeTitle=[dict objectForKey:@"title"];
        [self.navigationController pushViewController:top animated:YES];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"place"])
    {
        HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
        detail.ID=[dict objectForKey:@"object_id"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}


//顶部导航条数据下载完成
-(void)scrollDownloadFinish
{
    _headerArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:SCROLLURL];
    [self createTabLeHeaderView];
}

-(void)createTabLeHeaderView
{
    if (!_scrol) {
        _lvTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]init];
        if (iPhone6Plus) {
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, 150);
        }else
        {
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
        }
        _scrol.pagingEnabled=YES;
        _scrol.bounces=NO;
        _scrol.showsHorizontalScrollIndicator=NO;
        _scrol.showsVerticalScrollIndicator=NO;
        [_headerView addSubview:_scrol];
        _scrol.delegate=self;
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 20)];
        if (iPhone6Plus) {
            _pageControl.frame=CGRectMake(0, 130, self.view.bounds.size.width, 20);
        }else
        {
            _pageControl.frame=CGRectMake(0, 100, self.view.bounds.size.width, 20);
        }
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }

    if (_headerArray.count&&_scrol) {
        _scollCount=(int)_headerArray.count;
        _pageControl.numberOfPages=_scollCount;
        for (int i=0; i<_scollCount; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*(_scollCount+3), 0);
            UIImageView *imageView=[[UIImageView alloc]init];
            if (iPhone6Plus) {
                imageView.frame=CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 150);
            }else
            {
                imageView.frame=CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
            }
            NSDictionary *dict=[_headerArray objectAtIndex:i];
            
            [imageView sd_setImageWithURL:[dict objectForKey:@"large_image"]];

            [_scrol addSubview:imageView];

            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=imageView.frame;
            button.tag=100+i;
            [button addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrol addSubview:button];

        }

        //最后一张图
        UIImageView *imageView1=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            imageView1.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 150);
        }else
        {
            imageView1.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 150);
        }
        NSDictionary *dict1=[_headerArray objectAtIndex:0];
        [imageView1 sd_setImageWithURL:[dict1 objectForKey:@"large_image"]];
        [_scrol addSubview:imageView1];
        //第一张图左边的（最后一张图）
        UIImageView *imageView0=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            imageView0.frame=CGRectMake(0, 0, self.view.bounds.size.width, 150);
        }else
        {
            imageView0.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
        }
        NSDictionary *dict0=[_headerArray objectAtIndex:(_scollCount-1)];
        [imageView0 sd_setImageWithURL:[dict0 objectForKey:@"large_image"]];
        [_scrol addSubview:imageView0];
        [_scrol setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:NO];
        [self performSelector:@selector(createTimer) withObject:nil afterDelay:4.0f];
    }
}

-(void)scrollViewClick:(UIButton *)button
{
    HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
    NSString *url=[((NSDictionary *)[_headerArray objectAtIndex:(button.tag-100)])objectForKey:@"url"];
    top.url=url;
    top.homeTitle=[((NSDictionary *)[_headerArray objectAtIndex:(button.tag-100)])objectForKey:@"title"];
    [self.navigationController pushViewController:top animated:YES];
}

-(void)createTimer
{
    if (!_timer) {
        _timer=[[NSTimer alloc]initWithFireDate:[NSDate date] interval:3.0 target:self selector:@selector(timerScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        _timerCount=0;
    }
}



-(void)timerScroll
{
    if (_timer!=0) {
        _timerCount=_scrol.contentOffset.x/self.view.bounds.size.width;
    }
    _timerCount++;
    [_scrol setContentOffset:CGPointMake((_timerCount)*self.view.bounds.size.width, 0) animated:YES];
    if (_timerCount==(_scollCount+1)) {
        _timerCount=1;
    }
}
//暂停定时器
-(void)timerPause
{
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)timerRestart
{
    [_timer setFireDate:[NSDate date]];
}
-(void)createTableView
{
    if (!_lvTableView) {
        _lvTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-44-46) style:UITableViewStylePlain];
        _lvTableView.delegate=self;
        _lvTableView.dataSource=self;
        _lvTableView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.view addSubview:_lvTableView];
        [self createTabLeHeaderView];
        _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_lvTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    }
}
//自定义导航条
-(void)createNavigation
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:navView];

    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 30, 36)];
    address.text=@"北京";
    address.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    address.font=[UIFont boldSystemFontOfSize:14];
    address.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:address];
    
    UIImageView *arrowDown=[[UIImageView alloc]initWithFrame:CGRectMake(address.bounds.size.width+address.frame.origin.x+2, 36, 8, 5)];
    arrowDown.image=[UIImage imageNamed:@"arrowDownRed.png"];
    [navView addSubview:arrowDown];
    
    UIButton *code=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 20, 36, 36)];
    [code setImage:[UIImage imageNamed:@"codeBtn.png"] forState:UIControlStateNormal];
    [code addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:code];
    
    _search=[[UISearchBar alloc]initWithFrame:CGRectMake(55, 23, [UIScreen mainScreen].bounds.size.width-95, 30)];
    [navView addSubview:_search];
    _search.placeholder=@"目的地/景点/酒店/邮轮/签证";
    _search.barStyle=UIBarStyleDefault;
    
    UIOffset offset=UIOffsetMake(-10, 0);
    //search.searchTextPositionAdjustment=offset;
    _search.delegate=self;
    _search.searchFieldBackgroundPositionAdjustment=offset;
    [[[[_search.subviews objectAtIndex:0]subviews] objectAtIndex:0] removeFromSuperview];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line.frame=CGRectMake(0, 63, self.view.bounds.size.width, 1);
    line.alpha=0.5;
    [self.view addSubview:line];

}

-(void)createSearchTableView
{
    if (!_searchTableview) {
        _searchTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-44-46) style:UITableViewStylePlain];
        _searchTableview.delegate=self;
        _searchTableview.dataSource=self;
        _searchTableview.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _searchTableview.alpha=0;
        _searchTableview.sectionHeaderHeight=0;
        [self.view insertSubview:_searchTableview belowSubview:_lvTableView];
        [self createSearchHeaderView:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotWordDownloadFinish) name:HOT_WORD_SEARCH object:nil];
        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:HOT_WORD_SEARCH and:0];
        UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        foot.backgroundColor=[UIColor clearColor];
        _searchTableview.tableFooterView=foot;
    }
}
-(void)hotWordDownloadFinish
{
    NSArray *searchArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:HOT_WORD_SEARCH];
    [self createSearchHeaderView:searchArray];
}
-(void)createSearchHeaderView:(NSArray *)array
{
    if (!_searchTableview.tableHeaderView) {
        UIView *searchHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
        searchHeaderView.backgroundColor=[UIColor whiteColor];
        _searchTableview.tableHeaderView=searchHeaderView;
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        grayArear.frame=CGRectMake(0, 0, self.view.bounds.size.width, 30);
        [searchHeaderView addSubview:grayArear];
        
        UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, grayArear.bounds.size.height)];
        hot.text=@"热门搜索：";
        hot.font=[UIFont systemFontOfSize:12];
        hot.textColor=[UIColor grayColor];
        [grayArear addSubview:hot];
    }
    if (array&&_searchTableview.tableHeaderView) {
        UIView *head=_searchTableview.tableHeaderView;
        NSDictionary *dict=[array objectAtIndex:0];
        NSArray *words=[[dict objectForKey:@"keyword"] componentsSeparatedByString:@","];
        int count=0;
        for (int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                UILabel *word=[[UILabel alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/3, 30+30*j, [UIScreen mainScreen].bounds.size.width/3, 30)];
                word.font=[UIFont systemFontOfSize:13];
                word.text=[words objectAtIndex:count];
                word.textAlignment=NSTextAlignmentCenter;
                [head addSubview:word];
                count++;
                
                UIButton *wordButton=[UIButton buttonWithType:UIButtonTypeCustom];
                wordButton.frame=word.bounds;
                [word addSubview:wordButton];
                [wordButton addTarget:self action:@selector(hotWordClick:) forControlEvents:UIControlEventTouchUpInside];
                [word addSubview:wordButton];
            }
        }
        for (int i=0; i<4; i++) {
            UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            line.frame=CGRectMake(0, 30+30*i, self.view.bounds.size.width, 1);
            line.alpha=0.5;
            [head addSubview:line];
            if (i<2) {
                UIImageView *vertical=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3*(i+1), 30, 1, 90)];
                vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
                vertical.alpha=0.5;
                [head addSubview:vertical];
                UIImageView *vertical1=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3*(i+1), 31, 1, 89)];
                vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
                vertical1.alpha=0.5;
                [head addSubview:vertical1];
            }
        }

    }
}

-(void)hotWordClick:(UIButton *)button
{
    
}

-(void)userWordDownloadFinish
{
    
}

#pragma mark searchbar delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:searchText,@"word",nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userWordDownloadFinish) name:USER_SEARCH_WORD object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithPostUrl:USER_SEARCH_WORD and:0 and:dict];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self createSearchTableView];
    if (_searchTableview) {
        [_searchTableview removeFromSuperview];
        [self.view insertSubview:_searchTableview aboveSubview:_lvTableView];
    }
    [UIView animateWithDuration:0.1 animations:^{
        _search.frame=CGRectMake(5, 23, [UIScreen mainScreen].bounds.size.width, 30);
        _search.showsCancelButton=YES;
        UIButton *cancelButton;
        UIView *topView = _search.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                cancelButton = (UIButton*)subView;
            }
        }
        if (cancelButton) {
            //Set the new title of the cancel button
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14];
        }
        for (UIButton *button in searchBar.superview.subviews) {
            if ([button isKindOfClass:[UIButton class]])
            {
                button.alpha=0;
                _lvTableView.alpha=0;
                _searchTableview.alpha=1;
            }
        }
    }];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if (_searchTableview) {
        [_searchTableview removeFromSuperview];
        [self.view insertSubview:_searchTableview belowSubview:_lvTableView];
    }
    [UIView animateWithDuration:0.1 animations:^{
        _search.frame=CGRectMake(55, 23, [UIScreen mainScreen].bounds.size.width-95, 30);
        _search.showsCancelButton=NO;
        for (UIButton *button in searchBar.superview.subviews) {
            if ([button isKindOfClass:[UIButton class]])
            {
                button.alpha=1;
                _lvTableView.alpha=1;
                _searchTableview.alpha=0;
            }
        }
    }];

    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_scrol) {
        int count=scrollView.contentOffset.x/self.view.bounds.size.width;
        if (count==0) {
            if (scrollView.decelerating==YES) {
                _pageControl.currentPage=_scollCount;
                [scrollView setContentOffset:CGPointMake(_scollCount*self.view.bounds.size.width, 0) animated:NO];
            }
        }else if (count==(_scollCount+1))
        {
            _pageControl.currentPage=0;
            [scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:NO];
        }else
        {
            _pageControl.currentPage=count-1;
        }
    }else
    {
        [_storeHouseRefreshControl scrollViewDidScroll];
        NSInteger tag=[self weekOrVacation:[self tableView:_lvTableView viewForHeaderInSection:0]];
        if (_isChange==NO) {
            if (tag==100) {
                _weekInSets=_lvTableView.contentOffset;
            }
            if (tag==101) {
                _vacationInSets=_lvTableView.contentOffset;
            }
        }else
        {
            if (tag==100) {
                _weekInSets=_lvTableView.contentOffset;
            }
            if (tag==101) {
                _vacationInSets=_lvTableView.contentOffset;
            }
        }
        if (-_lvTableView.bounds.size.height+_lvTableView.contentSize.height-40<scrollView.contentOffset.y) {
            if (_page==_countPage) {
                NSInteger tag=[self weekOrVacation:[self tableView:_lvTableView viewForHeaderInSection:0]];
                if ((tag==100&&_isWeekAllShow==NO)||(tag==101&&_isVacationAllShow==NO)) {
                    _page++;
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoDownLoadFinish) name:[NSString stringWithFormat:INFOURL,_page] object:nil];
                    
                    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:INFOURL,_page] and:9];
                }

            }
        }
    }

}





//导航条二维码扫描
-(void)scan:(UIButton *)button
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    //style.colorAngle = ;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    
    [self openScanVCWithStyle:style];
    
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    [self.navigationController pushViewController:vc animated:YES];
}

#define mark tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lvTableView==tableView) {
        if (_dataArray.count!=0) {
            NSDictionary *dic=[_heightArray  objectAtIndex:indexPath.row];
            NSString *string=[dic objectForKey:@"content"];
            CGSize size=CGSizeMake(self.view.bounds.size.width-30, 1000);
            UIFont *font;
            if (iPhone6Plus) {
                font=[UIFont systemFontOfSize:12];
            }else
            {
                font=[UIFont systemFontOfSize:10];
            }
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing=1;
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            if (iPhone6Plus) {
                return  HomeCellHeight+30+actualSize.height+5+10;
            }else
            {
                return  170+actualSize.height+15;
            }
        }else
        {
            return 200;
        }
    }
    else if (tableView==_searchTableview)
    {
        return 100;
    }else
    {
        return 100;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_lvTableView) {
        if (_dataArray.count!=0) {
            UIView *view=[self tableView:tableView viewForHeaderInSection:section];
            NSInteger tag= [self weekOrVacation:view];
            return [[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] count];
        }else
        {
            return 0;
        }
    }else if (tableView==_searchTableview)
    {
        return 0;
    }else
    {
        return 0;
    }
}
-(NSInteger)weekOrVacation:(UIView *)view
{
    NSInteger tag=0;
    if (view.bounds.size.height==40) {
        for (UILabel *label in view.subviews) {
            for (UIButton *button in label.subviews) {
                if (button.selected==YES) {
                    tag=button.tag;
                }
            }
        }
    }
    return tag;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_lvTableView) {
    static NSString *cellName=@"cellTable";
    LVHomeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[LVHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.Lvpic=@"";
    cell.Lvtitle=@"";
    cell.LvDetail=@"";
    UIView *view=[self tableView:tableView viewForHeaderInSection:indexPath.section];
    NSInteger tag= [self weekOrVacation:view];
    
    cell.Lvpic=[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"large_image"];
    cell.Lvtitle=[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"]objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.LvDetail=[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"]objectAtIndex:indexPath.row]objectForKey:@"content"];
        
    return cell;
        
    }else if (tableView==_searchTableview)
    {
        static NSString *cellName=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        return cell;
    }else{
        static NSString *cellName=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_lvTableView) {
        return 1;
    }else if (tableView==_searchTableview)
    {
        return 1;
    }else
        return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_lvTableView) {
        if (_headView.bounds.size.height!=40) {
            _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,40)];
            _headView.userInteractionEnabled=YES;
            _headView.backgroundColor=[UIColor whiteColor];
            UIButton *weekond=[UIButton buttonWithType:UIButtonTypeCustom];
            weekond.frame=CGRectMake(0, 0, self.view.bounds.size.width/2, _headView.bounds.size.height);
            [weekond addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
            weekond.tag=100;
            
            UILabel *weekLabel=[[UILabel alloc]initWithFrame:weekond.frame];
            weekLabel.text=@"度周末";
            weekLabel.userInteractionEnabled=YES;
            [_headView addSubview:weekLabel];
            weekLabel.textColor=[UIColor grayColor];
            weekLabel.textAlignment=NSTextAlignmentCenter;
            weekLabel.font=[UIFont systemFontOfSize:12];
            [weekLabel addSubview:weekond];
            
            UIButton *vacation=[UIButton buttonWithType:UIButtonTypeCustom];
            vacation.frame=CGRectMake(0, 0, self.view.bounds.size.width/2,_headView.bounds.size.height);
            [vacation addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
            vacation.tag=101;
            
            UILabel *vacaLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, _headView.bounds.size.height)];
            vacaLabel.text=@"度长假";
            vacaLabel.userInteractionEnabled=YES;
            [_headView addSubview:vacaLabel];
            vacaLabel.textColor=[UIColor grayColor];
            vacaLabel.textAlignment=NSTextAlignmentCenter;
            vacaLabel.font=[UIFont systemFontOfSize:12];
            [vacaLabel addSubview:vacation];
            
            weekond.selected=YES;
            weekLabel.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
            
            UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabLeftSel.png"]];
            line.frame=CGRectMake(self.view.bounds.size.width/4-18, _headView.bounds.size.height-5, 36, 3);
            [_headView addSubview:line];
        }
        return _headView;
    }else
        return Nil;
}

-(void)sectionClick:(UIButton *)button
{
    for (UILabel *label in button.superview.superview.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor grayColor];
            for (UIButton *btn in label.subviews) {
                if (btn.selected==YES) {
                    if (btn.tag!=button.tag) {
                        _isChange=YES;
                        
                    }else
                        _isChange=NO;
                }
                btn.selected=NO;
            }
        }
        if ([label isKindOfClass:[UIImageView class]]) {
            UIImageView *pic=(UIImageView *)label;
            if (button.tag==100) {
                [UIView animateWithDuration:0.1f animations:^{
                    pic.frame=CGRectMake(self.view.bounds.size.width/4-18, _headView.bounds.size.height-5, 36, 3);
                }];
            }else
            {
                [UIView animateWithDuration:0.1f animations:^{
                    pic.frame=CGRectMake(self.view.bounds.size.width/4*3-18, _headView.bounds.size.height-5, 36, 3);
                }];
            }
        }
    }
    if (button.tag==100) {
        if (_lvTableView.contentOffset.y
            >_scrollHeight) {
            _lvTableView.contentOffset=_weekInSets;
        }
    }else
    {
        if (_lvTableView.contentOffset.y>_scrollHeight) {
            _lvTableView.contentOffset=_vacationInSets;
        }
    }
        
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:INFOURL,_page] and:9];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_lvTableView==tableView)
    return 40;
    else return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lvTableView==tableView) {
        UIView *view=[self tableView:tableView viewForHeaderInSection:indexPath.section];
        NSInteger tag= [self weekOrVacation:view];
        if ([[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"place"]) {
            HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
            detail.ID=[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"object_id"];
            detail.homeTitle=[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"title"];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"url"])
        {
            HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
            top.url=[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"url"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[[[_dataArray objectAtIndex:(tag-100)] objectForKey:@"infos"] objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"keyword"])
        {
            [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    }else if (tableView==_searchTableview)
    {
        
    }

}

#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    _page=1;
    _countPage=1;
    _isVacationAllShow=NO;
    _isWeekAllShow=NO;
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:INFOURL,_page] and:9];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==_lvTableView) {
        [_storeHouseRefreshControl scrollViewDidEndDragging];
    }else if (scrollView==_scrol)
    {
        if (decelerate==YES) {
            [self performSelector:@selector(createTimer) withObject:nil afterDelay:3.0];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView==_scrol) {
        if (_timer) {
            [_timer invalidate];
            _timer=nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
