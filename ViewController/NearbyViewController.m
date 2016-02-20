//
//  NearbyViewController.m
//  LvMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NearbyViewController.h"
#import "LVDownLoadManager.h"
#import "LVNearByCell.h"
#import "lvmamaAppDelegate.h"
#import "CBHomeRefreshControl.h"
#import "NearDetailViewController.h"
#import "MapViewController.h"

@interface NearbyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NearbyViewController
{
    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    int _page;
    //用来判断防止page一直++
    int _countPage;
    //判断数据是否全部加载
    CBHomeRefreshControl *_storeHouseRefreshControl;
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
    self.navigationController.navigationBarHidden=NO;
    if (!_LVTableView) {
        [self createTableView];
        [self hudShow];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    self.title=@"周边";
    [self rightBtn:@"地图"];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NearBy2,_page] and:5];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NearByDownloadFinish) name:[NSString stringWithFormat:NearBy2,_page] object:nil];
   // NSLog(@"%@",[NSString stringWithFormat:NearBy,_page]);
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.edgesForExtendedLayout = UIRectEdgeNone;

	// Do any additional setup after loading the view.
}

-(void)createTableView
{
    if (!_LVTableView) {
        _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _LVTableView.delegate=self;
        _LVTableView.dataSource=self;
        [self.view addSubview:_LVTableView];
        _LVTableView.alpha=0.0;
        
        _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    }
}

-(void)rightClick
{
    NSLog(@"点击地图");
    MapViewController *map=[[MapViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
}

-(void)mapClick
{
    
}

-(void)NearByDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NearBy2,_page]];
    }else
    {
        if (_page!=_countPage) {
            NSMutableArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NearBy2,_page]];
                [_dataArray addObjectsFromArray:array];
            }
    }
    [self hudHide];
    _LVTableView.alpha=1.0;
    [_LVTableView reloadData];
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_LVTableView) {
        [_storeHouseRefreshControl scrollViewDidScroll];
        if (-_LVTableView.bounds.size.height+_LVTableView.contentSize.height<scrollView.contentOffset.y) {
            if (_page==_countPage) {
                    _page++;
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NearBy2,_page] and:5];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NearByDownloadFinish) name:[NSString stringWithFormat:NearBy2,_page] object:nil];
                }
            }
        }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellNear";
    LVNearByCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[LVNearByCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.cellPic=nil;
    cell.cellDistance=@"";
    cell.cellDetail=@"";
    cell.cellTitle=@"";
    cell.cellPlaceType=@"";
    cell.cellWifi=NO;
    cell.cellPark=NO;
    cell.cellPrice=@"";
    cell.cellPriceBack=@"";
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    cell.cellPic=[dict objectForKey:@"images"];
    cell.cellTitle=[dict objectForKey:@"name"];
    cell.cellDetail=[dict objectForKey:@"address"];
    cell.cellDistance=[dict objectForKey:@"distance"];
    cell.cellPlaceType=[dict objectForKey:@"placeType"];
    cell.cellWifi=[[dict objectForKey:@"freeWifi"] boolValue];
    cell.cellPark=[[dict objectForKey:@"freePark"] boolValue];
    cell.cellPrice=[NSString stringWithFormat:@"￥%@起",[dict objectForKey:@"sellPrice"]];
    //cell.cellPriceBack=[NSString stringWithFormat:@" 运￥%@ ",[dict objectForKey:@"cashBack"]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];

    NearDetailViewController *nearDetail=[[NearDetailViewController alloc]init];
    nearDetail.ProductID=[dict objectForKey:@"hotelId"];
    [self.navigationController pushViewController:nearDetail animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone6Plus) {
        return 75+20;
    }else
    {
        return 75;
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
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NearBy2,_page] and:5];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==_LVTableView) {
        [_storeHouseRefreshControl scrollViewDidEndDragging];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
