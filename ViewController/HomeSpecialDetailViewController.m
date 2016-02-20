//
//  HomeSpecialDetailViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/16.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeSpecialDetailViewController.h"
#import "HomePicViewController.h"
#import "LVHomeSpecialCell.h"
#import "LVSecialRecommendCell.h"
#import "LVSepecialLineRouteCell.h"
#import "LVSpecialDefaultCell.h"
#import "LVHomeSpecialURLViewController.h"
#import "HomeUserCommentViewController.h"
#import "LogInViewController.h"
@interface HomeSpecialDetailViewController ()<pay,getMore,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *lvTableView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIScrollView *scrol;
@property (nonatomic,strong) NSMutableArray *picArray;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSDictionary *dictData;
@property (nonatomic,assign) BOOL show;


@end


@implementation HomeSpecialDetailViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
    if(!_lvTableView)
    {
        [self createTableView];
        [self hudShow];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _show=NO;
    self.navigationController.navigationBarHidden=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title=@"特卖详情";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoDownloadFinish) name:[NSString stringWithFormat:DOMESTIC_SPECIAL_DETAIL,self.ID,self.ID] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:DOMESTIC_SPECIAL_DETAIL,self.ID,self.ID] and:10];
    NSLog(@"%@",[NSString stringWithFormat:DOMESTIC_SPECIAL_DETAIL,self.ID,self.ID]);
    [self leftButton];
    [self rightButton];
    _dictData=[[NSDictionary alloc]init];
    _picArray=[[NSMutableArray alloc]initWithObjects:@"routeDetailIcon1.png",@"routeDetailIcon3.png",@"routeDetailIcon4.png",@"routeDetailIcon5.png",@"routeDetailIcon14.png",nil];
    
    // Do any additional setup after loading the view.
}
-(void)createTableView
{
    _lvTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _lvTableView.delegate=self;
    _lvTableView.dataSource=self;
    _lvTableView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    _lvTableView.showsVerticalScrollIndicator=NO;
    _lvTableView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_lvTableView];
    [self createTop:nil];
    _lvTableView.alpha=0;
    if ([_lvTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_lvTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_lvTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_lvTableView setLayoutMargins: UIEdgeInsetsZero];
    }
}
-(void)rightButton
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[NSArray arrayWithObjects:@"placeDetailUncollected.png",@"shareBtn.png",@"phoneBtn.png",nil];
    for (NSInteger i=array.count-1; i>=0; i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage :[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 32, 32);
        button.imageEdgeInsets = UIEdgeInsetsMake(0,18, 0,-18);

        [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
        button.tag=100+i;
        [items addObject:item];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -1;
        [items addObject:negativeSpacer];
    }
    
    self.navigationItem.rightBarButtonItems=items;
}
-(void)rightClick:(UIButton *)button
{
    if (button.tag==100||button.tag==101) {
        LogInViewController *log=[[LogInViewController alloc]init];
        log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:log animated:YES completion:^{
        }];
    }else
    {
//方法一        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4001570570"]];
        //方法二

        
        //[[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"模拟器不能模拟打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"拨打驴妈妈客服热线" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"4001-570-570",nil];
        [sheet showInView:self.view];
        //[self.view addSubview:sheet];
        
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001570570"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}
-(void)infoDownloadFinish
{
    _dictData=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:DOMESTIC_SPECIAL_DETAIL,self.ID,self.ID]];
    
    [self createTop:[_dictData objectForKey:@"imageList"]];
    [self hudHide];
    _lvTableView.alpha=1;
    [_lvTableView reloadData];
    [self tableViewSize];
}

-(void)tableViewSize
{
    CGSize size=_lvTableView.contentSize;
    size.height+=66+50;
    _lvTableView.contentSize=size;
}
-(void)createTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _lvTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        _scrol.pagingEnabled=YES;
        _scrol.bounces=NO;
        _scrol.showsHorizontalScrollIndicator=NO;
        _scrol.showsVerticalScrollIndicator=NO;
        [_headerView addSubview:_scrol];
        _scrol.delegate=self;
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, _scrol.bounds.size.height-30, self.view.bounds.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }
    
    if (array.count&&_scrol) {
        _pageControl.numberOfPages=array.count;
        for (int i=0; i<array.count; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*array.count, 0);
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, _scrol.bounds.size.height)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[array objectAtIndex:i]]placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]] ;
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [_scrol addSubview:imageView];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=imageView.frame;
            button.tag=100+i;
            [button addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrol addSubview:button];
        }
    }
}

