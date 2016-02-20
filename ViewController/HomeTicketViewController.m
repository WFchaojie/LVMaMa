//
//  HomeTicketViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeTicketViewController.h"
#import "HomeTopDetailViewController.h"
#import "LVTicketCell.h"
#import "HomeDetailViewController.h"
#import "HomeTopDetailViewController.h"

@interface HomeTicketViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

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
@property (nonatomic,strong) NSMutableArray *headArray;
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,assign) int timerCount;

@end

@implementation HomeTicketViewController


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
    if(!_lvTableView)
    {
        [self createNavigation];
        [self createTableView];
        [self createSearchTableView];
        [self hudShow];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topDownloadFinish) name:BUTTONINFOTOP object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:BUTTONINFOTOP and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotWordDownloadFinish) name:HOTWORD object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:HOTWORD and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityDownloadFinish) name:BUTTONINFOACTIVITY object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:BUTTONINFOACTIVITY and:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityDownloadFinish) name:BUTTONINFOACTIVITY object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:BUTTONINFOACTIVITY and:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:RECOMMENDBJ object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:RECOMMENDBJ and:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topicSearchDownloadFinish) name:TOPICSEARCH object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:TOPICSEARCH and:0];

    _hotWordArray=[[NSMutableArray alloc]initWithCapacity:0];
    _activityArray=[[NSMutableArray alloc]initWithCapacity:0];

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
    _search.placeholder=@"输入景点名称/城市/主题";
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

-(void)topicSearchDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:TOPICSEARCH];
    [self createFooterView:array];
}

-(void)createFooterView:(NSArray *)array
{
    UIView *footer;
    if (!_lvTableView.tableFooterView) {
        footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        footer.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        footer.userInteractionEnabled=YES;
        _lvTableView.tableFooterView=footer;
    }else
    {
        footer=_lvTableView.tableFooterView;
        footer.frame=CGRectMake(0, 0, self.view.bounds.size.width, 150);
        footer.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        footer.userInteractionEnabled=YES;
        _lvTableView.tableFooterView=footer;
    }

    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    grayArear.frame=CGRectMake(0, 0, self.view.bounds.size.width, 30);
    [footer addSubview:grayArear];
    
    UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, grayArear.bounds.size.height)];
    hot.text=@"按主题查找";
    hot.font=[UIFont systemFontOfSize:12];
    [grayArear addSubview:hot];
    hot.textColor=[UIColor grayColor];
    
    int count=0;
    for (int j=0; j<2; j++) {
        for (int i=0; i<3; i++) {
            NSDictionary *dict=[array objectAtIndex:count];
            UIView *backView=[[UIView alloc]init];
            backView.frame=CGRectMake(i*self.view.bounds.size.width/3, 30+j*35, self.view.bounds.size.width/3, 35);
            backView.backgroundColor=[UIColor whiteColor];
            [footer addSubview:backView];
            
            UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(20+i*self.view.bounds.size.width/3+5, 38+j*35, 25, 18)];
            pic.userInteractionEnabled=YES;
            [footer addSubview:pic];
            
            UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(50+i*self.view.bounds.size.width/3, 30+j*35, self.view.bounds.size.width/3-50, 35)];
            hot.font=[UIFont systemFontOfSize:12];
            [footer addSubview:hot];
            
            if (i==2&&j==1) {
                pic.image=[UIImage imageNamed:@"siteActionImage.png"];
                hot.text=@"查看更多";
                hot.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
            }else{
                [pic sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]]];
                hot.text=[dict objectForKey:@"title"];
            }
            
            count++;
        }
    }
    
    for (int i=1; i<3; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        line.userInteractionEnabled=YES;
        line.frame=CGRectMake(0, 30+i*35, self.view.bounds.size.width, 1);
        [footer addSubview:line];
    }
    for (int i=0; i<2; i++) {
        UIImageView *vertical=[[UIImageView alloc]initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width/3, 30, 1,70)];
        vertical.userInteractionEnabled=YES;
        vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical.alpha=0.5;
        [footer addSubview:vertical];
        UIImageView *vertical1=[[UIImageView alloc]initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width/3, 29, 1,70)];
        vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical1.alpha=0.5;
        vertical1.userInteractionEnabled=YES;
        [footer addSubview:vertical1];
    }
    int btnCount=0;
    for (int j=0; j<2; j++) {
        for (int i=0; i<3; i++) {
            UIButton *topic=[UIButton buttonWithType:UIButtonTypeCustom];
            topic.frame=CGRectMake(i*self.view.bounds.size.width/3, 30+j*35, self.view.bounds.size.width/3, 35);
            [topic addTarget:self action:@selector(topic:) forControlEvents:UIControlEventTouchUpInside];
            
            topic.tag=100+btnCount;
            [footer addSubview:topic];
            btnCount++;
        }
    }
}

-(void)topic:(UIButton *)button
{
    
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

-(void)recommendDownloadFinish
{
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:RECOMMENDBJ];
    [self hudHide];
    _lvTableView.alpha=1;
    [_lvTableView reloadData];
}

