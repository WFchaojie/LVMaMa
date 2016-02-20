//
//  TourRelatedViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/9/19.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "TourRelatedViewController.h"
#import "TourRelatedCell.h"
#import "ProductInfoViewController.h"

@interface TourRelatedViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *freeHead;
@property(nonatomic,strong)UIView *groupHead;
@property(nonatomic,strong)UIView *ticketHead;

@property(nonatomic,strong)UITableView *freeTableView;
@property(nonatomic,strong)UITableView *groupTableView;
@property(nonatomic,strong)UITableView *ticketTableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArrayGroup;
@property(nonatomic,strong)NSMutableArray *dataArrayTicket;

@property(nonatomic,strong)CBHomeRefreshControl *storeHouseRefreshControl;
@property(nonatomic,strong)CBHomeRefreshControl *groupStoreHouseRefreshControl;
@property(nonatomic,strong)CBHomeRefreshControl *ticketStoreHouseRefreshControl;

@property(nonatomic,assign)int page;
@property(nonatomic,assign)int groupPage;
@property(nonatomic,assign)int ticketPage;

//用来判断防止page一直++
@property(nonatomic,assign)int countPage;
@property(nonatomic,assign)int groupCountPage;
@property(nonatomic,assign)int ticketCountPage;

@property(nonatomic,assign)BOOL hasNext;
@property(nonatomic,assign)BOOL groupHasNext;
@property(nonatomic,assign)BOOL ticketHasNext;

@property(nonatomic,strong)UIScrollView *backScrollView;

@end


@implementation TourRelatedViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!_freeTableView) {
        [self createBackScrollView];
        [self createTableView];
        [self createTicketTableView];
        [self createGroupTableView];
        [self hudShow];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page=1;
    _countPage=1;
    _hasNext=NO;
    
    _groupPage=1;
    _groupCountPage=1;
    _groupHasNext=NO;
    
    _ticketPage=1;
    _ticketCountPage=1;
    _ticketHasNext=NO;
    
    self.title=@"推荐购买产品";
    [self leftButton];
    [self createHeaderView];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page] and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourFreeDownloadFinish) name:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page] object:nil];
    
    NSLog(@"%@",[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page]);
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_GROUP,_groupPage] and:4];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourGroupDownloadFinish) name:[NSString stringWithFormat:TOUR_GROUP,_groupPage] object:nil];
    
    NSLog(@"%@",[NSString stringWithFormat:TOUR_GROUP,_groupPage]);
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_TICKET,_ticketPage] and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourTicketDownloadFinish) name:[NSString stringWithFormat:TOUR_TICKET,_ticketPage] object:nil];
    
    
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _dataArrayGroup=[[NSMutableArray alloc]initWithCapacity:0];
    _dataArrayTicket=[[NSMutableArray alloc]initWithCapacity:0];

}

-(void)TourTicketDownloadFinish
{
    if (_ticketPage==1) {
        _dataArrayTicket=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_TICKET,_ticketPage]];
    }else
    {
        [_dataArrayTicket addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_TICKET,_ticketPage]]];
    }
    
    _ticketHasNext=[[[_dataArrayTicket lastObject] objectForKey:@"hasNext"]boolValue];
    [_dataArrayTicket removeObject:[_dataArrayTicket lastObject]];
    
    if (_ticketTableView.tableFooterView) {
        UIView *footView=_ticketTableView.tableFooterView;
        for (UIView *foot in footView.subviews) {
            [foot removeFromSuperview];
        }
        [footView removeFromSuperview];
    }
    
    if (_ticketHasNext==NO) {
        UIView *footView;
        if (_ticketTableView.tableFooterView) {
            footView=_ticketTableView.tableFooterView;
        }
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width, 30)];
        _ticketTableView.tableFooterView=footView;
        UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
        label.text=@"已经加载显示完全部内容";
        label.textColor=[UIColor grayColor];
        label.font=[UIFont boldSystemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        [footView addSubview:label];
    }
    
    [self hudHide];
    _ticketTableView.alpha=1;
    [_ticketTableView reloadData];
    if (_ticketPage!=1&&_ticketPage!=_ticketCountPage) {
        _ticketCountPage++;
    }
    if (_dataArrayTicket.count==0) {
        if(_ticketTableView.tableFooterView)
        {
            UIView *foot=_ticketTableView.tableFooterView;
            [foot removeFromSuperview];
            _ticketTableView.tableFooterView=nil;
        }
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30)];
        view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _ticketTableView.tableFooterView=view;
        UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lvDefault.png"]];
        logo.frame=CGRectMake(0, 160, self.view.bounds.size.width, 55);
        [view addSubview:logo];
        logo.contentMode=UIViewContentModeCenter;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 55+160+10, self.view.bounds.size.width, 20)];
        label.text=@"没有找到相关数据";
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        [view addSubview:label];
    }
}

