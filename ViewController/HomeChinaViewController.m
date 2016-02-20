//
//  HomeChinaViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/8/7.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeChinaViewController.h"
#import "HomeTopDetailViewController.h"
#import "LVHomeCell.h"
#import "HomeSpecialDetailViewController.h"
#import "HomeDetailViewController.h"

@interface HomeChinaViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong) UITableView *LVTableView;
@property(nonatomic,strong) UITableView *searchTableview;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *activityArray;
@property(nonatomic,strong) NSMutableArray *specialArray;
@property(nonatomic,strong) NSMutableArray *hotActivityArray;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) UIScrollView *scrol;
@property(nonatomic,strong) UIView *headerView;
//顶部scrollview上面滚动广告的个数
@property(nonatomic,assign) int scollCount;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) int timerCount;
@property(nonatomic,strong) NSMutableArray *headArray;
//热词搜索
@property(nonatomic,strong) NSMutableArray *hotArray;
//热词
@property(nonatomic,strong) UIView *hotView;
@property(nonatomic,strong) UISearchBar *search;
@property(nonatomic,strong) CBHomeRefreshControl *storeHouseRefreshControl;
@property(nonatomic,assign) int page;
//用来判断防止page一直++
@property(nonatomic,assign) int countPage;
@property(nonatomic,assign) BOOL isLastPage;

@end

@implementation HomeChinaViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
    if (_timer.valid==NO&&_headArray.count&&_scrol) {
        [self createTimer];
    }
    if (!_LVTableView) {
        [self createNavigation];
        [self createTableView];
        [self createSearchTableView];
        [self hudShow];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    _isLastPage=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topBannerDownloadFinish) name:DOMESTIC_BANNER object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:DOMESTIC_BANNER and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotActivityDownloadFinish) name:DOMESTIC_HOTACTIVITY object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:DOMESTIC_HOTACTIVITY and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityDownloadFinish) name:DOMESTIC_SPECIALACTIVITY object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:DOMESTIC_SPECIALACTIVITY and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:[NSString stringWithFormat:DOMESTIC_CELL,_page] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:DOMESTIC_CELL,_page] and:15];
    NSLog(@"%@",[NSString stringWithFormat:DOMESTIC_CELL,_page]);

    _specialArray=[[NSMutableArray alloc]initWithCapacity:0];
    _activityArray=[[NSMutableArray alloc]initWithCapacity:0];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    // Do any additional setup after loading the view.
}

-(void)activityDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:DOMESTIC_SPECIALACTIVITY];
    _specialArray=(NSMutableArray *)array;
    [self createSpecial:array];
}

