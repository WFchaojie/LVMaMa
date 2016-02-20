//
//  HomeAbroadViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeAbroadViewController.h"
#import "LVHomeCell.h"
#import "HomeTopDetailViewController.h"
#import "HomeDetailViewController.h"
#import "HomeSpecialDetailViewController.h"
#import "HomeProductDetailViewController.h"
#import "LVHomeSpecialURLViewController.h"
@interface HomeAbroadViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *lvTableView;
@property (nonatomic,strong) UITableView *searchTableview;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *activityArray;
@property (nonatomic,strong) NSMutableArray *specialArray;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrol;
@property (nonatomic,strong) UIView *headerView;
//顶部scrollview上面滚动广告的个数
@property (nonatomic,assign) int scollCount;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int timerCount;
@property (nonatomic,strong) NSMutableArray *headArray;
//热词搜索
@property (nonatomic,strong) NSMutableArray *hotArray;
//热词
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,strong) CBHomeRefreshControl *storeHouseRefreshControl;
@property (nonatomic,assign) int page;
//用来判断防止page一直++
@property (nonatomic,assign) int countPage;
@property (nonatomic,assign) BOOL isLastPage;



@end

@implementation HomeAbroadViewController

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
        [self createNavigation];
        [self createTableView];
        [self createSearchTableView];
        [self hudShow];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    _isLastPage=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topDownloadFinish) name:ABROAD_BANNER object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:ABROAD_BANNER and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotWordDownloadFinish) name:ABROAD_HOT object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:ABROAD_HOT and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityDownloadFinish) name:ABROAD_ACTIVITY object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:ABROAD_ACTIVITY and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(specialDownloadFinish) name:ABROAD_SPECIAL object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:ABROAD_SPECIAL and:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:[NSString stringWithFormat:ABROAD_CELL,_page] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:ABROAD_CELL,_page] and:15];

    _activityArray=[[NSMutableArray alloc]initWithCapacity:0];
    _specialArray=[[NSMutableArray alloc]initWithCapacity:0];
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

-(void)specialDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:ABROAD_SPECIAL];
    _specialArray=(NSMutableArray *)array;
    if (array.count) {
        [self createSpecial:array];
    }
}

