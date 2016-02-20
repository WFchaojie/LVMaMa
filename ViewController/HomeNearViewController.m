//
//  HomeNearViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-6.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeNearViewController.h"
#import "LVHomeCell.h"
#import "HomeTopDetailViewController.h"
#import "HomeDetailViewController.h"
#import "HomeSpecialDetailViewController.h"
@interface HomeNearViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *lvTableView;
@property (nonatomic,strong) UITableView *searchTableview;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *hotWordArray;
@property (nonatomic,strong) NSMutableArray *activityArray;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrol;
@property (nonatomic,strong) UIView *headerView;
//顶部scrollview上面滚动广告的个数
@property (nonatomic,assign) int scollCount;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int timerCount;
@property (nonatomic,strong) NSMutableArray *headArray;
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,strong) CBHomeRefreshControl *storeHouseRefreshControl;
@property (nonatomic,assign) int page;
 //用来判断防止page一直++
@property (nonatomic,assign) int countPage;
@property (nonatomic,assign) BOOL isLastPage;
@property (nonatomic,assign) int origin;


@end

@implementation HomeNearViewController


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
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
    if (!_lvTableView) {
        [self createTableView];
        [self createNavigation];
        [self createSearchTableView];
        [self hudShow];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    _origin=0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topDownloadFinish) name:NEAR_BANNER object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:NEAR_BANNER and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotWordDownloadFinish) name:NEAR_RECOMMEND object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:NEAR_RECOMMEND and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityDownloadFinish) name:NEAR_ACTIVITY object:nil];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page] and:15];
    NSLog(@"==%@",[NSString stringWithFormat:NEAR_BUTTON_INFO,_page]);
    _hotWordArray=[[NSMutableArray alloc]initWithCapacity:0];
    _activityArray=[[NSMutableArray alloc]initWithCapacity:0];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
	// Do any additional setup after loading the view.
}
-(void)createNavigation
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:navView];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 30, 36)];
    address.text=@"北京";
    address.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    address.font=[UIFont boldSystemFontOfSize:14];
    address.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:address];
    
    UIImageView *arrowDown=[[UIImageView alloc]initWithFrame:CGRectMake(address.bounds.size.width+address.frame.origin.x+2, 36, 8, 5)];
    arrowDown.image=[UIImage imageNamed:@"arrowDownRed.png"];
    [navView addSubview:arrowDown];
    
    UIButton *code=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 36, 36)];
    [code setImage:[UIImage imageNamed:@"filtrateBack.png"] forState:UIControlStateNormal];
    [code addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:code];
    
    _search=[[UISearchBar alloc]initWithFrame:CGRectMake(40, 23, [UIScreen mainScreen].bounds.size.width-70, 30)];
    [navView addSubview:_search];
    _search.placeholder=@"输入目的地/关键字/主题";
    _search.barStyle=UIBarStyleDefault;
    UIOffset offset=UIOffsetMake(-18, 0);
    _search.searchTextPositionAdjustment=offset;
    _search.delegate=self;
    _search.searchFieldBackgroundPositionAdjustment=offset;
    [[[[_search.subviews objectAtIndex:0]subviews] objectAtIndex:0] removeFromSuperview];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line.frame=CGRectMake(0, 63, self.view.bounds.size.width, 1);
    line.alpha=0.5;
    [self.view addSubview:line];
    
}
#pragma mark searchbar delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:searchText,@"word",nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userWordDownloadFinish) name:USER_SEARCH_WORD object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithPostUrl:USER_SEARCH_WORD and:0 and:dict];
}
-(void)userWordDownloadFinish
{
    
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self createSearchTableView];
    UIOffset offset=UIOffsetMake(0, 0);
    _search.searchFieldBackgroundPositionAdjustment=offset;
    _search.searchTextPositionAdjustment=offset;
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
            if ([button isKindOfClass:[UIImageView class]]||[button isKindOfClass:[UILabel class]])
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
    UIOffset offset=UIOffsetMake(-18, 0);
    _search.searchFieldBackgroundPositionAdjustment=offset;
    _search.searchTextPositionAdjustment=offset;
    if (_searchTableview) {
        [_searchTableview removeFromSuperview];
        [self.view insertSubview:_searchTableview belowSubview:_lvTableView];
    }
    [UIView animateWithDuration:0.1 animations:^{
        _search.frame=CGRectMake(40, 23, [UIScreen mainScreen].bounds.size.width-70, 30);
        _search.showsCancelButton=NO;
        for (UIButton *button in searchBar.superview.subviews) {
            if ([button isKindOfClass:[UIImageView class]]||[button isKindOfClass:[UILabel class]])
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
        UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        foot.backgroundColor=[UIColor clearColor];
        _searchTableview.tableFooterView=foot;
    }
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)recommendDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page]]];
    }

    _isLastPage=[[_dataArray lastObject] boolValue];
    [_dataArray removeObject:[_dataArray lastObject]];
    if (_lvTableView.tableFooterView) {
        UIView *footView=_lvTableView.tableFooterView;
        for (UIView *foot in footView.subviews) {
            [foot removeFromSuperview];
        }
        [footView removeFromSuperview];
    }
    if (_isLastPage==YES) {
        UIView *footView;
        if (_lvTableView.tableFooterView) {
            footView=_lvTableView.tableFooterView;
        }
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _lvTableView.tableFooterView=footView;
        UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
        label.textColor=[UIColor grayColor];
        label.text=@"已经全部加载";
        label.font=[UIFont systemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        [footView addSubview:label];
    }

    
    [self hudHide];
    _lvTableView.alpha=1;
    [_lvTableView reloadData];
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}
-(void)activityDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:NEAR_ACTIVITY];
    _activityArray=(NSMutableArray *)array;
    [self createActivity:_activityArray];
}