-(void)recommendDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:DOMESTIC_CELL,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:DOMESTIC_CELL,_page]]];
    }
    
    _isLastPage=[[_dataArray lastObject] boolValue];
    [_dataArray removeObject:[_dataArray lastObject]];
    
    if (_LVTableView.tableFooterView) {
        UIView *footView=_LVTableView.tableFooterView;
        for (UIView *foot in footView.subviews) {
            [foot removeFromSuperview];
        }
        [footView removeFromSuperview];
    }
    
    if (_isLastPage==YES) {
        UIView *footView;
        if (_LVTableView.tableFooterView) {
            footView=_LVTableView.tableFooterView;
        }
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _LVTableView.tableFooterView=footView;
        UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
        label.textColor=[UIColor grayColor];
        label.text=@"已经全部加载";
        label.font=[UIFont systemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        [footView addSubview:label];
    }
    

    
    
    
    
    [self hudHide];
    _LVTableView.alpha=1;
    [_LVTableView reloadData];
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
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
        [self.view insertSubview:_searchTableview aboveSubview:_LVTableView];
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
                _LVTableView.alpha=0;
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
        [self.view insertSubview:_searchTableview belowSubview:_LVTableView];
    }
    [UIView animateWithDuration:0.1 animations:^{
        _search.frame=CGRectMake(40, 23, [UIScreen mainScreen].bounds.size.width-70, 30);
        _search.showsCancelButton=NO;
        for (UIButton *button in searchBar.superview.subviews) {
            if ([button isKindOfClass:[UIImageView class]]||[button isKindOfClass:[UILabel class]])
            {
                button.alpha=1;
                _LVTableView.alpha=1;
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
        [self.view insertSubview:_searchTableview belowSubview:_LVTableView];
        UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        foot.backgroundColor=[UIColor clearColor];
        _searchTableview.tableFooterView=foot;
    }
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hotActivityDownloadFinish
{
    _hotActivityArray=[[NSMutableArray alloc]initWithCapacity:0];
    _hotActivityArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:DOMESTIC_HOTACTIVITY];
    [self createHotActivity:_hotActivityArray];
}

-(void)createHotActivity:(NSArray *)array
{
    for (int i=0; i<2; i++) {
        UIImageView *address=[[UIImageView alloc]init];

        if (iPhone6Plus) {
            address.frame=CGRectMake(i*self.view.bounds.size.width/2, _scrol.bounds.size.height+10, self.view.bounds.size.width/2, 100);
        }else
        {
            address.frame=CGRectMake(i*self.view.bounds.size.width/2, _scrol.bounds.size.height+10, self.view.bounds.size.width/2, 80);
        }
        
        [_headerView addSubview:address];
        
        UIImageView *vertical=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical.frame=CGRectMake(self.view.frame.size.width/2, _scrol.bounds.size.height+10, 1, 100);
        }else
        {
            vertical.frame=CGRectMake(self.view.frame.size.width/2, _scrol.bounds.size.height+10, 1, 80);
        }
        vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical.alpha=0.5;
        [_headerView addSubview:vertical];
        
        UIImageView *vertical1=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical1.frame=CGRectMake(self.view.frame.size.width/2, _scrol.bounds.size.height+10-1, 1, 100);
        }else
        {
            vertical1.frame=CGRectMake(self.view.frame.size.width/2, _scrol.bounds.size.height+10-1, 1, 80);
        }
        vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical1.alpha=0.5;
        [_headerView addSubview:vertical1];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if (iPhone6Plus) {
            btn.frame=CGRectMake(i*(self.view.bounds.size.width/2), _scrol.bounds.size.height+10+2, self.view.bounds.size.width/2, 100);
        }else
        {
            btn.frame=CGRectMake(i*(self.view.bounds.size.width/2), _scrol.bounds.size.height+10+2, self.view.bounds.size.width/2, 80);
        }
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
        if (i>=array.count) {
            [address sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
            btn.enabled=NO;
        }else
        {
            [address sd_setImageWithURL:[NSURL URLWithString:[[array objectAtIndex:i] objectForKey:@"large_image"]]];
        }
    }
    
    if (iPhone6Plus) {
        [self createLines:CGRectMake(0, _scrol.bounds.size.height+10+100, self.view.bounds.size.width, 1)];
        [self createArears:CGRectMake(0, _scrol.bounds.size.height+10+101, self.view.bounds.size.width, 10)];
        [self createLines:CGRectMake(0, _scrol.bounds.size.height+10-1, self.view.bounds.size.width, 1)];
    }else
    {
        [self createLines:CGRectMake(0, _scrol.bounds.size.height+10+80, self.view.bounds.size.width, 1)];
        [self createArears:CGRectMake(0, _scrol.bounds.size.height+10+81, self.view.bounds.size.width, 10)];
        [self createLines:CGRectMake(0, _scrol.bounds.size.height+10-1, self.view.bounds.size.width, 1)];
    }

}
-(void)createArears:(CGRect)rect
{
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    grayArear.frame=rect;
    [_headerView addSubview:grayArear];
}
-(void)createLines:(CGRect)rect
{
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line.frame=rect;
    [_headerView addSubview:line];
}
-(void)createTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    _LVTableView.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_LVTableView];
    _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    
    [self createTop:nil];
    _LVTableView.alpha=0;
}
-(void)createTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 476)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _LVTableView.tableHeaderView=_headerView;
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
        [_headerView addSubview:_pageControl];
    }
    
    if (array.count&&_scrol) {
        _scollCount=(int)array.count;
        _pageControl.numberOfPages=_scollCount;
        for (int i=0; i<array.count; i++) {
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
        UIImageView *imageView0=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            imageView0.frame=CGRectMake(0, 0, self.view.bounds.size.width, 150);
        }else
        {
            imageView0.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
        }
        NSDictionary *dict0=[array objectAtIndex:(_scollCount-1)];
        
        [imageView0 sd_setImageWithURL:[dict0 objectForKey:@"large_image"]];
        [_scrol addSubview:imageView0];
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        if (iPhone6Plus) {
            grayArear.frame=CGRectMake(0, 150, self.view.bounds.size.width, 10);
        }else
        {
            grayArear.frame=CGRectMake(0, 120, self.view.bounds.size.width, 10);
        }
        
        [_headerView addSubview:grayArear];
        
        
        [self createTimer];
    }
    
}