-(void)createSpecial:(NSArray *)array
{
    NSDictionary *dict=[array objectAtIndex:0];
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 360+3, 60, 15)];
    leftLabel.text=@"出境特卖";
    leftLabel.font=[UIFont systemFontOfSize:11];
    [_headerView addSubview:leftLabel];
    
    UILabel *getMore=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 360+3, 60, 15)];
    getMore.text=@"更多";
    getMore.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    getMore.font=[UIFont systemFontOfSize:11];
    [_headerView addSubview:getMore];
    
    UIImageView *more=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chackMore.png"]];
    more.frame=CGRectMake(self.view.bounds.size.width-15, 360+8,6,10);
    [_headerView addSubview:more];
    
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=getMore.frame;
    [moreButton addTarget:self action:@selector(specialGetMore) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:moreButton];
    
    UIImageView *limitImage=[[UIImageView alloc]init];
    limitImage.frame=CGRectMake(10, 380,170,80);
    [limitImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]]];
    [_headerView addSubview: limitImage];
    
    UILabel *detail=[[UILabel alloc]initWithFrame:CGRectMake(190, 378, self.view.bounds.size.width-170-20, 30)];
    detail.text=[dict objectForKey:@"title"];
    detail.numberOfLines=2;
    detail.font=[UIFont systemFontOfSize:11];
    [_headerView addSubview:detail];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line.frame=CGRectMake(190, 380+40, self.view.bounds.size.width-190, 1);
    [_headerView addSubview:line];
    
    UIImageView *line1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line1.frame=CGRectMake(0, 380+5+90, self.view.bounds.size.width, 1);
    [_headerView addSubview:line1];
    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    grayArear.frame=CGRectMake(0,380+5+91 , self.view.bounds.size.width, 10);
    [_headerView addSubview:grayArear];
    
    UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(190,370+13+40,self.view.bounds.size.width-190,20)];
    price.font=[UIFont boldSystemFontOfSize:18];
    price.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    price.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:price];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"price"]]];
    NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13.0],NSFontAttributeName,[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
    
    [attributedStr addAttributes:attributeDict1 range:NSMakeRange(0,1)];
    price.attributedText=attributedStr;
    
    UILabel *number=[[UILabel alloc]initWithFrame:CGRectMake(190,370+13+40+20,self.view.bounds.size.width-190,20)];
    number.text=[NSString stringWithFormat:@"购买人数  %@人",[dict objectForKey:@"buyCount"]];
    number.font=[UIFont boldSystemFontOfSize:12];
    number.textAlignment=NSTextAlignmentLeft;
    [_headerView addSubview:number];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 378, self.view.bounds.size.width, 80);
    [button addTarget:self action:@selector(specialClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:button];
    

}
-(void)specialClick
{
    HomeSpecialDetailViewController *specialDetail=[[HomeSpecialDetailViewController alloc]init];
    specialDetail.ID=[[_specialArray objectAtIndex:0] objectForKey:@"object_id"];
    specialDetail.homeTitle=@"特卖详情";
    [self.navigationController pushViewController:specialDetail animated:YES];
}
-(void)specialGetMore
{
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}
-(void)recommendDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:ABROAD_CELL,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:ABROAD_CELL,_page]]];
    }
    
    if(![[_dataArray lastObject]isKindOfClass:[NSDictionary class]])
    {
        _isLastPage=[[_dataArray lastObject] boolValue];
        [_dataArray removeObject:[_dataArray lastObject]];
    }
    
    
    
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
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:ABROAD_ACTIVITY];
    _activityArray=(NSMutableArray *)array;
    [self createActivity:array];
}
-(void)createActivity:(NSArray *)array
{
    
    for (int i=0; i<3; i++) {
        NSDictionary *dict=[array objectAtIndex:i];
        UIImageView *activity=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            activity.frame=CGRectMake(i*self.view.bounds.size.width/3, 325, self.view.bounds.size.width/3, 95);
        }else
        {
            activity.frame=CGRectMake(i*self.view.bounds.size.width/3, 285, self.view.bounds.size.width/3, 63);
        }
        [activity sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"large_image"]] placeholderImage:nil];
        [_headerView addSubview:activity];
        activity.userInteractionEnabled=YES;
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=activity.bounds;
        [button addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100+i;
        [activity addSubview:button];
    }
    for (int i=0; i<2; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, 325+i*95, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, 285+i*63, self.view.bounds.size.width, 1);
        }
        [_headerView addSubview:line];
    }
    
    for (int j=0; j<2; j++) {
        for (int i=0; i<2; i++) {
            UIImageView *vertical=[[UIImageView alloc]init];
            if (iPhone6Plus) {
                vertical.frame=CGRectMake((j+1)*self.view.frame.size.width/3, 325+i, 1, 95-i);
            }else
            {
                vertical.frame=CGRectMake((j+1)*self.view.frame.size.width/3, 285-i, 1, 63);
            }
            vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
            vertical.alpha=0.5;
            [_headerView addSubview:vertical];
        }
    }
    
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, 325+95, self.view.bounds.size.width, 10);
    }else
    {
        grayArear.frame=CGRectMake(0, 286+63, self.view.bounds.size.width, 10);
    }
    [_headerView addSubview:grayArear];
    
    _headerView=_lvTableView.tableHeaderView;
    _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, grayArear.bounds.size.height+grayArear.frame.origin.y);
    _lvTableView.tableHeaderView=_headerView;
    
}
-(void)activityClick:(UIButton *)button
{
    if ([[((NSDictionary *)[_activityArray objectAtIndex:(button.tag-100)])objectForKey:@"type"] isEqualToString:@"url"]) {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        NSString *url=[((NSDictionary *)[_activityArray objectAtIndex:(button.tag-100)])objectForKey:@"url"];
        top.url=url;
        top.homeTitle=[((NSDictionary *)[_activityArray objectAtIndex:(button.tag-100)])objectForKey:@"title"];
        [self.navigationController pushViewController:top animated:YES];
    }else if ([[((NSDictionary *)[_activityArray objectAtIndex:(button.tag-100)])objectForKey:@"type"] isEqualToString:@"keyword"])
    {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}
-(void)hotWordDownloadFinish
{
    _hotArray=[[NSMutableArray alloc]initWithCapacity:0];
    _hotArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:ABROAD_HOT];
    [self createHotWord:0];
}
//热词
-(void)createHotWord:(int)hotTag
{
    if (_hotView) {
        for (UIView *view in _hotView.subviews) {
            [view removeFromSuperview];
        }
    }else{
        _hotView=[[UIView alloc]init];
        if (iPhone6Plus) {
            _hotView.frame=CGRectMake(0, 180, self.view.bounds.size.width, 35*3+30);
        }else
        {
            _hotView.frame=CGRectMake(0, 150, self.view.bounds.size.width, 126);
        }
        _hotView.backgroundColor=[UIColor whiteColor];
        [_headerView addSubview:_hotView];
    }
    for (int i=0; i<4; i++) {
        UILabel *hot=[[UILabel alloc]init];
        hot.text=[NSString stringWithFormat:@"%d月",i+4];
        if (iPhone6Plus) {
            hot.frame=CGRectMake(i*self.view.bounds.size.width/4, 0, self.view.bounds.size.width/4, 30);
            hot.font=[UIFont systemFontOfSize:14];
        }else
        {
            hot.frame=CGRectMake(i*self.view.bounds.size.width/4, 0, self.view.bounds.size.width/4, 20);
            hot.font=[UIFont systemFontOfSize:12];
        }
        [_hotView addSubview:hot];
        hot.textColor=[UIColor grayColor];
        hot.textAlignment=NSTextAlignmentCenter;
        hot.userInteractionEnabled=YES;
        
        UIButton *hotButton=[UIButton buttonWithType:UIButtonTypeCustom];
        hotButton.frame=hot.bounds;
        hotButton.tag=100+i;
        [hotButton addTarget:self action:@selector(hotClick:) forControlEvents:UIControlEventTouchUpInside];
        [hot addSubview:hotButton];
        if (i==hotTag) {
            hot.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
            hotButton.selected=YES;
        }
    }
    int count=0;
    NSDictionary *dict=[_hotArray objectAtIndex:hotTag];
    NSString *words=[dict objectForKey:@"keyword"];
    NSArray *hotWord=[words componentsSeparatedByString:@","];
    for (int j=0; j<3; j++) {
        for (int i=0; i<3; i++) {
            UILabel *hot=[[UILabel alloc]init];
            hot.text=[hotWord objectAtIndex:count];
            if (iPhone6Plus) {
                hot.font=[UIFont systemFontOfSize:14];
                hot.frame=CGRectMake(i*self.view.bounds.size.width/3, 30+j*35, self.view.bounds.size.width/3, 35);
            }else
            {
                hot.font=[UIFont systemFontOfSize:12];
                hot.frame=CGRectMake(i*self.view.bounds.size.width/3, 20+j*35, self.view.bounds.size.width/3, 35);
            }
            [_hotView addSubview:hot];
            hot.textAlignment=NSTextAlignmentCenter;
            hot.userInteractionEnabled=YES;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=hot.bounds;
            [button addTarget:self action:@selector(hotWordClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=100+count;
            [hot addSubview:button];
            
            count++;
            
        }
    }
    
    for (int i=0; i<4; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        if (iPhone6Plus) {
            line.frame=CGRectMake(0, 30+i*35, self.view.bounds.size.width, 1);
        }else
        {
            line.frame=CGRectMake(0, 20+i*35, self.view.bounds.size.width, 1);
        }
        [_hotView addSubview:line];
    }
    for (int i=0; i<2; i++) {
        UIImageView *vertical=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 30, 1,35*3);
        }else
        {
            vertical.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 20, 1,105);
        }
        vertical.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical.alpha=0.5;
        [_hotView addSubview:vertical];
        UIImageView *vertical1=[[UIImageView alloc]init];
        if (iPhone6Plus) {
            vertical1.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 31, 1,105-1);
        }else
        {
            vertical1.frame=CGRectMake((i+1)*self.view.bounds.size.width/3, 21, 1,105-1);
        }
        vertical1.image=[UIImage imageNamed:@"lineHotelDetail.png"];
        vertical1.alpha=0.5;
        [_hotView addSubview:vertical1];
    }
    UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
    if (iPhone6Plus) {
        grayArear.frame=CGRectMake(0, 3*35+31, self.view.bounds.size.width, 10);
    }else
    {
        grayArear.frame=CGRectMake(0, 276, self.view.bounds.size.width, 10);
    }
    [_hotView addSubview:grayArear];
    
}

