//
//  HomeDetailViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "LVDownLoadManager.h"
#import "LVHomeTicketHeadCell.h"
#import "LVHomeTicketInfoCell.h"
#import "LVHomeIntroCell.h"
#import "LVHomeIntroOtherCell.h"
#import "LVHomeCommentCell.h"
#import "LogInViewController.h"
#import "HomePicViewController.h"
#import "CommentViewController.h"
@interface HomeDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ReturnHeight,hotelDetail,Pay,PicComment>
@property (nonatomic,assign) NSInteger trackSection;
@property (nonatomic,assign) NSInteger trackRow;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrol;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UIView *moreView;
@property (nonatomic,strong) UITableView *LVTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
//header和footer
@property (nonatomic,strong) NSMutableArray *homeInfoArray;
@property (nonatomic,strong) NSMutableArray *commentArray;
//景区须知是否变长
@property (nonatomic,assign) BOOL longer;
//判断cell是否是展开的
@property (nonatomic,assign) BOOL singleOpen;
@property (nonatomic,assign) BOOL groupOpen;
//用来储存tableview数据
@property (nonatomic,strong) NSMutableArray *openArray;
@property (nonatomic,assign) int height;
@property (nonatomic,assign) int hotelHeight;
@property (nonatomic,assign) int commentHeight;
//景点介绍的点击展开判断
@property (nonatomic,assign) BOOL isIntroduct;
@property (nonatomic,strong) UIImageView *arrow;
//计算tableview的row
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) UIView *blackView;
@property (nonatomic,strong) UIScrollView *picScrollView;
@property (nonatomic,strong) UIImageView *capture;

@end

@implementation HomeDetailViewController


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
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    if(!_LVTableView)
    {
        [self createTableView];
        [self hudShow];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title=@"景点详情";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoDownloadFinish) name:[NSString stringWithFormat:HOME_CELL_INFO,self.ID] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:HOME_CELL_INFO,self.ID] and:6];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ticketDownloadFinish) name:[NSString stringWithFormat:HOME_CELL_TICKET,self.ID] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:HOME_CELL_TICKET,self.ID] and:7];
    NSLog(@"ticket=%@",[NSString stringWithFormat:HOME_CELL_TICKET,self.ID]);
    NSLog(@"%@",[NSString stringWithFormat:HOME_CELL_INFO,self.ID]);
    
    _singleOpen=YES;
    _groupOpen=YES;
    _longer=NO;

    [self leftButton];
    [self rightButton];
    _count=0;
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _openArray=[[NSMutableArray alloc]initWithCapacity:0];

	// Do any additional setup after loading the view.
}
-(void)rightButton
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[NSArray arrayWithObjects:@"placeDetailUncollected.png",@"shareBtn.png",nil];
    for (int i=1; i>=0; i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 32, 32);
        [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
        button.tag=100+i;
        [items addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems=items;
}

-(void)rightClick:(UIButton *)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}

-(void)infoDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:HOME_CELL_INFO,self.ID]];
    _homeInfoArray=[[NSMutableArray alloc]initWithArray:array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentDownloadFinish) name:[NSString stringWithFormat:HOME_CELL_COMMENT,[[_homeInfoArray objectAtIndex:0] objectForKey:@"mainDestId"]] object:nil];
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:HOME_CELL_COMMENT,[[_homeInfoArray objectAtIndex:0] objectForKey:@"mainDestId"]] and:4];
    NSLog(@"%@",[NSString stringWithFormat:HOME_CELL_COMMENT,[[_homeInfoArray objectAtIndex:0] objectForKey:@"mainDestId"]]);

    
    [self createTop:array];
    [self createFooterView:array];
}

-(void)commentDownloadFinish
{
    _commentArray=[[NSMutableArray alloc]initWithCapacity:0];
    _commentArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:HOME_CELL_COMMENT,[[_homeInfoArray objectAtIndex:0] objectForKey:@"mainDestId"]]];
    NSLog(@"comment=%@",[NSString stringWithFormat:HOME_CELL_COMMENT,[[_homeInfoArray objectAtIndex:0] objectForKey:@"mainDestId"]]);
}