-(void)TourGroupDownloadFinish
{
    if (_groupPage==1) {
        _dataArrayGroup=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_GROUP,_groupPage]];
    }else
    {
        [_dataArrayGroup addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_GROUP,_groupPage]]];
    }
    
    _groupHasNext=[[[_dataArrayGroup lastObject] objectForKey:@"hasNext"]boolValue];
    [_dataArrayGroup removeObject:[_dataArrayGroup lastObject]];
    
    if (_groupTableView.tableFooterView) {
        UIView *footView=_groupTableView.tableFooterView;
        for (UIView *foot in footView.subviews) {
            [foot removeFromSuperview];
        }
        [footView removeFromSuperview];
    }
    
    if (_groupHasNext==NO) {
        UIView *footView;
        if (_groupTableView.tableFooterView) {
            footView=_groupTableView.tableFooterView;
        }
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width, 30)];
        _groupTableView.tableFooterView=footView;
        UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
        label.text=@"已经加载显示完全部内容";
        label.textColor=[UIColor grayColor];
        label.font=[UIFont boldSystemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        [footView addSubview:label];
    }
    
    [self hudHide];
    _groupTableView.alpha=1;
    [_groupTableView reloadData];
    if (_groupPage!=1&&_groupPage!=_groupCountPage) {
        _groupCountPage++;
    }
}

-(void)TourFreeDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page]]];
    }
    
    _hasNext=[[[_dataArray lastObject] objectForKey:@"hasNext"]boolValue];
    [_dataArray removeObject:[_dataArray lastObject]];
    
    if (_freeTableView.tableFooterView) {
        UIView *footView=_freeTableView.tableFooterView;
        for (UIView *foot in footView.subviews) {
            [foot removeFromSuperview];
        }
        [footView removeFromSuperview];
    }
    
    if (_hasNext==NO) {
        UIView *footView;
        if (_freeTableView.tableFooterView) {
            footView=_freeTableView.tableFooterView;
        }
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width, 30)];
        _freeTableView.tableFooterView=footView;
        UILabel *label=[[UILabel alloc]initWithFrame:footView.bounds];
        label.text=@"已经加载显示完全部内容";
        label.textColor=[UIColor grayColor];
        label.font=[UIFont boldSystemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        [footView addSubview:label];
    }
    
    [self hudHide];
    _freeTableView.alpha=1;
    [_freeTableView reloadData];
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}