-(void)createActivity:(NSArray *)array
{
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict=[array objectAtIndex:i];
        UIImageView *activity=[[UIImageView alloc]init];
        
        [activity sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]] placeholderImage:nil];
        [_headerView addSubview:activity];
        
        if (iPhone6Plus) {
            activity.frame=CGRectMake(0, _origin+i*83, self.view.bounds.size.width, 83);
        }else
        {
            activity.frame=CGRectMake(0, _origin+i*63, self.view.bounds.size.width, 63);
        }
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=activity.frame;
        [button addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100+i;
        [_headerView addSubview:button];
    }
    for (int i=0; i<=array.count; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, _origin+i*83, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, _origin+i*63, self.view.bounds.size.width, 1);
        }
        [_headerView addSubview:line];
    }
    
    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, _origin+1+array.count*83, self.view.bounds.size.width, 10);
    }else
    {
        grayArear.frame=CGRectMake(0, _origin+1+array.count*63, self.view.bounds.size.width, 10);
    }
    [_headerView addSubview:grayArear];
    
    if (_lvTableView.tableHeaderView) {
        _headerView=_lvTableView.tableHeaderView;
        if (iPhone6Plus) {
            _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, _origin+1+array.count*83+10);
        }else
        {
            _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, _origin+1+array.count*63+10);
        }
        _lvTableView.tableHeaderView=_headerView;
    }
    
}

-(void)activityClick:(UIButton *)button
{
    NSDictionary *dict=[_activityArray objectAtIndex:button.tag-100];
    if ([[dict objectForKey:@"type"]isEqualToString:@"url"]) {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        top.homeTitle=[dict objectForKey:@"title"];
        top.url=[dict objectForKey:@"url"];
        [self.navigationController pushViewController:top animated:YES];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"keyword"])
    {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

-(void)hotWordDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:NEAR_RECOMMEND];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:NEAR_ACTIVITY and:0];
    _hotWordArray=(NSMutableArray *)array;
    [self createHotWord:array];
}
#pragma mark hotWord
//热词
-(void)createHotWord:(NSArray *)array
{
    int count=0;
    if (array.count) {
        UIImageView *gray=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        gray.frame=CGRectMake(0, 120, self.view.bounds.size.width, 30);
        [_headerView addSubview:gray];
        
        UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, gray.bounds.size.height)];
        hot.text=@"周边热门推荐";
        hot.font=[UIFont systemFontOfSize:12];
        [gray addSubview:hot];
        hot.textColor=[UIColor grayColor];
        
        NSDictionary *dict=[array objectAtIndex:0];
        NSString *words=[dict objectForKey:@"keyword"];
        NSArray *hotWord=[words componentsSeparatedByString:@","];
        for (int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width/3, 150+j*35, self.view.bounds.size.width/3, 35)];
                hot.text=[hotWord objectAtIndex:count];
                hot.font=[UIFont systemFontOfSize:12];
                [_headerView addSubview:hot];
                hot.textAlignment=NSTextAlignmentCenter;
                count++;
                
                UIButton *hotWord=[UIButton buttonWithType:UIButtonTypeCustom];
                hotWord.frame=hot.frame;
                [hotWord addTarget:self action:@selector(hotWordClick:) forControlEvents:UIControlEventTouchUpInside];
                hotWord.tag=100+i;
                [_headerView addSubview:hotWord];
            }
        }
        for (int i=0; i<4; i++) {
            UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            line.frame=CGRectMake(0, 150+i*35, self.view.bounds.size.width, 1);
            [_headerView addSubview:line];
        }
        for (int i=0; i<2; i++) {
            UIImageView *vertical=[[UIImageView alloc]initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width/3, 150, 1,105)];
            vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
            vertical.alpha=0.5;
            [_headerView addSubview:vertical];
            UIImageView *vertical1=[[UIImageView alloc]initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width/3, 149, 1,105)];
            vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
            vertical1.alpha=0.5;
            [_headerView addSubview:vertical1];
        }
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        grayArear.frame=CGRectMake(0, 256, self.view.bounds.size.width, 10);
        [_headerView addSubview:grayArear];
        _origin=grayArear.frame.origin.y+grayArear.frame.size.height;
        
    }else
    {
        if (iPhone6Plus) {
            _origin=150;
        }else
        {
            _origin=120;
        }
    }
    
}