-(void)btnClick:(UIButton *)button
{
    NSDictionary *dict=[_hotActivityArray objectAtIndex:(button.tag-100)];
    if ([[dict objectForKey:@"type"] isEqualToString:@"keyword"]) {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"url"])
    {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        NSString *url=[dict objectForKey:@"url"];
        top.url=url;
        top.homeTitle=[dict objectForKey:@"title"];
        [self.navigationController pushViewController:top animated:YES];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"product"])
    {
        NSLog(@"快点补齐");
    }
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
    }if (scrollView==_LVTableView) {
        [_storeHouseRefreshControl scrollViewDidScroll];
        if (-_LVTableView.bounds.size.height+_LVTableView.contentSize.height<scrollView.contentOffset.y&&_isLastPage==NO) {
            if (_page==_countPage) {
                UIView *footView;
                if (_LVTableView.tableFooterView) {
                    footView=_LVTableView.tableFooterView;
                }
                footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
                footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
                _LVTableView.tableFooterView=footView;
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
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:[NSString stringWithFormat:DOMESTIC_CELL,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:DOMESTIC_CELL,_page] and:15];
                
            }
        }
        
    }

}

-(void)createSpecial:(NSArray *)array
{
    NSDictionary *dict=[array objectAtIndex:0];
    UILabel *leftLabel=[[UILabel alloc]init];
    if (iPhone6Plus) {
        leftLabel.frame=CGRectMake(10, 280, 60, 15);
        leftLabel.font=[UIFont systemFontOfSize:13];
    }else
    {
        leftLabel.frame=CGRectMake(10, 227, 60, 15);
        leftLabel.font=[UIFont systemFontOfSize:11];
    }
    leftLabel.text=@"特卖产品";
    [_headerView addSubview:leftLabel];
    
    
    UILabel *getMore=[[UILabel alloc]init];
    if (iPhone6Plus) {
        getMore.frame=CGRectMake(self.view.bounds.size.width-42, 280, 60, 15);
        getMore.font=[UIFont systemFontOfSize:13];
    }else
    {
        getMore.frame=CGRectMake(self.view.bounds.size.width-40, 227, 60, 15);
        getMore.font=[UIFont systemFontOfSize:11];
    }
    getMore.text=@"更多";
    getMore.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    [_headerView addSubview:getMore];
    
    
    UIImageView *more=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chackMore.png"]];
    if (iPhone6Plus) {
        more.frame=CGRectMake(self.view.bounds.size.width-13,getMore.frame.origin.y+2,6,10);
    }else
    {
        more.frame=CGRectMake(self.view.bounds.size.width-15,229,6,10);
    }
    [_headerView addSubview:more];
    
    
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=getMore.frame;
    [moreButton addTarget:self action:@selector(specialGetMore) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:moreButton];
    
    UIImageView *limitImage=[[UIImageView alloc]init];
    limitImage.frame=CGRectMake(10, getMore.frame.origin.y+20,210,100);
    [limitImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]]];
    [_headerView addSubview: limitImage];
    
    UILabel *detail=[[UILabel alloc]init];
    detail.text=[dict objectForKey:@"title"];
    detail.numberOfLines=2;
    
    if (iPhone6Plus) {
        detail.frame=CGRectMake(limitImage.bounds.size.width+20, getMore.frame.origin.y+17, self.view.bounds.size.width-limitImage.bounds.size.width-20, 40);
        detail.font=[UIFont systemFontOfSize:16];
    }else
    {
        detail.frame=CGRectMake(limitImage.bounds.size.width+20, getMore.frame.origin.y+17, self.view.bounds.size.width-limitImage.bounds.size.width-20, 30);
        detail.font=[UIFont systemFontOfSize:11];
    }
    
    [_headerView addSubview:detail];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    if (iPhone6Plus) {
        line.frame=CGRectMake(limitImage.bounds.size.width+20, getMore.frame.origin.y+57+10, self.view.bounds.size.width-limitImage.bounds.size.width-20, 1);
    }else
    {
        line.frame=CGRectMake(limitImage.bounds.size.width+20, getMore.frame.origin.y+57, self.view.bounds.size.width-limitImage.bounds.size.width-20, 1);
    }
    [_headerView addSubview:line];
    
    
    UILabel *price=[[UILabel alloc]init];
    if (iPhone6Plus) {
        price.frame=CGRectMake(limitImage.bounds.size.width+20,getMore.frame.origin.y+64+10,self.view.bounds.size.width-limitImage.bounds.size.width-20,20);
    }else
    {
        price.frame=CGRectMake(limitImage.bounds.size.width+20,getMore.frame.origin.y+64,self.view.bounds.size.width-limitImage.bounds.size.width-20,20);
    }
    price.font=[UIFont boldSystemFontOfSize:18];
    price.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    price.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:price];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"price"]]];
    NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13.0],NSFontAttributeName,[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
    
    [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0,1)];
    price.attributedText=attributedStr;
    
    UILabel *number=[[UILabel alloc]init];
    if (iPhone6Plus) {
        number.frame=CGRectMake(limitImage.bounds.size.width+20,getMore.frame.origin.y+84+10,self.view.bounds.size.width-limitImage.bounds.size.width-20,20);
    }else
    {
        number.frame=CGRectMake(limitImage.bounds.size.width+20,getMore.frame.origin.y+84,self.view.bounds.size.width-limitImage.bounds.size.width-20,20);
    }
    number.text=[NSString stringWithFormat:@"购买人数  %@人",[dict objectForKey:@"buyCount"]];
    number.font=[UIFont systemFontOfSize:12];
    number.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:number];
    
    if (iPhone6Plus) {
        [self createLines:CGRectMake(0, getMore.frame.origin.y+114+20, self.view.bounds.size.width, 1)];
        [self createArears:CGRectMake(0,getMore.frame.origin.y+115+20, self.view.bounds.size.width, 10)];
    }else
    {
        [self createLines:CGRectMake(0, getMore.frame.origin.y+114, self.view.bounds.size.width, 1)];
        [self createArears:CGRectMake(0,getMore.frame.origin.y+115, self.view.bounds.size.width, 10)];
    }
    
    UIButton *special=[UIButton buttonWithType:UIButtonTypeCustom];
    special.frame=CGRectMake(0, getMore.frame.origin.y+19, [UIScreen mainScreen].bounds.size.width, 90);
    [special addTarget:self action:@selector(specialClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:special];
    if (iPhone6Plus) {
        [self changeTableViewHeight:getMore.frame.origin.y+125+20];
    }else
    {
        [self changeTableViewHeight:getMore.frame.origin.y+125];
    }

    /*
     UIButton *limit=[UIButton buttonWithType:UIButtonTypeCustom];
     limit.frame=CGRectMake(10, 517, 150, 80);
     
     [limit addTarget:self action:@selector(limitClick) forControlEvents:UIControlEventTouchUpInside];
     [_headerView addSubview:limit];
    */
}
-(void)changeTableViewHeight:(float)height
{
    UIView *headView=_LVTableView.tableHeaderView;
    CGRect rect=headView.frame;
    rect.size.height=height;
    headView.frame=rect;
    _LVTableView.tableHeaderView=headView;
}

