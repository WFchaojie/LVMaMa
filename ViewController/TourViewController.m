//
//  TourViewController.m
//  LvMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TourViewController.h"
#import "LVDownLoadManager.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "LVTourCell.h"
#import "LVDestinationCell.h"
#import "HomeTopDetailViewController.h"
#import "lvmamaAppDelegate.h"
#import "TourRecordDetailController.h"
#import "TourDestinationDetailViewController.h"
#import "CBHomeRefreshControl.h"
#import "LogInViewController.h"
#import "TourPlaceViewController.h"
@interface TourViewController ()<UITableViewDataSource,UITableViewDelegate,gotoDestination>

@end

@implementation TourViewController
{
    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_headArray;
    NSMutableArray *_scrollTopArray;
    UICollectionView *_collectionView;
    UITableView *_LVDestinationTableView;
    UIPageControl *_pageControl;
    UIScrollView *_scrol;
    UIView *_headerView;
    //顶部scrollview上面滚动广告的个数
    int _scollCount;
    NSTimer *_timer;
    int _timerCount;
    NSMutableArray *_desDataArray;
    CBHomeRefreshControl *_storeHouseRefreshControl;
    int _page;
    //用来判断防止page一直++
    int _countPage;
    BOOL _hasNext;
}
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
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-46, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
    if (!_LVTableView) {
        [self createNavigation];
        [self createTableView];
        [self createDestinationTableView];
        [self hudShow];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    _hasNext=YES;
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:TOURTOPURL and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourTopDownloadFinish) name:TOURTOPURL object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOURRECORD,_page] and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourRecordDownloadFinish) name:[NSString stringWithFormat:TOURRECORD,_page] object:nil];
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:TOURDestinationTop and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourDesTopDownloadFinish) name:TOURDestinationTop object:nil];
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:TOURDestinationINFOURL and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourDesInfoDownloadFinish) name:TOURDestinationINFOURL object:nil];
    
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _desDataArray=[[NSMutableArray alloc]initWithCapacity:0];

    //另一种方案 [self createCollectionView];
	// Do any additional setup after loading the view.
}