-(void)createFooterView:(NSArray *)array
{
    if (!_footerView) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 125)];
        _footerView.backgroundColor=[UIColor whiteColor];
        _LVTableView.tableFooterView=_footerView;
    }
    if (array.count) {
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        grayArear.frame=CGRectMake(0, 0, self.view.bounds.size.width, 30);
        [_footerView addSubview:grayArear];
        
        UILabel *hot=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, grayArear.bounds.size.height)];
        hot.text=@"景区须知";
        hot.font=[UIFont systemFontOfSize:12];
        [grayArear addSubview:hot];
        
        UILabel *infomation=[[UILabel alloc]initWithFrame:CGRectMake(5, 35, self.view.bounds.size.width-10, 80)];
        infomation.numberOfLines=0;
        infomation.text=[[array objectAtIndex:0]objectForKey:@"orderTips"];
        [_footerView addSubview:infomation];
        infomation.font=[UIFont systemFontOfSize:12];
        infomation.textColor=[UIColor grayColor];
        
        _arrow=[[UIImageView alloc]init];
        _arrow.frame=CGRectMake(self.view.bounds.size.width-15,120-8,12, 8);
        _arrow.image=[UIImage imageNamed:@"expandDown.png"];
        [_footerView addSubview:_arrow];
        
        UIButton *longer=[UIButton buttonWithType:UIButtonTypeCustom];
        longer.frame=infomation.frame;
        [longer addTarget:self action:@selector(getLonger) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:longer];
        
    }
}

-(void)getLonger
{
    if (_longer==NO) {
        CGSize size=CGSizeMake(self.view.bounds.size.width-10, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        NSString *str=[[_homeInfoArray objectAtIndex:0]objectForKey:@"orderTips"];
        CGSize actualSize=[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        for (UIView *view in _footerView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                ((UILabel *)view).frame=CGRectMake(5, 35, self.view.bounds.size.width-10, actualSize.height);
            }
            if ([view isKindOfClass:[UIButton class]]) {
                ((UIButton *)view).frame=CGRectMake(5, 35, self.view.bounds.size.width-10, actualSize.height);
            }
        }
        _footerView=_LVTableView.tableFooterView;
        _footerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, actualSize.height+45);
        _LVTableView.tableFooterView=_footerView;
        _longer=YES;
        _arrow.frame=CGRectMake(self.view.bounds.size.width-15,_footerView.bounds.size.height-10,12, 8);
        _arrow.image=[UIImage imageNamed:@"expandUp.png"];
    }else
    {
        for (UIView *view in _footerView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                ((UILabel *)view).frame=CGRectMake(5, 35, self.view.bounds.size.width-10, 80);
            }
            if ([view isKindOfClass:[UIButton class]]) {
                ((UIButton *)view).frame=CGRectMake(5, 35, self.view.bounds.size.width-10, 80);
            }
        }
        UIView *footerView=_LVTableView.tableFooterView;
        footerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 120);
        _LVTableView.tableFooterView=footerView;
        _longer=NO;
        _arrow.frame=CGRectMake(self.view.bounds.size.width-15,120-8,12, 8);
        _arrow.image=[UIImage imageNamed:@"expandDown.png"];
    }
    
}

-(void)ticketDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:HOME_CELL_TICKET,self.ID]];
    NSLog(@"info=%@",[NSString stringWithFormat:HOME_CELL_TICKET,self.ID]);
    for (NSMutableDictionary *dict in array) {
        if ([[dict objectForKey:@"itemDatas"] count]) {
            [_dataArray addObject:dict];
            NSMutableDictionary *openDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
            [_openArray addObject:openDict];
        }
    }
    
    [self hudHide];
    [_LVTableView reloadData];
}
-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height+self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    _LVTableView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:_LVTableView];
    if ([_LVTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_LVTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_LVTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_LVTableView setLayoutMargins: UIEdgeInsetsZero];
    }
    [self createTop:nil];
}