-(void)specialClick
{
    NSDictionary *dict=[_specialArray objectAtIndex:0];
    
    HomeSpecialDetailViewController *special=[[HomeSpecialDetailViewController alloc]init];
    special.ID=[dict objectForKey:@"object_id"];
    special.homeTitle=[dict objectForKey:@"特卖详情"];
    [self.navigationController pushViewController:special animated:YES];
    
}
-(void)specialGetMore
{
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

-(void)topBannerDownloadFinish
{
    _headArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:DOMESTIC_BANNER];
    _headArray=(NSMutableArray *)array;
    [self createTop:array];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    LVHomeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[LVHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_LVTableView==tableView) {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"place"]) {
            HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
            detail.ID=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"object_id"];
            detail.homeTitle=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"url"])
        {
            HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
            top.url=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"url"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"keyword"])
        {
            [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }
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
-(void)scrollViewClick:(UIButton *)button
{
    NSDictionary *dict=[_headArray objectAtIndex:(button.tag-100)];
    if ([[dict objectForKey:@"type"] isEqualToString:@"keyword"]) {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"url"])
    {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        NSString *url=[dict objectForKey:@"url"];
        top.url=url;
        top.homeTitle=[dict objectForKey:@"title"];
        [self.navigationController pushViewController:top animated:YES];
    }else if ([[dict objectForKey:@"type"]isEqualToString:@"product"])
    {
        NSLog(@"快点补齐");
    }
}

#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:DOMESTIC_CELL,_page] and:15];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_storeHouseRefreshControl scrollViewDidEndDragging];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
