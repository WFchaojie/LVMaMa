//
//  CommentViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "CommentViewController.h"
#import "LimitCommentCell.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,PicComment>

@end

@implementation CommentViewController
{
    UIView *_headerView;
    UIView *_headView;
    UIView *_footerView;
    UIView *_moreView;
    CBHomeRefreshControl *_storeHouseRefreshControl;
    int _page;
    //用来判断防止page一直++
    int _countPage;
    BOOL _hasNext;

    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    UIView *_blackView;
    UIScrollView *_picScrollView;
    UIImageView *_capture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page=1;
    _countPage=1;
    _hasNext=NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentDownLoadFinish) name:[NSString stringWithFormat:COMMENT_URL,_page] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:COMMENT_URL,_page] and:4];
    
    [self leftButton];
    self.title=@"用户点评";
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    if(!_LVTableView)
    {
        [self createTableView];
        [self hudShow];
    }
}

-(void)commentDownLoadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:COMMENT_URL,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:COMMENT_URL,_page]]];
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
    if (!_LVTableView) {
        _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
        _LVTableView.delegate=self;
        _LVTableView.dataSource=self;
        [self.view addSubview:_LVTableView];
        _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
        _LVTableView.alpha=0;
        
        if ([_LVTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_LVTableView setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([_LVTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_LVTableView setLayoutMargins: UIEdgeInsetsZero];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"Comment";
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
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
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

-(void)picClick:(NSArray *)array andTheCount:(int)count
{
    [self animationWithPicClick:array andTheCurrent:count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height=0;
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)animationWithPicClick:(NSArray *)pic andTheCurrent:(int)current
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
    
    [self createPicScrollView:pic andTheCurrent:current];
    
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

-(void)createPicScrollView:(NSArray *)pic andTheCurrent:(int)current
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
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentDownLoadFinish) name:[NSString stringWithFormat:COMMENT_URL,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:COMMENT_URL,_page] and:4];
                
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
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:COMMENT_URL,_page] and:4];
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