-(void)createTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 278)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _LVTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]init];
        if (iPhone6Plus) {
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, 200);
        }else
        {
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, 150);
        }
        _scrol.pagingEnabled=YES;
        _scrol.bounces=NO;
        _scrol.showsHorizontalScrollIndicator=NO;
        _scrol.showsVerticalScrollIndicator=NO;
        [_headerView addSubview:_scrol];
        _scrol.delegate=self;
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }
    
    if (array.count&&_scrol) {
        NSDictionary *dict=[array objectAtIndex:0];
        NSArray *topArray;
        if ([dict objectForKey:@"clientImageBaseVos"]) {
            topArray=[dict objectForKey:@"clientImageBaseVos"];
        }
        _pageControl.numberOfPages=topArray.count;
        for (int i=0; i<topArray.count; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*topArray.count, 0);
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, _scrol.bounds.size.height)];
            NSDictionary *dict=[topArray objectAtIndex:i];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"compressPicUrl"]]placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]] ;
            
            [_scrol addSubview:imageView];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=imageView.frame;
            button.tag=100+i;
            [button addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrol addSubview:button];

        }
        
        UIImageView *mapAddress=[[UIImageView alloc]initWithFrame:CGRectMake(5, _scrol.frame.size.height+8, 20, 20)];
        mapAddress.image=[UIImage imageNamed:@"mtviewspot.png"];
        [_headerView addSubview:mapAddress];
        
        UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(30, _scrol.frame.size.height+8, 200, 20)];
        if ([dict objectForKey:@"address"]) {
            address.text=[dict objectForKey:@"address"];
        }
        [_headerView addSubview:address];
        address.textColor=[UIColor grayColor];
        address.font=[UIFont boldSystemFontOfSize:12];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-20, _scrol.frame.size.height+13, 7, 10)];
        arrow.image=[UIImage imageNamed:@"cellArrow.png"];
        [_headerView addSubview:arrow];
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        line.frame=CGRectMake(0, _scrol.frame.size.height+35, self.view.bounds.size.width, 1);
        [_headerView addSubview:line];
        
        UIImageView *time=[[UIImageView alloc]initWithFrame:CGRectMake(5, _scrol.frame.size.height+41, 23, 23)];
        time.image=[UIImage imageNamed:@"myCellIcon34.png"];
        [_headerView addSubview:time];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, _scrol.frame.size.height+41, 200, 20)];
        timeLabel.text=[NSString stringWithFormat:@"开放时间: %@",[(NSDictionary *)[dict objectForKey:@"clientDestVo"] objectForKey:@"openingTime"]];
        
        [_headerView addSubview:timeLabel];
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.font=[UIFont boldSystemFontOfSize:12];
        
        UIImageView *line1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        line1.frame=CGRectMake(0, _scrol.frame.size.height+66, self.view.bounds.size.width, 1);
        [_headerView addSubview:line1];
        
        NSArray *clientServiceEnsures=[dict objectForKey:@"clientServiceEnsures"];
        
        for (int i=0; i<clientServiceEnsures.count; i++) {
            NSDictionary *dic=[clientServiceEnsures objectAtIndex:i];
            BOOL boo=[[dic objectForKey:@"checked"] boolValue];
            
            if (boo==YES) {
                UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width/4, _scrol.frame.size.height+72, self.view.bounds.size.width/4, 26)];
                pic.contentMode=UIViewContentModeCenter;
                [_headerView addSubview:pic];
                UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width/4, _scrol.frame.size.height+72+26, self.view.bounds.size.width/4, 15)];
                la.textColor=[UIColor grayColor];
                la.textAlignment=NSTextAlignmentCenter;
                la.font=[UIFont systemFontOfSize:10];
                la.text=[dic objectForKey:@"itemValue"];
                [_headerView addSubview:la];
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(i*self.view.bounds.size.width/4, _scrol.frame.size.height+72, self.view.bounds.size.width/4, 26+15);
                [button addTarget:self action:@selector(hintClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag=100+i;
                [_headerView addSubview:button];
                if ([[dic objectForKey:@"itemKey"]isEqualToString:@"ENSURING_THE_GARDEN"]) {
                    pic.image=[UIImage imageNamed:@"ensuringGarden.png"];
                }else if ([[dic objectForKey:@"itemKey"]isEqualToString:@"FAST_INTO_THE_GARDEN"])
                {
                    pic.image=[UIImage imageNamed:@"fastIntoGarden.png"];
                }else if ([[dic objectForKey:@"itemKey"]isEqualToString:@"BACK_AT_ANY_TIME"])
                {
                    pic.image=[UIImage imageNamed:@"backAnyTime.png"];
                }else if ([[dic objectForKey:@"itemKey"]isEqualToString:@"YOU_WILL_LOSE"])
                {
                    pic.image=[UIImage imageNamed:@"willLose.png"];
                }
            }
        }
        
        UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HotelWindowTopbarBg.png"]];
        grayArear.frame=CGRectMake(0, _scrol.frame.size.height+113+5, self.view.bounds.size.width, 10);
        [_headerView addSubview:grayArear];
        
        _headerView=_LVTableView.tableHeaderView;
        _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, grayArear.bounds.size.height+grayArear.frame.origin.y);
        _LVTableView.tableHeaderView=_headerView;
        
    }
}

