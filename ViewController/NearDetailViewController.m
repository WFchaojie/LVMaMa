//
//  NearDetailViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/10/10.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import "NearDetailViewController.h"
#import "LogInViewController.h"
#import "NearDetailHeadCell.h"
#import "NearDetailInfoCell.h"
#import "HotelDescriptionCell.h"
#import "ServiceCell.h"
@interface NearDetailViewController ()<UITableViewDataSource,UITableViewDelegate,Pay>

@end

@implementation NearDetailViewController

{
    UIPageControl *_pageControl;
    UIScrollView *_scrol;
    UIView *_headerView;
    UIView *_headView;
    UIView *_footerView;
    UIView *_blankView;
    UIView *_moreView;
    
    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    //header和footer
    NSMutableArray *_homeInfoArray;
    NSMutableArray *_commentArray;
    NSMutableArray *_topArray;

    //景区须知是否变长
    BOOL _longer;
    //判断cell是否是展开的
    BOOL _singleOpen;
    BOOL _groupOpen;
    //用来储存tableview数据
    NSMutableArray *_openArray;
    int _height;
    int _hotelHeight;
    int _commentHeight;
    //景点介绍的点击展开判断
    BOOL _isIntroduct;
    UIImageView *_arrow;
    //计算tableview的row
    NSInteger _count;
    UIView *_blackView;
    UIScrollView *_picScrollView;
    UIImageView *_capture;
    
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page=1;
    _countPage=1;
    _hasNext=YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bannerDownloadFinish) name:[NSString stringWithFormat:NEAR_DETAIL_BANNER2,self.ProductID] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_DETAIL_BANNER2,self.ProductID] and:8];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoCellDownloadFinish) name:[NSString stringWithFormat:NEAR_CELL,_page,self.ProductID] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_CELL,_page,self.ProductID] and:4];
    
    NSLog(@"cell=%@",[NSString stringWithFormat:NEAR_DETAIL_BANNER2,self.ProductID]);

    [self createBlankView];
    [self leftButton];
    [self rightButton];
    _count=0;
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    _openArray=[[NSMutableArray alloc]initWithCapacity:0];
    _topArray=[[NSMutableArray alloc]initWithCapacity:0];

}
-(void)createBlankView
{
    if (!_blackView) {
        _blackView=[[UIView alloc]init];
        _blankView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 10);
    }
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

-(void)bannerDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NEAR_DETAIL_BANNER2,self.ProductID]];
    _homeInfoArray=[[NSMutableArray alloc]initWithArray:array];
    _topArray=(NSMutableArray *)array;
    [self createTop:array];
}



-(void)infoCellDownloadFinish
{
    if (_page==1) {
        _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NEAR_CELL,_page,self.ProductID]];
    }else
    {
        [_dataArray addObjectsFromArray:[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:NEAR_CELL,_page,self.ProductID]]];
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
    if(_dataArray.count==0)
    {
        UIView *view=[[UIView alloc]init];
        _LVTableView.tableFooterView=view;
    }
        
    
    _LVTableView.alpha=1;
    
    [_LVTableView reloadData];
    
    if (_page!=1&&_page!=_countPage) {
        _countPage++;
    }
}

-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+46) style:UITableViewStylePlain];
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
    _storeHouseRefreshControl = [CBHomeRefreshControl attachToScrollView:_LVTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    _LVTableView.alpha=0;

}

-(void)createTop:(NSArray *)array
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 278)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _LVTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]init];
        if (iPhone6Plus) {
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, 250);
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
        _pageControl=[[UIPageControl alloc]init];
        if (iPhone6Plus) {
            _pageControl.frame=CGRectMake(0, _scrol.bounds.size.height-20, self.view.bounds.size.width, 20);
        }else
        {
            _pageControl.frame=CGRectMake(0, _scrol.bounds.size.height-20, self.view.bounds.size.width, 20);
        }
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }
    
    if (array.count&&_scrol) {
        NSDictionary *dict=[array objectAtIndex:0];
        NSArray *topArray;
        if ([dict objectForKey:@"largeImages"]) {
            topArray=[dict objectForKey:@"largeImages"];
        }
        _pageControl.numberOfPages=topArray.count;
        for (int i=0; i<topArray.count; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*topArray.count, 0);
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, _scrol.bounds.size.height)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[topArray objectAtIndex:i]]placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]] ;
            
            [_scrol addSubview:imageView];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=imageView.frame;
            button.tag=100+i;
            [button addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrol addSubview:button];
            
        }
        
        [self createTopTitleL:dict];
        
        _headerView=_LVTableView.tableHeaderView;
        _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, _scrol.bounds.size.height+_scrol.frame.origin.y);
        _LVTableView.tableHeaderView=_headerView;
    }
}