-(void)TourDesInfoDownloadFinish
{
    [self hudHide];
    _desDataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:TOURDestinationINFOURL];
    [_LVDestinationTableView reloadData];
}
-(void)TourDesTopDownloadFinish
{
    [self hudHide];
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:TOURDestinationTop];
    _scrollTopArray=[[NSMutableArray alloc]initWithArray:array];
    [self createDesTop:array];
}
-(void)createDesTop:(NSArray *)array
{
    if (!_scrol) {
        _scollCount=4;
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 230)];
        _LVDestinationTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]init];
        if (iPhone6Plus) {
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, 160);
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
            _pageControl.frame=CGRectMake(0, 140, self.view.bounds.size.width, 20);
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
        for (int i=0; i<_scollCount; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*(_scollCount+2), 0);
            UIImageView *imageView=[[UIImageView alloc]init];
            if (iPhone6Plus) {
                imageView.frame=CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 160);
            }else
            {
                imageView.frame=CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
            }
            NSDictionary *dict=[array objectAtIndex:i];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/pics/%@",[dict objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
            
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
            imageView1.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 160);
        }else
        {
            imageView1.frame=CGRectMake((_scollCount+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, 120);
        }
        NSDictionary *dict1=[array objectAtIndex:0];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/pics/%@",[dict1 objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
        [_scrol addSubview:imageView1];
        _scrol.contentOffset=CGPointMake(self.view.bounds.size.width, 0);
        //第一张图左边的（最后一张图）
        UIImageView *imageView0=[[UIImageView alloc]init];
        NSDictionary *dict0=[array objectAtIndex:(_scollCount-1)];
        if (iPhone6Plus) {
            imageView0.frame=CGRectMake(0, 0, self.view.bounds.size.width, 160);
        }else
        {
            imageView0.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
        }
        [imageView0 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/pics/%@",[dict0 objectForKey:@"image"]]]placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
        [_scrol addSubview:imageView0];
        
        NSArray *placeArray=[NSArray arrayWithObjects:@"internalDestImage.png",@"overseaDestImage.png",nil];
        for (int i=0; i<2; i++) {
            UIButton *place=[UIButton buttonWithType:UIButtonTypeCustom];
            if (iPhone6Plus) {
                place.frame=CGRectMake(10+i*self.view.bounds.size.width/2-5, 170, self.view.bounds.size.width/2-15, 90);
            }else
            {
                place.frame=CGRectMake(10+i*155, 130, 145, 60);
            }
            [place setImage:[UIImage imageNamed:[placeArray objectAtIndex:i]] forState:UIControlStateNormal];
            [_headerView addSubview:place];
            place.tag=100+i;
            [place addTarget:self action:@selector(goToPlace:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        if (iPhone6Plus) {
            grayArear.frame=CGRectMake(0, 170+90+10, self.view.bounds.size.width, 30);
        }else
        {
            grayArear.frame=CGRectMake(0, 120+80, self.view.bounds.size.width, 30);
        }
        
        [_headerView addSubview:grayArear];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, grayArear.bounds.size.width, 30)];
        label.text=@"热门点击";
        label.font=[UIFont boldSystemFontOfSize:12];
        label.textColor=[UIColor grayColor];
        [grayArear addSubview:label];

        _headerView=_LVDestinationTableView.tableHeaderView;
        _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, grayArear.bounds.size.height+grayArear.frame.origin.y);
        _LVDestinationTableView.tableHeaderView=_headerView;
        
        [self createTimer];

    }
}
-(void)goToPlace:(UIButton *)button
{
    /*
    TourPlaceViewController *place=[[TourPlaceViewController alloc]init];
    place.index=(int)button.tag;
    [self.navigationController pushViewController:place animated:YES];
    */
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
-(void)scrollViewClick:(UIButton *)button
{
    TourDestinationDetailViewController *detail=[[TourDestinationDetailViewController alloc]init];
    detail.ID=[[_scrollTopArray objectAtIndex:(button.tag-100)] objectForKey:@"objectId"];
    detail.deTitle=[[_scrollTopArray objectAtIndex:(button.tag-100)] objectForKey:@"title"];
    [self.navigationController pushViewController:detail animated:YES];
}
//自定义导航条
-(void)createNavigation
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:navView];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 50, 20)];
    address.userInteractionEnabled=YES;
    address.text=@"游记";
    address.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    address.font=[UIFont boldSystemFontOfSize:17];
    address.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:address];
    
    UIButton *addressButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame=address.bounds;
    addressButton.tag=100;
    [addressButton addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
    [address addSubview:addressButton];
    
    UILabel *destination=[[UILabel alloc]initWithFrame:CGRectMake(55, 30, 80, 20)];
    destination.userInteractionEnabled=YES;
    destination.text=@"目的地";
    destination.textColor=[UIColor colorWithRed:0.87f green:0.51f blue:0.69f alpha:1.00f];
    destination.font=[UIFont boldSystemFontOfSize:17];
    destination.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:destination];
    
    UIButton *destinationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    destinationButton.frame=destination.bounds;
    destinationButton.tag=101;
    [destinationButton addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
    [destination addSubview:destinationButton];
    addressButton.selected=YES;
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabLeftSel.png"]];
    line.frame=CGRectMake(10, navView.bounds.size.height-5, address.bounds.size.width-10, 3);
    [navView addSubview:line];
    
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.frame=CGRectMake(self.view.bounds.size.width-70, 25, 33, 33);
    add.tag=201;
    [add setBackgroundImage:[UIImage imageNamed:@"microAddNoteImage.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:add];
    
    UIButton *search=[UIButton buttonWithType:UIButtonTypeCustom];
    search.frame=CGRectMake(self.view.bounds.size.width-40, 25, 33, 33);
    search.tag=202;
    [search setBackgroundImage:[UIImage imageNamed:@"microSearchImage.png"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:search];
}

-(void)searchClick:(UIButton *)button
{

}

-(void)addClick:(UIButton *)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
        
    }];
}

-(void)addressClick:(UIButton *)button
{
    for (UILabel *label in button.superview.superview.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor colorWithRed:0.87f green:0.51f blue:0.69f alpha:1.00f];
            for (UIButton *btn in label.subviews) {
                if (btn.selected==YES) {
                    if (btn.tag!=button.tag) {
                        [self hudShow];
                    }
                }
                btn.selected=NO;
            }
        }
        if ([label isKindOfClass:[UIImageView class]]) {
            UIImageView *pic=(UIImageView *)label;
            if (button.tag==100) {
                [UIView animateWithDuration:0.1 animations:^{
                    pic.frame=CGRectMake(10, 64-5, 50-10, 3);
                }];
            }else
            {
                [UIView animateWithDuration:0.1 animations:^{
                    pic.frame=CGRectMake(65, 64-5, 60, 3);
                }];
            }
        }

    }
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    button.selected=YES;
    if (button.tag==100) {
        if (_LVDestinationTableView.superview) {
            [UIView animateWithDuration:0.9 animations:^{
                _LVDestinationTableView.alpha=0;
                [self.view insertSubview:_LVTableView aboveSubview:_LVDestinationTableView];
                _LVTableView.alpha=1;
            } completion:^(BOOL finished) {
                [self hudHide];
            }];
        }
    }else
    {
        if (_LVTableView.superview) {
            [UIView animateWithDuration:0.9 animations:^{
                _LVTableView.alpha=0;
                _LVDestinationTableView.alpha=1;
                [self.view insertSubview:_LVDestinationTableView aboveSubview:_LVTableView];
            } completion:^(BOOL finished) {
                [self hudHide];
            }];
        }
    
    }
}