-(void)hintClick:(UIButton *)button
{
    NSDictionary *dict=[_homeInfoArray objectAtIndex:0];
    NSArray *clientServiceEnsures=[dict objectForKey:@"clientServiceEnsures"];
    NSDictionary *item=[clientServiceEnsures objectAtIndex:button.tag-100];
    [[[UIAlertView alloc]initWithTitle:[item objectForKey:@"itemValue"] message:[item objectForKey:@"itemDesc"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
}

-(void)scrollViewClick:(UIButton *)button
{
    NSDictionary *dict=[_homeInfoArray objectAtIndex:0];
    NSArray *topArray=[dict objectForKey:@"clientImageBaseVos"];
    NSMutableArray *picArray=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<topArray.count; i++) {
        [picArray addObject:[[topArray objectAtIndex:i] objectForKey:@"compressPicUrl"]];
    }
    
    [self animationWithPicClick:picArray andTheCurrent:(int)button.tag-100];
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
            [picture sd_setImageWithURL:[NSURL URLWithString:[pic objectAtIndex:i]] placeholderImage:nil];
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
    if (scrollView==_scrol) {
        int count=scrollView.contentOffset.x/self.view.bounds.size.width;
        _pageControl.currentPage=count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        if (_dataArray.count) {
            
            int count = 0;
            int section = 0;
            
            for (NSDictionary *dict in _dataArray) {
                
                NSArray *item=[dict objectForKey:@"itemDatas"];
                    count+=item.count;
                
                if (indexPath.row<=count) {
                    self.trackRow=indexPath.row-count+[item count];
                    self.trackSection=section;
                    break;
                }
                section++;
                count++;
            }
            
            if (self.trackRow==0) {
                static NSString *cellName=@"cellHead";
                LVHomeTicketHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
                if (!cell) {
                    cell=[[LVHomeTicketHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                cell.backgroundColor=[UIColor whiteColor];
                cell.title.text=@"";
                cell.ticketTitle=@"";
                cell.pic.image=nil;
                NSDictionary *dict=[NSDictionary new];
                dict=[_dataArray objectAtIndex:self.trackSection];
                    
                cell.ticketTitle=[dict objectForKey:@"itemName"];
                return cell;
            }else
            {
                static NSString *cellName=@"cellInfo";
                LVHomeTicketInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
                if (!cell) {
                    cell=[[LVHomeTicketInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    cell.delegate=self;
                }
                cell.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
                cell.title.text=@"";
                cell.firstTag=@"";
                cell.firstTagLabel.text=@"";
                cell.lastOrderLabel.text=@"";
                cell.lastOrder=@"";
                cell.deduction=@"";
                cell.deductionLabel.text=@"";
                cell.promotionLabel.text=@"";
                cell.promotion=@"";
                cell.sellPriceLabel.text=@"";
                cell.sellPrice=0;
                cell.refund=@"";
                cell.refundLabel.text=@"";
                cell.marketPrice=0;
                NSDictionary *dict=[NSDictionary new];
                NSString *string=[NSString new];
                
                NSArray *itemDatas=[[_dataArray objectAtIndex:self.trackSection] objectForKey:@"itemDatas"];
                dict=[itemDatas objectAtIndex:self.trackRow-1];
                string= [dict objectForKey:@"goodsName"];
                if (string==NULL) {
                    string=[[[[_dataArray objectAtIndex:self.trackSection] objectForKey:@"itemDatas"] objectAtIndex:self.trackRow-1] objectForKey:@"productName"];
                }
                cell.ticketTitle=string;
                
                if ([[dict objectForKey:@"firstTagItems"] count]) {
                    cell.firstTag=[[[dict objectForKey:@"firstTagItems"] objectAtIndex:0] objectForKey:@"name"];
                }
                if ([[dict objectForKey:@"marketPrice"] intValue]!=0) {
                    cell.marketPrice=[[dict objectForKey:@"marketPrice"] intValue];
                }
                if ([[dict objectForKey:@"lastOrderTimeStr"] length]) {
                    cell.lastOrder=[dict objectForKey:@"lastOrderTimeStr"];
                }
                
                if ([[dict objectForKey:@"secondTagItems"] count]) {
                    for (NSDictionary *secDict in [dict objectForKey:@"secondTagItems"]) {
                        if ([[secDict objectForKey:@"tagType"]isEqualToString:@"deduction"]) {
                            cell.deduction=[secDict objectForKey:@"name"];
                        }
                        if ([[secDict objectForKey:@"tagType"]isEqualToString:@"promotion"]) {
                            cell.promotion=[secDict objectForKey:@"name"];
                        }
                        if ([[secDict objectForKey:@"tagType"]isEqualToString:@"refund"]) {
                            cell.refund=[secDict objectForKey:@"name"];
                        }
                        if ([[secDict objectForKey:@"tagType"]isEqualToString:@"today"]) {
                            if ([[secDict objectForKey:@"name"] length]) {
                                cell.lastOrder=[secDict objectForKey:@"name"];
                            }
                        }
                    }
                }
                

                
                cell.sellPrice=[[dict objectForKey:@"sellPrice"] intValue];
                
                
                return cell;
            }
        }else
        {
            static NSString *cellName=@"cell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            return cell;
        }
    }
    else if (tag==101)
    {
        if (indexPath.row==0) {
            static NSString *cellName=@"cellIntrolduct";
            LVHomeIntroCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[LVHomeIntroCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.delegate=self;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.clipsToBounds=YES;
            }
            NSDictionary *dict=[_homeInfoArray objectAtIndex:0];
            cell.cellIntroduceDetail.text=@"";
            cell.cellLightDetail.text=@"";
            cell.height=0;
            cell.lightDetail=[dict objectForKey:@"recommendedReason"];
            cell.introduceDetail=[dict objectForKey:@"ticketProductDesc"];
            cell.introduction=[dict objectForKey:@"clientProdViewSpotVos"];
            return cell;
        }else
        {
            static NSString *cellName=@"cellOther";
            LVHomeIntroOtherCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[LVHomeIntroOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.delegate=self;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.array=[[[_homeInfoArray objectAtIndex:0]objectForKey:@"clientDestVo"] objectForKey:@"clientDestTransVos"];
            return cell;
        }
    }
    else
    {
        if (indexPath.row==0) {
            static NSString *cellName=@"cell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            return cell;
        }else{
            static NSString *cellName=@"cellCommentComment";
            LVHomeCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[LVHomeCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.delegate=self;
            }
            cell.cellCommnet.text=@"";
            cell.cellTime.text=@"";
            cell.cellUserName.text=@"";
            cell.celluserPic.image=nil;
            cell.picArray=nil;
            cell.commnet=@"";
            cell.time=@"";
            cell.userName=@"";
            cell.userPic=@"";
            NSDictionary *dict=[_commentArray objectAtIndex:(indexPath.row-1)];
            cell.commnet=[dict objectForKey:@"content"];
            if ([[dict objectForKey:@"cmtPictures"] count]) {
                cell.picArray=[dict objectForKey:@"cmtPictures"];
            }else
            {
                cell.picArray=nil;
            }
            cell.time=[dict objectForKey:@"createdTime"];
            cell.userName=[dict objectForKey:@"userNameExp"];
            cell.userPic=[dict objectForKey:@"userImg"];
            return cell;
        }
    }
}
-(void)picClick:(NSArray *)array andTheCount:(int)count
{
    [self animationWithPicClick:array andTheCurrent:count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        NSInteger count=0;
        for (NSDictionary *dict in _dataArray) {
            if ([[dict objectForKey:@"itemDatas"] count]) {
                count+=[[dict objectForKey:@"itemDatas"] count];
                ++count;
            }else
            {
                count++;
            }
        }
        return count;
    }else if(tag==101)
    {
        return 2;
    }else if (tag==102)
    {
        return _commentArray.count;
    }else return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        int count = 0;
        int section = 0;
        
        for (NSDictionary *dict in _dataArray) {
            NSLog(@"indexRow=%ld",(long)indexPath.row);

            NSArray *item=[dict objectForKey:@"itemDatas"];
            count+=item.count;
            
            if (indexPath.row<=count) {
                self.trackRow=indexPath.row-count+[item count];
                self.trackSection=section;
                
                NSLog(@"row=%ld",(long)self.trackRow);
                NSLog(@"section=%ld",(long)self.trackSection);
                break;
            }
            section++;
            count++;
        }
        
        if (self.trackRow==0) {
            return 30;
        }else
        {
            NSString *string= [[[[_dataArray objectAtIndex:self.trackSection] objectForKey:@"itemDatas"] objectAtIndex:self.trackRow-1] objectForKey:@"goodsName"];
            if (string==NULL) {
                string=[[[[_dataArray objectAtIndex:self.trackSection] objectForKey:@"itemDatas"] objectAtIndex:self.trackRow-1] objectForKey:@"productName"];
            }
            NSLog(@"%@",string);
            CGSize size=CGSizeMake(self.view.bounds.size.width-85, 1000);
            UIFont *font=[UIFont systemFontOfSize:14];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            
            return 75+actualSize.height-20;
        }
        
    }else if (tag==101)
    {
        if (indexPath.row==0) {
            if (_isIntroduct==NO) {
                return 160;
                
            }else
                return _height;
        }else
        {
            return 285;
        }

    }
    else
    {
        if (indexPath.row==0) {
            return 0;
        }else
        {
            int height=0;
            NSDictionary *dict=[_commentArray objectAtIndex:(indexPath.row-1)];
            CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH*2, 1000);
            UIFont *font=[UIFont systemFontOfSize:12];
            NSDictionary *dictSize=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[[dict objectForKey:@"content"]  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dictSize context:nil].size;
            height+=actualSize.height+65;

            if ([[dict objectForKey:@"cmtPictures"] count] ) {
                height+=45;
            }
            return height;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_headView.bounds.size.height!=40) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,40)];
        _headView.userInteractionEnabled=YES;
        _headView.backgroundColor=[UIColor whiteColor];
        UIButton *ticket=[UIButton buttonWithType:UIButtonTypeCustom];
        ticket.frame=CGRectMake(0, 0, self.view.bounds.size.width/3, _headView.bounds.size.height);
        [ticket addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        ticket.tag=100;
        
        UILabel *ticketLabel=[[UILabel alloc]initWithFrame:ticket.frame];
        ticketLabel.text=@"订票";
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
        vacaLabel.text=@"景点介绍";
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
        commentLabel.text=@"点评";
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
        line.frame=CGRectMake(ticketLabel.center.x-11, _headView.bounds.size.height-3, 23, 3);
        [_headView addSubview:line];
    }
    return _headView;
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
                        line.frame=CGRectMake(button.superview.center.x-10, _headView.bounds.size.height-3, 22, 3);
                    }else if (button.tag==101)
                    {
                        line.frame=CGRectMake(button.superview.center.x-22, _headView.bounds.size.height-3, 47, 3);
                    }else if (button.tag==102)
                    {
                        line.frame=CGRectMake(button.superview.center.x-10, _headView.bounds.size.height-3, 22, 3);
                    }
                }];
            }
        }
    }
    
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    if (button.tag==101) {
        _LVTableView.tableFooterView=nil;
    }else if (button.tag==102)
    {
        [self addMoreFooterView];
    }
    else
        _LVTableView.tableFooterView=_footerView;
    [_LVTableView reloadData];
}