-(void)createTopTitleL:(NSDictionary *)dict
{
    UIView *title=[[UIView alloc]init];
    if (iPhone6Plus) {
        title.frame=CGRectMake(0, 0, _scrol.bounds.size.width, 30);
    }else
    {
        title.frame=CGRectMake(0, 0, _scrol.bounds.size.width, 20);
    }
    title.backgroundColor=[UIColor blackColor];
    title.alpha=0.8;
    [_LVTableView addSubview:title];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=[UIFont boldSystemFontOfSize:14];
    if (iPhone6Plus) {
        titleLabel.frame=CGRectMake(20, 0, _scrol.bounds.size.width, 30);
        titleLabel.font=[UIFont boldSystemFontOfSize:16];
    }else
    {
        titleLabel.frame=CGRectMake(20, 0, _scrol.bounds.size.width, 20);
    }
    titleLabel.text=[dict objectForKey:@"productName"];
    titleLabel.textColor=[UIColor whiteColor];
    [_LVTableView addSubview:titleLabel];
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
    NSArray *topArray=[dict objectForKey:@"largeImages"];
    
    [self animationWithPicClick:topArray andTheCurrent:(int)button.tag-100];
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
    }else
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
                label.textAlignment = NSTextAlignmentCenter;
                [footView addSubview:label];
                UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
                [footView addSubview:activity];
                activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
                [activity startAnimating];
                _page++;
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoCellDownloadFinish) name:[NSString stringWithFormat:NEAR_CELL,_page,_ProductID] object:nil];
                [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_CELL,_page,_ProductID] and:4];
                
            }
        }
        
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        if (indexPath.row==0) {
            static NSString *cellName=@"cellHead";
            NearDetailHeadCell  *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[NearDetailHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
            }

            NSDictionary *topDict=[_topArray firstObject];
            cell.cellCommentGoodRate=@"";
            cell.cellProductSellPrice=@"";
            cell.cellCommentCount=0;
            
            cell.cellCommentGoodRate=[topDict objectForKey:@"commentGoodRate"];
            cell.cellCommentCount=[topDict objectForKey:@"commentCount"];
            cell.cellProductSellPrice=[NSString stringWithFormat:@"%d",[[topDict objectForKey:@"productSellPrice"] intValue]];

            return cell;
        }else
        {
            static NSString *cellName=@"cellInfoCell";
            NearDetailInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[NearDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.delegate=self;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row-1];
            cell.cellSellPrice=@"";
            cell.cellImages=@"";
            cell.cellBranchName=@"";
            cell.cellPayType=@"";
            cell.cellInfo=@"";
            cell.cellRoomArea=@"";
            cell.cellFloor=@"";
            
            cell.cellBranchName=[dict objectForKey:@"branchName"];
            if ([dict objectForKey:@"images"]) {
                cell.cellImages=[[dict objectForKey:@"images"] firstObject];
            }
            cell.cellSellPrice=[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"sellPrice"]];
            cell.cellPayType=[dict objectForKey:@"payType"];
            cell.cellInfo=[NSString stringWithFormat:@"%@ 宽带%@",[dict objectForKey:@"goodsName"],[dict objectForKey:@"broadband"]];
            cell.cellRoomArea=[NSString stringWithFormat:@"%@平米",[dict objectForKey:@"roomArea"]];
            cell.cellFloor=[NSString stringWithFormat:@"%@楼",[dict objectForKey:@"floor"]];
            
            return cell;
        }
    }
    else if (tag==101)
    {
        if (indexPath.row==0) {
            static NSString *cellName=@"cellAdress";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            NSDictionary *topDict=[_topArray firstObject];

            cell.imageView.image=[UIImage imageNamed:@"placemarkIcon.png"];
            cell.textLabel.text=[topDict objectForKey:@"productAddress"];
            cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
            return cell;
        }else if(indexPath.row==1)
        {
            static NSString *cellName=@"cellInfo";
            HotelDescriptionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[HotelDescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.info=@"";
            cell.picString=@"";
            cell.titleHint=@"";
            NSDictionary *topDict=[_topArray firstObject];
            cell.info=[topDict objectForKey:@"description"];
            cell.picString=@"detailHotelIconInfo.png";
            cell.titleHint=@"酒店介绍";
            return cell;
        }else if (indexPath.row==2)
        {
            static NSString *cellName=@"cellService";
            ServiceCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[ServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.generalAmenities=@"";
            cell.roomAmenities=@"";
            NSDictionary *topDict=[_topArray firstObject];
            cell.generalAmenities=[topDict objectForKey:@"generalAmenities"];
            cell.roomAmenities=[topDict objectForKey:@"roomAmenities"];
            
            return cell;
        }else
        {
            static NSString *cellName=@"cellTraffic";
            HotelDescriptionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell=[[HotelDescriptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.info=@"";
            cell.picString=@"";
            cell.titleHint=@"";
            NSDictionary *topDict=[_topArray firstObject];
            cell.info=[topDict objectForKey:@"traffic"];
            cell.picString=@"detailHotelIconTraffic.png";
            cell.titleHint=@"交通状况";
            return cell;
        }
    }
    else
    {
        static NSString *cellName=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        return cell;
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
        
        NSInteger count=_dataArray.count;

        return ++count;
    }else if(tag==101)
    {
        return 4;
    }else if (tag==102)
    {
        return _commentArray.count;
    }else return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {
        if (indexPath.row==0) {
            if (iPhone6Plus) {
                return 90;
            }else
            {
                return 70;
            }
        }else
            if (iPhone6Plus) {
                return 145;
            }else
            {
                return 130;
            }
    }else if(tag==101)
    {
        if (indexPath.row==0) {
            if (iPhone6Plus) {
                return 45;
            }else
            {
                return 30;
            }
        }else if(indexPath.row==1){
            if (iPhone6Plus) {
                return 55+[self resizeContent:10*2 and:[[_topArray firstObject] objectForKey:@"description"]];
            }else
            {
                return 30;
            }
        }else if (indexPath.row==2)
        {
            if (iPhone6Plus) {
                return 60+[self resizeContent:95 and:[[_topArray firstObject] objectForKey:@"generalAmenities"]]+[self resizeContent:95 and:[[_topArray firstObject] objectForKey:@"roomAmenities"]];
            }else
            {
                return 30;
            }
        }else
        {
            if (iPhone6Plus) {
                return 50+[self resizeContent:10*2 and:[[_topArray firstObject] objectForKey:@"traffic"]];
            }else
            {
                return 30;
            }
        }
    }else
        return 0;
}

-(CGFloat)resizeContent:(CGFloat)length and:(NSString *)string;
{
    CGSize size=CGSizeMake(self.view.bounds.size.width-length, 1000);
    UIFont *font;
    if (iPhone6Plus) {
        font=[UIFont systemFontOfSize:12];
    }else
    {
        font=[UIFont systemFontOfSize:10];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing=0;
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil];
    CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return actualSize.height;
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
        
        UIImageView *backPic=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"segTabShadowBgSel3.png"]];
        backPic.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [_headView addSubview:backPic];
        
        UIButton *ticket=[UIButton buttonWithType:UIButtonTypeCustom];
        ticket.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [ticket addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        ticket.tag=100;
        
        UILabel *ticketLabel=[[UILabel alloc]initWithFrame:ticket.frame];
        ticketLabel.text=@"预定";
        ticketLabel.userInteractionEnabled=YES;
        [_headView addSubview:ticketLabel];
        ticketLabel.textColor=[UIColor grayColor];
        ticketLabel.textAlignment=NSTextAlignmentCenter;
        ticketLabel.font=[UIFont systemFontOfSize:12];
        [ticketLabel addSubview:ticket];
        
        
        UIButton *introduction=[UIButton buttonWithType:UIButtonTypeCustom];
        introduction.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [introduction addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        introduction.tag=101;
        
        UILabel *vacaLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4, 0, self.view.bounds.size.width/4, _headView.bounds.size.height)];
        vacaLabel.text=@"酒店介绍";
        vacaLabel.userInteractionEnabled=YES;
        [_headView addSubview:vacaLabel];
        vacaLabel.textColor=[UIColor grayColor];
        vacaLabel.textAlignment=NSTextAlignmentCenter;
        vacaLabel.font=[UIFont systemFontOfSize:12];
        [vacaLabel addSubview:introduction];
        
        UIButton *comment=[UIButton buttonWithType:UIButtonTypeCustom];
        comment.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [comment addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        comment.tag=102;
        
        UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4*2, 0, self.view.bounds.size.width/4, _headView.bounds.size.height)];
        commentLabel.text=@"点评";
        commentLabel.userInteractionEnabled=YES;
        [_headView addSubview:commentLabel];
        commentLabel.textColor=[UIColor grayColor];
        commentLabel.textAlignment=NSTextAlignmentCenter;
        commentLabel.font=[UIFont systemFontOfSize:12];
        [commentLabel addSubview:comment];
        
        UIButton *around=[UIButton buttonWithType:UIButtonTypeCustom];
        around.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
        [around addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
        around.tag=103;
        
        UILabel *aroundLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4*3, 0, self.view.bounds.size.width/4, _headView.bounds.size.height)];
        aroundLabel.text=@"周边景点";
        aroundLabel.userInteractionEnabled=YES;
        [_headView addSubview:aroundLabel];
        aroundLabel.textColor=[UIColor grayColor];
        aroundLabel.textAlignment=NSTextAlignmentCenter;
        aroundLabel.font=[UIFont systemFontOfSize:12];
        [aroundLabel addSubview:around];
        
        ticket.selected=YES;
        ticketLabel.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
        
        UIImageView *lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        lineSe.frame=CGRectMake(0,_headView.bounds.size.height-1, self.view.bounds.size.width, 1);
        lineSe.alpha=0.3;
        [_headView addSubview:lineSe];
        
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
    
    for (UIImageView *backPic in button.superview.superview.subviews) {
        if ([backPic isKindOfClass:[UIImageView class]]) {
            if (backPic.frame.size.height==_headView.bounds.size.height) {
                [UIView animateWithDuration:0.2f animations:^{
                    if (button.tag==100) {
                        backPic.frame=CGRectMake(0, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
                    }else if (button.tag==101)
                    {
                        backPic.frame=CGRectMake(self.view.bounds.size.width/4, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
                    }else if (button.tag==102)
                    {
                        backPic.frame=CGRectMake(self.view.bounds.size.width/4*2, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
                    }else if (button.tag==103)
                    {
                        backPic.frame=CGRectMake(self.view.bounds.size.width/4*3, 0, self.view.bounds.size.width/4, _headView.bounds.size.height);
                    }
                    
                }];
            }
        }
    }
    
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    if (button.tag==101||button.tag==100) {
        _LVTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    else
        _LVTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_LVTableView reloadData];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=[self buttonTag];
    if (tag==100) {

    }
    else if (tag==101)
    {

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

-(void)payClick
{
    LogInViewController *log=[[LogInViewController alloc]init];
    
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
        
    }];
}


#pragma mark 支付

-(void)pay
{
    LogInViewController *log=[[LogInViewController alloc]init];
    
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
        
    }];
}

#pragma mark 下拉刷新
- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:NEAR_CELL,_page,self.ProductID] and:4];
    [_storeHouseRefreshControl finishingLoading];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_storeHouseRefreshControl scrollViewDidEndDragging];
}



@end