-(void)createHeaderView
{
    if (_headView.bounds.size.height!=40) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,40)];
        _headView.userInteractionEnabled=YES;
        _headView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_headView];
        UIButton *ticket=[UIButton buttonWithType:UIButtonTypeCustom];
        ticket.frame=CGRectMake(0, 0, self.view.bounds.size.width/3, _headView.bounds.size.height);
        [ticket addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        ticket.tag=100;
        
        UILabel *ticketLabel=[[UILabel alloc]initWithFrame:ticket.frame];
        ticketLabel.text=@"自由行";
        ticketLabel.userInteractionEnabled=YES;
        [_headView addSubview:ticketLabel];
        ticketLabel.textColor=[UIColor grayColor];
        ticketLabel.textAlignment=NSTextAlignmentCenter;
        ticketLabel.font=[UIFont systemFontOfSize:12];
        [ticketLabel addSubview:ticket];
        
        
        UIButton *introduction=[UIButton buttonWithType:UIButtonTypeCustom];
        introduction.frame=CGRectMake(0, 0, self.view.bounds.size.width/3, _headView.bounds.size.height);
        [introduction addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        introduction.tag=101;
        
        UILabel *vacaLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, _headView.bounds.size.height)];
        vacaLabel.text=@"跟团游";
        vacaLabel.userInteractionEnabled=YES;
        [_headView addSubview:vacaLabel];
        vacaLabel.textColor=[UIColor grayColor];
        vacaLabel.textAlignment=NSTextAlignmentCenter;
        vacaLabel.font=[UIFont systemFontOfSize:12];
        [vacaLabel addSubview:introduction];
        
        UIButton *comment=[UIButton buttonWithType:UIButtonTypeCustom];
        comment.frame=CGRectMake(0, 0, self.view.bounds.size.width/3, _headView.bounds.size.height);
        [comment addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        comment.tag=102;
        
        UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/3*2, 0, self.view.bounds.size.width/3, _headView.bounds.size.height)];
        commentLabel.text=@"景点门票";
        commentLabel.userInteractionEnabled=YES;
        [_headView addSubview:commentLabel];
        commentLabel.textColor=[UIColor grayColor];
        commentLabel.textAlignment=NSTextAlignmentCenter;
        commentLabel.font=[UIFont systemFontOfSize:12];
        [commentLabel addSubview:comment];
        
        ticket.selected=YES;
        ticketLabel.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
        
        UIImageView *lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        lineSe.frame=CGRectMake(0,_headView.bounds.size.height-1, self.view.bounds.size.width, 1);
        lineSe.alpha=0.3;
        [_headView addSubview:lineSe];
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabLeftSel.png"]];
        line.frame=CGRectMake(ticketLabel.center.x-17, _headView.bounds.size.height-3, 34, 3);
        [_headView addSubview:line];
    }
}

-(void)createBackScrollView
{
    if (!_backScrollView) {
        _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height)];
        _backScrollView.contentSize=CGSizeMake(self.view.bounds.size.width*3, 0);
        _backScrollView.pagingEnabled=YES;
        _backScrollView.delegate=self;
        _backScrollView.showsHorizontalScrollIndicator=NO;
        _backScrollView.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_backScrollView];
    }
}

-(void)sectionClick:(UIButton *)button
{
    for (UILabel *label in button.superview.superview.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor grayColor];
            for (UIButton *btn in label.subviews) {
                btn.selected=NO;
            }
        }
    }
    
    for (UIImageView *line in button.superview.superview.subviews) {
        if ([line isKindOfClass:[UIImageView class]]) {
            if (line.frame.size.height==3) {
                [UIView animateWithDuration:0.2f animations:^{
                    if (button.tag==100) {
                        line.frame=CGRectMake(button.superview.center.x-17, _headView.bounds.size.height-3, 35, 3);
                    }else if (button.tag==101)
                    {
                        line.frame=CGRectMake(button.superview.center.x-17, _headView.bounds.size.height-3, 35, 3);
                    }else if (button.tag==102)
                    {
                        line.frame=CGRectMake(button.superview.center.x-22, _headView.bounds.size.height-3, 45, 3);
                    }
                }];
            }
        }
    }
    
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    if (button.tag==100) {
        
        [_backScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }else if (button.tag==101)
    {
        [_backScrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:NO];
    }
    else{
        [_backScrollView setContentOffset:CGPointMake(self.view.bounds.size.width*2, 0) animated:NO];
    }

}

-(void)createTableView
{
    if(!_freeTableView)
    {
        _freeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-100) style:UITableViewStylePlain];
        _freeTableView.delegate=self;
        _freeTableView.dataSource=self;
        _freeTableView.alpha=0;
        [_backScrollView addSubview:_freeTableView];
        _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_freeTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    }
}

-(void)createGroupTableView
{
    _groupTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _groupTableView.delegate=self;
    _groupTableView.dataSource=self;
    _groupTableView.alpha=0;
    _groupStoreHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_groupTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    [_backScrollView addSubview:_groupTableView];
}