-(void)hotWordClick:(UIButton *)button
{
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}
-(void)createTableView
{
    if (!_lvTableView) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _lvTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _lvTableView.delegate=self;
        _lvTableView.dataSource=self;
        _lvTableView.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        [self.view addSubview:_lvTableView];
        _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_lvTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
        [self createTicketTop:nil];
        _lvTableView.alpha=0;
    }
}

-(void)createTicketTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
        _headerView.backgroundColor=[UIColor whiteColor];
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
        _pageControl=[[UIPageControl alloc]init];
        if (iPhone6Plus) {
            _pageControl.frame=CGRectMake(0, 130, self.view.bounds.size.width, 20);
        }else
        {
            _pageControl.frame=CGRectMake(0, 100, self.view.bounds.size.width, 20);
        }
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        _pageControl.numberOfPages=_scollCount;
        [_headerView addSubview:_pageControl];
    }
    
    if (array.count&&_scrol) {
        _scollCount=(int)array.count;
        for (int i=0; i<_scollCount; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*(_scollCount+2), 0);
            UIImageView *imageView=[[UIImageView alloc]init];
            if (iPhone6Plus) {
                imageView.frame=CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 150);
            }else
            {
                imageView.frame=CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
            }
            NSDictionary *dict=[array objectAtIndex:i];
            
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
            imageView1.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
        }
        NSDictionary *dict1=[array objectAtIndex:0];
        [imageView1 sd_setImageWithURL:[dict1 objectForKey:@"large_image"]];
        [_scrol addSubview:imageView1];
        _scrol.contentOffset=CGPointMake(self.view.bounds.size.width, 0);
        //第一张图左边的（最后一张图）
        UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
        if (iPhone6Plus) {
            imageView0.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 150);
        }else
        {
            imageView0.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
        }
        NSDictionary *dict0=[array objectAtIndex:(_scollCount-1)];
        
        [imageView0 sd_setImageWithURL:[dict0 objectForKey:@"large_image"]];
        [_scrol addSubview:imageView0];

        [self createTimer];
    }
}

//景点被点击
-(void)btnClick:(UIButton *)btn
{
    
}

-(void)createTimer
{
    _timer=[[NSTimer alloc]initWithFireDate:[NSDate date] interval:2.5 target:self selector:@selector(timerScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    _timerCount=0;
    
}

-(void)timerScroll
{
    if (!_timerCount==0) {
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
    }if (scrollView==_lvTableView) {
        [_storeHouseRefreshControl scrollViewDidScroll];
        if (-_lvTableView.bounds.size.height+_lvTableView.contentSize.height<scrollView.contentOffset.y&&_isLastPage==NO) {
            if (_page==_countPage) {
                UIView *footView;
                if (_lvTableView.tableFooterView) {
                    footView=_lvTableView.tableFooterView;
                }
                footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
                footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
                _lvTableView.tableFooterView=footView;
                UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
                label.textColor=[UIColor grayColor];
                label.text=@"加载中";
                label.font=[UIFont systemFontOfSize:12];
                label.textAlignment=NSTextAlignmentCenter;
                [footView addSubview:label];
                UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
                [footView addSubview:activity];
                activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
                [activity startAnimating];
                _page++;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page] and:15];
           }
        }
    }
}

-(void)topDownloadFinish
{
    _headArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:NEAR_BANNER];
    _headArray=(NSMutableArray *)array;
    [self createTicketTop:array];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    LVHomeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[LVHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.Lvpic=@"";
    cell.Lvtitle=@"";
    cell.LvDetail=@"";

    cell.Lvpic=[[_dataArray  objectAtIndex:indexPath.row]objectForKey:@"large_image"];
    cell.Lvtitle=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.LvDetail=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"content"];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count!=0) {
        NSDictionary *dic=[_dataArray objectAtIndex:indexPath.row];
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
            return  150+actualSize.height+15;
        }
        
    }else
    {
        return 200;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count!=0) {

        return [_dataArray  count];
    }else
    {
        return 0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lvTableView==tableView) {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"place"]) {
            HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
            detail.ID=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"object_id"];
            detail.homeTitle=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"url"])
        {
            HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
            top.url=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"url"];
            top.homeTitle=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"keyword"])
        {
            [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }
    }
}

-(void)scrollViewClick:(UIButton *)button
{
    HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
    NSString *url=[((NSDictionary *)[_headArray objectAtIndex:(button.tag-100)])objectForKey:@"url"];
    top.url=url;
    top.homeTitle=[((NSDictionary *)[_headArray objectAtIndex:(button.tag-100)])objectForKey:@"title"];
    [self.navigationController pushViewController:top animated:YES];
}

#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_BUTTON_INFO,_page] and:15];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_storeHouseRefreshControl scrollViewDidEndDragging];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
