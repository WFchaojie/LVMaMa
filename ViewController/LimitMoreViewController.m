//
//  LimitMoreViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/7.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LimitMoreViewController.h"
#import "LimitMoewCell.h"
#import "LimitInfoViewController.h"
#define Width 8
@interface LimitMoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LimitMoreViewController
{
    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    CBHomeRefreshControl *_storeHouseRefreshControl;
    int _page;
    //用来判断防止page一直++
    int _countPage;
    BOOL _hasNext;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
    if (!_LVTableView) {
        [self createTableView];
        [self hudShow];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    _hasNext=NO;
    self.title=@"精品秒杀";
    [self leftButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(limitMoreDownloadFinish) name:[NSString stringWithFormat:LIMIT_MORE,_page] object:nil];

    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:LIMIT_MORE,_page] and:16];
    NSLog(@"%@",[NSString stringWithFormat:LIMIT_MORE,_page]);
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view.
}

-(void)limitMoreDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:LIMIT_MORE,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:LIMIT_MORE,_page]]];
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
    
    if (_hasNext==NO) {
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

-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    _LVTableView.alpha=0;
    [self.view addSubview:_LVTableView];
    _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];

    if ([_LVTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_LVTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_LVTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_LVTableView setLayoutMargins: UIEdgeInsetsZero];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde=@"cellMore";
    LimitMoewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[LimitMoewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.pic=@"";
    cell.productName=@"";
    cell.discountV200=@"";
    cell.address=@"";
    cell.sellPriceYuan=@"";
    cell.marketPriceYuan=@"";
    cell.stockCount=@"";
    cell.recommandName=@"";
    cell.restTime=@"";
    NSDictionary *moreDict=[_dataArray objectAtIndex:indexPath.row];
    
    cell.pic=[moreDict objectForKey:@"smallImage"];
    cell.productName=[moreDict objectForKey:@"productName"];
    cell.discountV200=[NSString stringWithFormat:@"%.1f折",[[moreDict objectForKey:@"discountV200"] floatValue]];
    cell.address=[NSString stringWithFormat:@"%@ | %@",[moreDict objectForKey:@"productTypeV2"],[moreDict objectForKey:@"departurePlace"]];
    cell.sellPriceYuan=[NSString stringWithFormat:@"%d",[[moreDict objectForKey:@"sellPriceYuan"] intValue]];
    cell.marketPriceYuan=[NSString stringWithFormat:@"%d",[[moreDict objectForKey:@"marketPriceYuan"] intValue]];
    cell.stockCount=[NSString stringWithFormat:@"%d",[[moreDict objectForKey:@"stockCount"] intValue]];
    cell.recommandName=[moreDict objectForKey:@"recommandName"];
    cell.restTime=[moreDict objectForKey:@"secKillEndTime"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *moreDict=[_dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[moreDict objectForKey:@"suppGoodsId"]);
    LimitInfoViewController *info=[[LimitInfoViewController alloc]init];
    info.productId=[moreDict objectForKey:@"productId"];
    info.suppGoodsId=[moreDict objectForKey:@"suppGoodsId"];
    info.branchType=[moreDict objectForKey:@"branchType"];
    [self.navigationController pushViewController:info animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *moreDict=[_dataArray objectAtIndex:indexPath.row];
    NSString *string=[NSString stringWithFormat:@"      %@",[moreDict objectForKey:@"productName"]];
    CGSize size=CGSizeMake(self.view.bounds.size.width-Width*2, 1000);
    UIFont *font=[UIFont systemFontOfSize:13];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;

    NSString *recommandName=[moreDict objectForKey:@"recommandName"];
    NSLog(@"%@",recommandName);
    CGSize reSize=CGSizeMake(self.view.bounds.size.width-Width*2, 1000);
    UIFont *reFont=[UIFont systemFontOfSize:13];
    NSDictionary *reDict=[NSDictionary dictionaryWithObjectsAndKeys:reFont,NSFontAttributeName,nil];
    CGSize reActualSize=[recommandName boundingRectWithSize:reSize options:NSStringDrawingUsesLineFragmentOrigin attributes:reDict context:nil].size;
    NSLog(@"%.f",reActualSize.height);

    return actualSize.height+150+reActualSize.height+79+10+5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview分割线左边有空隙
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_LVTableView) {
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
                label.textAlignment=NSTextAlignmentCenter;
                [footView addSubview:label];
                UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
                [footView addSubview:activity];
                activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
                [activity startAnimating];
                _page++;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(limitMoreDownloadFinish) name:[NSString stringWithFormat:LIMIT_MORE,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:LIMIT_MORE,_page] and:16];
                
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
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:LIMIT_MORE,_page] and:16];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_storeHouseRefreshControl scrollViewDidEndDragging];
}


@end