-(void)scrollViewClick:(UIButton *)button
{
    HomePicViewController *pic=[[HomePicViewController alloc]init];
    pic.pic=[_dictData objectForKey:@"imageList"];
    pic.current=(int)button.tag-100;
    [self.navigationController pushViewController:pic animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_scrol) {
        _pageControl.currentPage=scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellIde=@"cellIndex1";
        LVHomeSpecialCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[LVHomeSpecialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.payDelegate=self;
        }
        cell.cellProductName.text=@"";
        cell.productName=@"";
        cell.firstTagItems=nil;
        cell.orderCount=@"";
        cell.cellOrderCount.text=@"";
        cell.offlineTime=@"";
        cell.cellOfflineTime.text=@"";
        cell.productId=@"";
        cell.cellProductId.text=@"";
        cell.cellSellPriceYuan.text=@"";
        cell.productName=[_dictData objectForKey:@"productName"];
        cell.firstTagItems=[_dictData objectForKey:@"firstTagItems"];
        cell.orderCount=[_dictData objectForKey:@"orderCount"];
        cell.offlineTime=[_dictData objectForKey:@"offlineTime"];
        cell.productId=[_dictData objectForKey:@"productId"];
        cell.sellPriceYuan=[_dictData objectForKey:@"sellPriceYuan"];
        
        return cell;
    }else if (indexPath.row==1)
    {
        static NSString *cellIde=@"cellSpecial";
        LVSecialRecommendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[LVSecialRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.managerRecommend=@"";
        cell.cellManagerRecommend.text=@"";
        
        cell.managerRecommend=[_dictData objectForKey:@"managerRecommend"];
        cell.show=_show;

        return cell;
    }else if (indexPath.row==2)
    {
        static NSString *cellIde=@"cell";
        LVSepecialLineRouteCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[LVSepecialLineRouteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;

        }
        cell.cellDay1Content.text=@"";
        cell.cellDay1StayDesc.text=@"";
        cell.cellDay1title.text=@"";
        cell.cellDay2Content.text=@"";
        cell.cellDay2title.text=@"";
        cell.day2Title=@"";
        cell.day2Content=@"";
        cell.day1Title=@"";
        cell.day1StayDesc=@"";
        cell.day1Content=@"";
        cell.day1Content=[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:0] objectForKey:@"content"];
        cell.day1StayDesc=[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:0] objectForKey:@"stayDesc"];
        cell.day1Title=[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:0] objectForKey:@"title"];
        cell.day2Content=[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:1] objectForKey:@"content"];
        cell.day2Title=[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:1] objectForKey:@"title"];
        return cell;
    }
    else
        {
            static NSString *cellIde=@"cell";
            LVSpecialDefaultCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[LVSpecialDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.cellComment.text=@"";
            cell.cellLeftImage.image=NULL;
            cell.cellStar.image=NULL;
            cell.celltitle.text=@"";
            cell.comment=0;
            cell.title=@"";
            cell.leftImage=@"";
            cell.star=@"";
            if (indexPath.row==3) {
                cell.comment=[[_dictData objectForKey:@"commentCount"] intValue];
            }else
                cell.comment=0;
            if (indexPath.row==3) {
                cell.title=@"用户点评";
            }else
                cell.title=[[[_dictData objectForKey:@"clientProdProductPropBaseVos"] objectAtIndex:indexPath.row-4] objectForKey:@"name"];
            cell.leftImage=[_picArray objectAtIndex:indexPath.row-3];
            
            return cell;
        }
}
#pragma mark celldelegate
-(void)pay
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}
-(void)getMore
{
    LVHomeSpecialURLViewController *top=[[LVHomeSpecialURLViewController alloc]init];
    top.url=[_dictData objectForKey:@"viewJourneyUrl"];
    top.homeTitle=@"行程介绍";
    [self.navigationController pushViewController:top animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        NSString *string=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"productName"]];
        CGSize size=CGSizeMake(self.view.bounds.size.width-5*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:13];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        return actualSize.height+5+23+5+15+5+30+5+10;
        
    }else if(indexPath.row==1)
    {
        if (_show==YES) {
            NSString *string=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"managerRecommend"]];
            CGSize size=CGSizeMake(self.view.bounds.size.width-5*2, 1000);
            UIFont *font=[UIFont systemFontOfSize:11];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            return actualSize.height+52+5;
        }else
            return 90+5;

    }else if (indexPath.row==2)
    {
        if ([[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:0] objectForKey:@"stayDesc"] length]==0) {
            NSString *string=[[[_dictData objectForKey:@"prodLineRouteDetailVoList"] objectAtIndex:0] objectForKey:@"content"];
            CGSize size=CGSizeMake(self.view.bounds.size.width-5*2, 1000);
            UIFont *font=[UIFont systemFontOfSize:11];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            return 70+actualSize.height+8+70+5+15;
        }else
        return 236;
    }
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+[[_dictData objectForKey:@"clientProdProductPropBaseVos"] count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        if (_show==NO) {
            _show=YES;
        }else
        {
            _show=NO;
        }
        [_lvTableView reloadData];
        [self tableViewSize];
    }else if (indexPath.row==3)
    {
        HomeUserCommentViewController *user=[[HomeUserCommentViewController alloc]init];
        user.ID=self.ID;
        [self.navigationController pushViewController:user animated:YES];
    }else if (indexPath.row==0||indexPath.row==2)
    {
    
    }
    else
    {
        LVHomeSpecialURLViewController *top=[[LVHomeSpecialURLViewController alloc]init];
        top.url=[[[_dictData objectForKey:@"clientProdProductPropBaseVos"] objectAtIndex:indexPath.row-4] objectForKey:@"url"];
        top.homeTitle=[[[_dictData objectForKey:@"clientProdProductPropBaseVos"] objectAtIndex:indexPath.row-4] objectForKey:@"name"];
        [self.navigationController pushViewController:top animated:YES];
    }
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

@end