-(void)createDestinationTableView
{
    if (!_LVDestinationTableView) {
        _LVDestinationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-46) style:UITableViewStylePlain];
        _LVDestinationTableView.delegate=self;
        _LVDestinationTableView.dataSource=self;
        _LVDestinationTableView.alpha=0;
        _LVDestinationTableView.showsHorizontalScrollIndicator=NO;
        _LVDestinationTableView.showsVerticalScrollIndicator=NO;
    }
}

-(void)createTableView
{
    if (!_LVTableView) {
        _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-46) style:UITableViewStylePlain];
        _LVTableView.delegate=self;
        _LVTableView.dataSource=self;
        [self.view addSubview:_LVTableView];
        _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
        _LVTableView.alpha=0;
    }
}

-(void)createTabLeHeaderView:(NSArray *)array
{
    NSDictionary *dict=[array objectAtIndex:0];
    if ([dict objectForKey:@"image"]) {
        NSString *url=[NSString stringWithFormat:@"http://pic.lvmama.com/pics/%@",[dict objectForKey:@"image"] ];
        UIButton *top=[UIButton buttonWithType:UIButtonTypeCustom];
        [top sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
        top.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
        [top addTarget:self action:@selector(tourTopClick) forControlEvents:UIControlEventTouchUpInside];
        _LVTableView.tableHeaderView=top;
    }
}

-(void)tourTopClick
{
    NSDictionary *dict=[_headArray objectAtIndex:0];
    HomeTopDetailViewController *top=[[HomeTopDetailViewController alloc]init];
    top.url=[dict objectForKey:@"objectId"];
    
    [self.navigationController pushViewController:top animated:YES];
}

-(void)TourTopDownloadFinish
{
    _headArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:TOURTOPURL];
    _headArray=(NSMutableArray *)array;
    NSLog(@"%@",array);
    [self createTabLeHeaderView:array];
}

-(void)TourRecordDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOURRECORD,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOURRECORD,_page]]];
    }
    _hasNext=[[[_dataArray lastObject] objectForKey:@"hasNext"]boolValue];
    [_dataArray removeObject:[_dataArray lastObject]];
    if (_LVTableView.tableFooterView) {
        UIView *footView=_LVTableView.tableFooterView;
        for (UIView *foot in footView.subviews) {
            [foot removeFromSuperview];
        }
        [footView removeFromSuperview];
    }
    [self hudHide];
    _LVTableView.alpha=1;
    [_LVTableView reloadData];
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_LVTableView) {
        static NSString *cellName=@"cell";
        LVTourCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[LVTourCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.cellPic=@"";
        cell.cellThumb=@"";
        cell.cellTime=@"";
        cell.cellTitle=@"";
        cell.cellUserName=@"";

        NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
        cell.cellPic=[NSString stringWithFormat:@"http://pic.lvmama.com/pics/%@",[dict objectForKey:@"thumb"]];
        cell.cellThumb=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"userImg"];
        cell.cellTitle=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        cell.cellUserName=[dict objectForKey:@"username"];
        
        return cell;
    }else
    {
        static NSString *cellName=@"cell";
        LVDestinationCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[LVDestinationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
        }
        if (_desDataArray.count) {
            cell.array=_desDataArray;
        }
        return cell;
    }
}

-(void)destination:(NSInteger)number
{
    TourDestinationDetailViewController *detail=[[TourDestinationDetailViewController alloc]init];
    detail.ID=[[_scrollTopArray objectAtIndex:(number-100)] objectForKey:@"objectId"];
    detail.deTitle=[[_scrollTopArray objectAtIndex:(number-100)] objectForKey:@"title"];
    [self.navigationController pushViewController:detail animated:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_LVTableView) {
        return _dataArray.count;
    }else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_LVTableView)
        return 305;
    else
        if (iPhone6Plus) {
            return 410;
        }else
        {
            return 300;
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_LVTableView) {
        TourRecordDetailController *re=[[TourRecordDetailController alloc]init];
        re.ID=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"tripId"];
        [self.navigationController pushViewController:re animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (-_LVTableView.bounds.size.height+_LVTableView.contentSize.height<scrollView.contentOffset.y&&_hasNext==YES) {
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
                label.textAlignment = NSTextAlignmentCenter;
                [footView addSubview:label];
                UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
                [footView addSubview:activity];
                activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
                [activity startAnimating];
                _page++;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourRecordDownloadFinish) name:[NSString stringWithFormat:TOURRECORD,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOURRECORD,_page] and:4];

            }
        }
    }
}
#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOURRECORD,_page] and:4];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_storeHouseRefreshControl scrollViewDidEndDragging];
}

@end