-(void)hotWordClick:(UIButton *)button
{
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

}

-(void)hotClick:(UIButton *)button
{
    for (UILabel *label in button.superview.superview.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor grayColor];
            for (UIButton *btn in label.subviews) {
                btn.selected=NO;
            }
        }
    }
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    [self createHotWord:(int)(button.tag-100)];
}


-(void)createTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _lvTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _lvTableView.delegate=self;
    _lvTableView.dataSource=self;
    _lvTableView.backgroundColor=[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_lvTableView];
    _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_lvTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];

    [self createTicketTop:nil];
}
-(void)createTicketTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 485)];
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
        
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        if (iPhone6Plus) {
            grayArear.frame=CGRectMake(0, 150, self.view.bounds.size.width, 30);
        }else
        {
            grayArear.frame=CGRectMake(0, 120, self.view.bounds.size.width, 30);
        }
        [_headerView addSubview:grayArear];
        
        UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, grayArear.bounds.size.height)];
        hot.text=@"月度热门";
        hot.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hot];
        hot.textColor=[UIColor grayColor];
        
        
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
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDownloadFinish) name:[NSString stringWithFormat:ABROAD_CELL,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:ABROAD_CELL,_page] and:15];
                
            }
        }
        
    }

    
}
-(void)topDownloadFinish
{
    _headArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:ABROAD_BANNER];
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
            LVHomeSpecialURLViewController *top=[[LVHomeSpecialURLViewController alloc]init];
            top.url=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"url"];
            top.homeTitle=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
            [self.navigationController pushViewController:top animated:YES];
        }else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"keyword"])
        {
            [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"]isEqualToString:@"product"])
        {
            HomeProductDetailViewController *product=[[HomeProductDetailViewController alloc]init];
            product.ID=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"object_id"];
            [self.navigationController pushViewController:product animated:YES];
        }
    }
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
-(void)scrollViewClick:(UIButton *)button
{
    if ([[((NSDictionary *)[_headArray objectAtIndex:(button.tag-100)])objectForKey:@"type"] isEqualToString:@"url"]) {
        HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
        NSString *url=[((NSDictionary *)[_headArray objectAtIndex:(button.tag-100)])objectForKey:@"url"];
        top.url=url;
        top.homeTitle=[((NSDictionary *)[_headArray objectAtIndex:(button.tag-100)])objectForKey:@"title"];
        [self.navigationController pushViewController:top animated:YES];
    }else if ([[((NSDictionary *)[_headArray objectAtIndex:(button.tag-100)])objectForKey:@"type"] isEqualToString:@"keyword"])
    {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }

}

#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:ABROAD_CELL,_page] and:15];
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