-(void)createTicketTableView
{
    _ticketTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _ticketTableView.delegate=self;
    _ticketTableView.dataSource=self;
    [_backScrollView addSubview:_ticketTableView];
    _ticketStoreHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_ticketTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_freeTableView) {
        static NSString *cellIde=@"cellFree";
        TourRelatedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[TourRelatedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.Lvpic=@"";
        cell.LvDetail=@"";
        NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
        cell.Lvpic=[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"imageThumb"]];
        cell.LvDetail=[dict objectForKey:@"productName"];
        return cell;
        
    }else if(tableView==_groupTableView)
    {
        static NSString *cellIde=@"cellFree";
        TourRelatedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[TourRelatedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.Lvpic=@"";
        cell.LvDetail=@"";
        NSDictionary *dict=[_dataArrayGroup objectAtIndex:indexPath.row];
        cell.Lvpic=[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"imageThumb"]];
        cell.LvDetail=[dict objectForKey:@"productName"];
        return cell;
    }else if (tableView==_ticketTableView)
    {
        static NSString *cellIde=@"cellFree";
        TourRelatedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[TourRelatedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.Lvpic=@"";
        cell.LvDetail=@"";
        NSDictionary *dict=[_dataArrayTicket objectAtIndex:indexPath.row];
        cell.Lvpic=[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"imageThumb"]];
        cell.LvDetail=[dict objectForKey:@"productName"];
        return cell;
    }else
    {
        static NSString *cellIde=@"cellRelated";
        TourRelatedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[TourRelatedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.Lvpic=@"";
        cell.LvDetail=@"";
        NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
        cell.Lvpic=[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"imageThumb"]];
        cell.LvDetail=[dict objectForKey:@"productName"];
        return  cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_freeTableView==tableView) {
        if (_dataArray.count!=0) {
            NSDictionary *dic=[_dataArray objectAtIndex:indexPath.row];
            NSString *string=[dic objectForKey:@"productName"];
            CGSize size=CGSizeMake(self.view.bounds.size.width-30, 1000);
            UIFont *font=[UIFont systemFontOfSize:10];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing=1;
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            return  165+actualSize.height;
        }else
        {
            return 200;
        }
    }else if (_groupTableView==tableView)
    {
        if (_dataArrayGroup.count!=0) {
            NSDictionary *dic=[_dataArrayGroup objectAtIndex:indexPath.row];
            NSString *string=[dic objectForKey:@"productName"];
            CGSize size=CGSizeMake(self.view.bounds.size.width-30, 1000);
            UIFont *font=[UIFont systemFontOfSize:10];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing=1;
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            return  165+actualSize.height;
        }else
        {
            return 200;
        }
    }else if (_ticketTableView==tableView)
    {
        if (_dataArrayTicket.count!=0) {
            NSDictionary *dic=[_dataArrayTicket objectAtIndex:indexPath.row];
            NSString *string=[dic objectForKey:@"productName"];
            CGSize size=CGSizeMake(self.view.bounds.size.width-30, 1000);
            UIFont *font=[UIFont systemFontOfSize:10];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing=1;
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            return  165+actualSize.height;
        }else
        {
            return 200;
        }
    }
    else
        return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_freeTableView==tableView) {
        return _dataArray.count;
    }else if (_groupTableView==tableView)
    {
        return _dataArrayGroup.count;
    }else if (_ticketTableView==tableView)
    {
        return _dataArrayTicket.count;
    }
    else return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_freeTableView) {
        [_storeHouseRefreshControl scrollViewDidScroll];
        if (-_freeTableView.bounds.size.height+_freeTableView.contentSize.height<scrollView.contentOffset.y&&_hasNext==YES) {
            if (_page==_countPage) {
                UIView *footView;
                if (_freeTableView.tableFooterView) {
                    footView=_freeTableView.tableFooterView;
                }
                footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
                footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
                _freeTableView.tableFooterView=footView;
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
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourFreeDownloadFinish) name:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page] and:4];
                
            }
        }
    }else if (scrollView==_groupTableView) {
        [_groupStoreHouseRefreshControl scrollViewDidScroll];
        if (-_groupTableView.bounds.size.height+_groupTableView.contentSize.height<scrollView.contentOffset.y&&_groupHasNext==YES) {
            if (_groupPage==_groupCountPage) {
                UIView *footView;
                if (_groupTableView.tableFooterView) {
                    footView=_groupTableView.tableFooterView;
                }
                footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
                footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
                _groupTableView.tableFooterView=footView;
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
                _groupPage++;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourGroupDownloadFinish) name:[NSString stringWithFormat:TOUR_GROUP,_groupPage] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_GROUP,_groupPage] and:4];
                
            }
        }
    }else if (scrollView==_ticketTableView) {
        [_ticketStoreHouseRefreshControl scrollViewDidScroll];
        if (-_ticketTableView.bounds.size.height+_ticketTableView.contentSize.height<scrollView.contentOffset.y&&_hasNext==YES) {
            if (_ticketPage==_ticketCountPage) {
                UIView *footView;
                if (_ticketTableView.tableFooterView) {
                    footView=_ticketTableView.tableFooterView;
                }
                footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
                footView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
                _ticketTableView.tableFooterView=footView;
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
                _ticketPage++;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourTicketDownloadFinish) name:[NSString stringWithFormat:TOUR_TICKET,_ticketPage] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_TICKET,_ticketPage] and:4];
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
    if (_backScrollView.contentOffset.x/self.view.bounds.size.width==0) {
        _page=1;
        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECOMMEND_FREE,_page] and:4];
        [_storeHouseRefreshControl finishingLoading];
    }else if (_backScrollView.contentOffset.x/self.view.bounds.size.width==1)
    {
        _groupPage=1;
        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_GROUP,_groupPage] and:4];
        [_groupStoreHouseRefreshControl finishingLoading];
    }else
    {
        _ticketPage=1;
        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_TICKET,_ticketPage] and:4];
        [_ticketStoreHouseRefreshControl finishingLoading];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_backScrollView.contentOffset.x/self.view.bounds.size.width==0) {
        [_storeHouseRefreshControl scrollViewDidEndDragging];
    }else if (_backScrollView.contentOffset.x/self.view.bounds.size.width==1)
    {
        [_groupStoreHouseRefreshControl scrollViewDidEndDragging];
    }else
    {
        [_ticketStoreHouseRefreshControl scrollViewDidEndDragging];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_backScrollView) {
        [self changeHeadButton:scrollView.contentOffset.x/self.view.bounds.size.width+100];
    }
}