-(void)activityDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:BUTTONINFOACTIVITY];
    _activityArray=(NSMutableArray *)array;
    [self createActivity:array];
}

-(void)createActivity:(NSArray *)array
{
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict=[array objectAtIndex:i];
        UIImageView *activity=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            activity.frame=CGRectMake(0, 322+i*83, self.view.bounds.size.width, 83);
        }else
        {
            activity.frame=CGRectMake(0, 282+i*63, self.view.bounds.size.width, 63);
        }
        [activity sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]] placeholderImage:nil];
        [_headerView addSubview:activity];
        
        UIButton *activityButton=[UIButton buttonWithType:UIButtonTypeCustom];
        activityButton.frame=activity.frame;
        [activityButton addTarget:self action:@selector(activity:) forControlEvents:UIControlEventTouchUpInside];
        activityButton.tag=100+i;
        [_headerView addSubview:activityButton];
    }
    for (int i=0; i<=array.count; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, 322+i*83, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, 282+i*63, self.view.bounds.size.width, 1);
        }
        [_headerView addSubview:line];
    }
    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, 323+83*array.count, self.view.bounds.size.width, 30);
    }else
    {
        grayArear.frame=CGRectMake(0, 282+63*array.count, self.view.bounds.size.width, 30);
    }
    [_headerView addSubview:grayArear];
    
    UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, grayArear.bounds.size.height)];
    hot.text=@"小编推荐";
    hot.font=[UIFont systemFontOfSize:12];
    [grayArear addSubview:hot];
    hot.textColor=[UIColor grayColor];
    UIView *head=_lvTableView.tableHeaderView;
    if (iPhone6Plus) {
        head.frame=CGRectMake(0, 0, self.view.bounds.size.width, 323+83*array.count+30);
    }else
    {
        head.frame=CGRectMake(0, 0, self.view.bounds.size.width, 282+63*array.count+30);
    }
    _lvTableView.tableHeaderView=head;
}

-(void)activity:(UIButton *)button
{
    NSDictionary *dict=[_activityArray objectAtIndex:button.tag-100];
    if ([[dict objectForKey:@"type"]isEqualToString:@"url"]) {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        top.homeTitle=[dict objectForKey:@"title"];
        top.url=[dict objectForKey:@"url"];
        [self.navigationController pushViewController:top animated:YES];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

-(void)hotWordDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:HOTWORD];
    _hotWordArray=(NSMutableArray *)array;
    [self createHotWord:array];
}
//热词
-(void)createHotWord:(NSArray *)array
{
    int count=0;
    for (int j=0; j<2; j++) {
        for (int i=0; i<3; i++) {
            if (count<array.count) {
                NSDictionary *dict=[array objectAtIndex:count];
                UILabel *hot=[[UILabel alloc]init];
                if([dict objectForKey:@"title"])
                    hot.text=[dict objectForKey:@"title"];
                if (iPhone6Plus) {
                    hot.font=[UIFont systemFontOfSize:14];
                    hot.frame=CGRectMake(i*self.view.bounds.size.width/3, 231+j*40, self.view.bounds.size.width/3, 40);
                }else
                {
                    hot.font=[UIFont systemFontOfSize:12];
                    hot.frame=CGRectMake(i*self.view.bounds.size.width/3, 201+j*35, self.view.bounds.size.width/3, 35);
                }
                [_headerView addSubview:hot];
                hot.textAlignment=NSTextAlignmentCenter;
                
                UIButton *hotWord=[UIButton buttonWithType:UIButtonTypeCustom];
                hotWord.frame=hot.frame;
                [hotWord addTarget:self action:@selector(hotWordClick:) forControlEvents:UIControlEventTouchUpInside];
                hotWord.tag=100+count;
                [_headerView addSubview:hotWord];
                count++;
            }
        }
    }
    for (int i=0; i<3; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, 231+i*40, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, 201+i*35, self.view.bounds.size.width, 1);
        }
        [_headerView addSubview:line];
    }
    for (int i=0; i<2; i++) {
        UIImageView *vertical=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 231, 1,80);
        }else
        {
            vertical.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 201, 1,80);
        }
        vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical.alpha=0.5;
        [_headerView addSubview:vertical];
        UIImageView *vertical1=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical1.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 230, 1,80);
        }else
        {
            vertical1.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 200, 1,70);
        }
        vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical1.alpha=0.5;
        [_headerView addSubview:vertical1];
    }
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, 312, self.view.bounds.size.width, 10);
    }else
    {
        grayArear.frame=CGRectMake(0, 272, self.view.bounds.size.width, 10);
    }
    [_headerView addSubview:grayArear];
}