-(void)addMoreFooterView
{
    if (_moreView) {
        [_moreView removeFromSuperview];
        for (UIView *view in _moreView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (!_moreView) {
        _moreView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        UILabel *more=[[UILabel alloc]initWithFrame:_moreView.bounds];
        more.text=@"查看全部点击";
        more.font=[UIFont systemFontOfSize:12];
        more.textAlignment=NSTextAlignmentCenter;
        more.userInteractionEnabled=YES;
        [_moreView addSubview:more];
        
        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame=more.bounds;
        [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        moreButton.userInteractionEnabled=YES;
        [_moreView addSubview:moreButton];
        _moreView.userInteractionEnabled=YES;
    }
    if (_LVTableView.tableFooterView.bounds.size.height!=0) {
        _LVTableView.tableFooterView=nil;
    }

    _LVTableView.tableFooterView=_moreView;
}

-(void)moreClick
{
    CommentViewController *comment=[[CommentViewController alloc]init];
    [self.navigationController pushViewController:comment animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        int count = 0;
        int section = 0;
        
        for (NSDictionary *dict in _dataArray) {
            NSLog(@"indexRow=%ld",(long)indexPath.row);
            
            NSArray *item=[dict objectForKey:@"itemDatas"];
                count+=item.count;
                
            if (indexPath.row<=count) {
                self.trackRow=indexPath.row-count+[item count];
                self.trackSection=section;
                
                NSLog(@"row=%ld",(long)self.trackRow);
                NSLog(@"section=%ld",(long)self.trackSection);
                break;
            }
            
            section++;
            count++;
        }
        
        if (self.trackRow == 0) {
            if ([[[_dataArray objectAtIndex:self.trackSection] objectForKey:@"itemDatas"] count]) {
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:[_dataArray objectAtIndex:self.trackSection]];
                [dict removeObjectForKey:@"itemDatas"];
                
                [_dataArray replaceObjectAtIndex:self.trackSection withObject:dict];
                [_LVTableView reloadData];
            }else
            {
                [[_dataArray objectAtIndex:self.trackSection]setObject:[[_openArray objectAtIndex:self.trackSection]objectForKey:@"itemDatas"] forKey:@"itemDatas"];
                [_LVTableView reloadData];
            }
            
        }
    }
    else if (tag==101)
    {
        if (indexPath.row==0) {
            if ([[[_homeInfoArray objectAtIndex:0] objectForKey:@"clientProdViewSpotVos"] count]) {
                if (_isIntroduct==NO) {
                    _isIntroduct=YES;
                }else
                    _isIntroduct=NO;
                
                [_LVTableView reloadData];
            }

        }
    }
}



-(void)returnHeight:(int)height
{
    _height=height;
    NSLog(@"height=%d",_height);
}

-(void)returnCommentHieght:(int)height
{
    _commentHeight=height;
}

-(void)hotelClick:(NSInteger)tag
{
    if (tag==100) {
            [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

    }else
    {
        [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

-(NSInteger)buttonTag
{
    NSInteger tag;
    for (UILabel *label in _headView.subviews) {
        for (UIButton *button in label.subviews) {
            if (button.selected==YES) {
                tag=button.tag;
            }
        }
    }
    return tag;
}

- (void)didReceiveMemoryWarning
{
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
#pragma mark 支付

-(void)pay
{
    LogInViewController *log=[[LogInViewController alloc]init];
    
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
        
    }];
}

@end