-(void)changeHeadButton:(int)type
{
    UIButton *button;

    for (UILabel *label in _headView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor grayColor];
            for (UIButton *btn in label.subviews) {
                btn.selected=NO;
                if (btn.tag==type) {
                    button=btn;
                }
            }
        }
    }

    
    for (UIImageView *line in _headView.subviews) {
        if ([line isKindOfClass:[UIImageView class]]) {
            if (line.frame.size.height==3) {
                [UIView animateWithDuration:0.2f animations:^{
                    if (button.tag==100) {
                        line.frame=CGRectMake(button.superview.center.x-17, _headView.bounds.size.height-3, 35, 3);
                    }else if (button.tag==101)
                    {
                        line.frame=CGRectMake(button.superview.center.x-17, _headView.bounds.size.height-3, 35, 3);
                    }else if (button.tag==102)
                    {
                        line.frame=CGRectMake(button.superview.center.x-22, _headView.bounds.size.height-3, 45, 3);
                    }
                }];
            }
        }
    }
    
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_backScrollView.contentOffset.x/self.view.bounds.size.width==0) {
        _page=1;
        
        NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
        ProductInfoViewController *info=[[ProductInfoViewController alloc]init];
        info.productId=[[dict objectForKey:@"productId"] intValue];
        [self.navigationController pushViewController:info animated:YES];
        
    }else if (_backScrollView.contentOffset.x/self.view.bounds.size.width==1)
    {
        
        NSDictionary *dict=[_dataArrayGroup objectAtIndex:indexPath.row];
        ProductInfoViewController *info=[[ProductInfoViewController alloc]init];
        info.productId=[[dict objectForKey:@"productId"] intValue];
        [self.navigationController pushViewController:info animated:YES];
    }else
    {
        
        NSDictionary *dict=[_dataArrayTicket objectAtIndex:indexPath.row];
        ProductInfoViewController *info=[[ProductInfoViewController alloc]init];
        info.productId=[[dict objectForKey:@"productId"] intValue];
        [self.navigationController pushViewController:info animated:YES];
    }
}


@end
