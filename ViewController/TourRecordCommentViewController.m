//
//  TourRecordCommentViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "TourRecordCommentViewController.h"
#import "LVTourRecordCommentCell.h"
#import "CBHomeRefreshControl.h"
@interface TourRecordCommentViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation TourRecordCommentViewController{
    UITableView *_LVTableView;
    CBHomeRefreshControl *_storeHouseRefreshControl;
    int _page;
    //用来判断防止page一直++
    int _countPage;
    BOOL _hasNext;
    NSMutableArray *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _countPage=1;
    _hasNext=YES;
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page] and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourRecordCommentDownloadFinish) name:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page] object:nil];
    
    [self createTableView];
    [self leftButton];
    self.title=@"评论游记";
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
}
-(void)TourRecordCommentDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page]]];
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
    [_LVTableView reloadData];
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}
-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    [self.view addSubview:_LVTableView];
    _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
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
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page] and:4];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourRecordCommentDownloadFinish) name:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page] object:nil];
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde=@"cell";
    LVTourRecordCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[LVTourRecordCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    cell.cellTime.text=@"";
    cell.cellUserPic.image=NULL;
    cell.cellComment.text=@"";
    cell.time=@"";
    cell.userPic=@"";
    cell.comment=@"";
    cell.userName=@"";
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    cell.time=[dict objectForKey:@"createTime"];
    cell.userPic=[dict objectForKey:@"userImage"];
    cell.comment=[dict  objectForKey:@"memo"];
    cell.userName=[dict objectForKey:@"userName"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight:indexPath];
}
-(NSInteger)cellHeight:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[_dataArray objectAtIndex:indexPath.row];
    NSString *string=[NSString stringWithFormat:@"%@：%@",[dic objectForKey:@"userName"],[dic objectForKey:@"memo"]];
    CGSize size=CGSizeMake(self.view.bounds.size.width-30, 1000);
    UIFont *font=[UIFont systemFontOfSize:11];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return actualSize.height+25;
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

#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECORD_COMMENT,self.typeID,_page] and:4];
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