-(void)hotWordClick:(UIButton *)button
{
    NSDictionary *dict=[_hotWordArray objectAtIndex:button.tag-100];
    if (![[dict objectForKey:@"object_id" ]isEqualToString:@"0"]) {
        HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
        detail.ID=[dict objectForKey:@"object_id"];
        [self.navigationController pushViewController:detail animated:YES];
    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

-(void)createTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _lvTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    _lvTableView.delegate=self;
    _lvTableView.dataSource=self;
    _lvTableView.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_lvTableView];
    [self createTicketTop:nil];
    _lvTableView.alpha=0;
}
-(void)createTicketTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 376)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _lvTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        _scrol.pagingEnabled=YES;
        _scrol.bounces=NO;
        _scrol.showsHorizontalScrollIndicator=NO;
        _scrol.showsVerticalScrollIndicator=NO;
        [_headerView addSubview:_scrol];
        _scrol.delegate=self;
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 130, self.view.bounds.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }
    
    if (array.count&&_scrol) {
        _scollCount=(int)array.count;
        _pageControl.numberOfPages=_scollCount;
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
        UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        NSDictionary *dict0=[array objectAtIndex:(_scollCount-1)];
        if (iPhone6Plus) {
            imageView0.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 150);
        }else
        {
            imageView0.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
        }
        
        [imageView0 sd_setImageWithURL:[dict0 objectForKey:@"large_image"]];
        [_scrol addSubview:imageView0];
        
        NSArray *picArray=[NSArray arrayWithObjects:@"placeAllStationDJ.png",@"placeArround.png",nil];
        NSArray *textArray=[NSArray arrayWithObjects:@"北京景点",@"周边景点",nil];

        for (int i=0; i<2; i++) {
            UIImageView *address=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[picArray objectAtIndex:i]]];
            if (iPhone6Plus) {
                address.frame=CGRectMake(50+i*(self.view.bounds.size.width/2), imageView0.frame.size.height+10, 24, 27);
            }else
            {
                address.frame=CGRectMake(30+i*(self.view.bounds.size.width/2), imageView0.frame.size.height+10, 24, 27);
            }
            [_headerView addSubview:address];
            
            UILabel *text=[[UILabel alloc]init];
            if (iPhone6Plus) {
                text.frame=CGRectMake(59+24+i*(self.view.bounds.size.width/2), imageView0.frame.size.height+15, 80, 20);
            }else
            {
                text.frame=CGRectMake(35+24+i*(self.view.bounds.size.width/2), imageView0.frame.size.height+12, 80, 20);
            }
            text.text=[textArray objectAtIndex:i];
            text.font=[UIFont systemFontOfSize:14];
            [_headerView addSubview:text];
            if (i==0) {
                text.textColor=[UIColor colorWithRed:0.93f green:0.45f blue:0.19f alpha:1.00f];
            }else
                text.textColor=[UIColor colorWithRed:0.48f green:0.78f blue:0.19f alpha:1.00f];
            
            UIImageView *vertical=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, imageView0.frame.size.height, 1, 50)];
            vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
            vertical.alpha=0.5;
            [_headerView addSubview:vertical];
            UIImageView *vertical1=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, imageView0.frame.size.height-1, 1, 50)];
            vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
            vertical1.alpha=0.5;
            [_headerView addSubview:vertical1];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*(self.view.bounds.size.width/2), imageView0.frame.size.height+12, self.view.bounds.size.width/2, 50);
            btn.tag=100+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btn];
        }
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        line.frame=CGRectMake(0, imageView0.frame.size.height+50, self.view.bounds.size.width, 1);
        [_headerView addSubview:line];
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        grayArear.frame=CGRectMake(0, imageView0.frame.size.height+51, self.view.bounds.size.width, 30);
        [_headerView addSubview:grayArear];
        
        UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, grayArear.bounds.size.height)];
        hot.text=@"热词搜索";
        hot.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hot];
        hot.textColor=[UIColor grayColor];
        
        
        [self createTimer];
    }
    
}
#pragma mark 景点被点击
//景点被点击
-(void)btnClick:(UIButton *)btn
{
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
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
    }
}   
-(void)topDownloadFinish
{
    _headArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:BUTTONINFOTOP];
    _headArray=(NSMutableArray *)array;
    [self createTicketTop:array];
}
#pragma mark tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    LVTicketCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[LVTicketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.pic.image=nil;
    cell.title.text=@"";
    cell.price.text=@"";
    cell.priceMarket.text=@"";
    cell.cellPic=@"";
    cell.cellTitle=@"";
    cell.cellPrice=@"";
    cell.cellPriceMarket=@"";
    cell.cellType=@"";
    cell.type.text=@"";
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    cell.cellPic=[dict objectForKey:@"large_image"];
    cell.cellTitle=[dict objectForKey:@"title"];
    cell.cellPriceMarket=[NSString stringWithFormat:@"%@%d",@"￥",[[dict objectForKey:@"market_price"] intValue]];
    cell.cellPrice=[NSString stringWithFormat:@"%d%@",[[dict objectForKey:@"price"] intValue],@"起"];
    cell.cellType=[dict objectForKey:@"content"];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone6Plus) {
        return 100;
    }else
    {
        return 75;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"type"]isEqualToString:@"place"]) {
        HomeDetailViewController *detail=[[HomeDetailViewController alloc]init];
        detail.ID=[dict objectForKey:@"object_id"];
        [self.navigationController pushViewController:detail animated:YES];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
