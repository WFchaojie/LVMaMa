//
//  TourRecordDetailController.m
//  LVMaMa
//
//  Created by apple on 15-6-13.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "TourRecordDetailController.h"
#import "LVDownLoadManager.h"
#import "LVTourRecordDetialCell.h"
#import "LVTourCell.h"
#import "TourRecordCommentViewController.h"
#import "LogInViewController.h"
#import "YYTableView.h"
#import "TourRelatedViewController.h"
@interface TourRecordDetailController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)YYTableView *LVTableView;
@property(nonatomic,strong)NSMutableArray *headArray;
@property(nonatomic,strong)NSMutableArray *calculateArray;
@property(nonatomic,assign)NSInteger trackSection;
@property(nonatomic,assign)NSInteger trackRow;
//用来记录section的变化
@property(nonatomic,assign)NSInteger sectionCount;
@property(nonatomic,strong)UIView *headView;



@end

@implementation TourRecordDetailController

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
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
    if (!_LVTableView) {
        [self createTableView];
        [self hudShow];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackRow=0;
    self.trackSection=0;
    self.sectionCount=0;
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_RECORD_DETAIL,self.ID] and:13];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourDownloadFinish) name:[NSString stringWithFormat:TOUR_RECORD_DETAIL,self.ID] object:nil];
    [self leftButton];
    [self rightButton];
    self.calculateArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSLog(@"%@",[NSString stringWithFormat:TOUR_RECORD_DETAIL,self.ID]);
}

-(void)rightButton
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[NSArray arrayWithObjects:@"placeDetailUncollected.png",@"discuss.png",@"shareBtn.png",@"downLoad.png",nil];
    for (int i=3; i>=0; i--) {
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
    if (button.tag==100) {
        LogInViewController *log=[[LogInViewController alloc]init];
        log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:log animated:YES completion:^{
            
        }];
    }else if (button.tag==101)
    {
        TourRecordCommentViewController *record=[[TourRecordCommentViewController alloc]init];
        record.typeID=[[_headArray objectAtIndex:0]objectForKey:@"id"];
        [self.navigationController pushViewController:record animated:YES];
    }else if (button.tag==102)
    {
        [self showShareList1];
        NSLog(@"share ");
    }
}
/*
 注意分享到新浪微博我们使用新浪微博SSO授权，你需要在xcode工程设置url scheme，并重写AppDelegate中的`- (BOOL)application openURL sourceApplication`方法，详细见文档。否则不能跳转回来原来的app。
 */
-(void)showShareList1
{
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    NSArray *plantForm=[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatFavorite,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToRenren,UMShareToSms,UMShareToTencent,nil];

    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:plantForm
                                       delegate:self];
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)createTableView
{
    if (!_LVTableView) {
        _LVTableView=[[YYTableView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _LVTableView.delegate=self;
        _LVTableView.dataSource=self;
        _LVTableView.backgroundColor=UICOLOR_GRAY;
        [self.view addSubview:_LVTableView];
        _LVTableView.alpha=0;
        if ([_LVTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_LVTableView setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([_LVTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_LVTableView setLayoutMargins: UIEdgeInsetsZero];
        }
    }
}

-(void)TourDownloadFinish
{
    _headArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *data=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_RECORD_DETAIL,self.ID]];
    _headArray=[data objectAtIndex:0];
    _dataArray=[data objectAtIndex:1];
    [self createHeadView];
    [self hudHide];
    _LVTableView.alpha=1;
    [_LVTableView reloadData];
}

-(void)createHeadView
{
    NSDictionary *dict=[_headArray objectAtIndex:0];
    
    if (!_headView) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 260)];
        _LVTableView.tableHeaderView=_headView;
    }
    
    UIImageView *backPic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 230)];
    [backPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"coverImg"]]] placeholderImage:[UIImage imageNamed:@"defaultBannerImage.png"]];
    [_headView addSubview:backPic];
    
    UIImageView *grayArear=[[UIImageView alloc]init];
    grayArear.frame=CGRectMake(0, backPic.bounds.size.height-40, self.view.bounds.size.width, 40);
    grayArear.backgroundColor=[UIColor blackColor];
    grayArear.alpha=0.5f;
    [backPic addSubview:grayArear];
    
    UIImageView *userPic=[[UIImageView alloc]initWithFrame:CGRectMake(5, backPic.bounds.size.height-35, 30, 30)];
    [userPic sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"userImg"]] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
    userPic.layer.cornerRadius=15;
    userPic.clipsToBounds=YES;
    [backPic addSubview:userPic];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(45,backPic.bounds.size.height-35, 300, 15)];
    title.text=[dict objectForKey:@"title"];
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:14];
    [backPic addSubview:title];
    
    UILabel *information=[[UILabel alloc]initWithFrame:CGRectMake(45,backPic.bounds.size.height-20, 300, 20)];
    information.text=[NSString stringWithFormat:@"行程 %d天 | 照片%d | 收藏%d | 评论%d",[[dict objectForKey:@"dayCount"] intValue],[[dict objectForKey:@"imgCount"] intValue],[[dict objectForKey:@"favoriteCount"] intValue],[[dict objectForKey:@"commentCount"] intValue]];
    information.textColor=[UIColor whiteColor];
    information.font=[UIFont boldSystemFontOfSize:10];
    [backPic addSubview:information];
    
    UIView *moreView=[[UIView alloc]initWithFrame:CGRectMake(0, backPic.bounds.size.height, self.view.bounds.size.width, 30)];
    moreView.backgroundColor=[UIColor whiteColor];
    [_headView addSubview:moreView];
    
    UIImageView *morePic=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"releataProduct.png"]];
    morePic.frame=CGRectMake(5, 5, 10, 20);
    [moreView addSubview:morePic];
    
    UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(morePic.frame.origin.x+morePic.frame.size.width+10, 0, 200, 30)];
    moreLabel.text=@"点击查看相关推荐产品";
    moreLabel.font=[UIFont systemFontOfSize:12];
    [moreView addSubview:moreLabel];
    
    UIImageView *moreArrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow.png"]];
    moreArrow.frame=CGRectMake(self.view.bounds.size.width-15, 7, 8, 13);
    [moreView addSubview:moreArrow];
    
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=moreView.bounds;
    [moreView addSubview:moreButton];
    [moreButton addTarget:self action:@selector(showProduct) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showProduct
{
    TourRelatedViewController *related=[[TourRelatedViewController alloc]init];
    [self.navigationController pushViewController:related animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellDetail";
    LVTourRecordDetialCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[LVTourRecordDetialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cellAddressLabel.text=@"";
    cell.poiName=@"";
    cell.cellAddressPic.alpha=0;
    cell.cellDiscrip.text=@"";
    cell.cellMemoLabel.text=@"";
    cell.memo=@"";
    cell.cellPic.image=nil;
    cell.pic=@"";
    cell.cellPoiDesc.text=@"";
    cell.poiDesc=@"";
    cell.discrip=@"";
    cell.likeLabel.text=@"";
    cell.like=0;
    cell.likePic.alpha=0;
    cell.commentPic.alpha=0;
    cell.comment=0;
    cell.commentLabel.text=@"";
    
    NSDictionary *dict=[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([dict objectForKey:@"poiDesc"]) {
        cell.poiDesc=[dict objectForKey:@"poiDesc"];
    }
    if ([dict objectForKey:@"poiName"]) {
        cell.poiDesc=[dict objectForKey:@"poiDesc"];
    }
    if ([dict objectForKey:@"image"]) {
        cell.pic=[[dict objectForKey:@"image"] objectForKey:@"imgUrl"];
        cell.memo=[[dict objectForKey:@"image"] objectForKey:@"memo"];
    }
    if ([dict objectForKey:@"text"]) {
        cell.discrip=[dict objectForKey:@"text"];
        NSLog(@"%@",[dict objectForKey:@"text"]);
    }
    if ([dict objectForKey:@"commentCount"]) {
        cell.comment=[dict objectForKey:@"commentCount"];
    }
    if ([dict objectForKey:@"likeCount"]) {
        cell.like=[dict objectForKey:@"likeCount"];
    }
    if ([dict objectForKey:@"poiName"]) {
        cell.poiName=[dict objectForKey:@"poiName"];
    }else
    {
        cell.poiName=@"";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    UIImageView *leftPic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 14, 40)];
    leftPic.image=[UIImage imageNamed:@"daysSign.png"];
    [view addSubview:leftPic];
    NSString *time=[self getTimeToShowWithTimestamp:[[[_dataArray objectAtIndex:section] objectAtIndex:section] objectForKey:@"date"]];
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(26, 0, self.view.bounds.size.width, 40)];
    date.text=[NSString stringWithFormat:@"Day %d %@",((int)section+1),time];
    date.textColor=[UIColor blackColor];
    date.font=[UIFont boldSystemFontOfSize:14];
    [view addSubview:date];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count!=0) {
        NSDictionary *dict=[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if([dict objectForKey:@"poiDesc"])
        {
            NSLog(@"%@",[dict objectForKey:@"poiDesc"]);
            CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH-1, 1000);
            UIFont *font=[UIFont systemFontOfSize:12];
            NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            CGSize actualSize=[[dict objectForKey:@"poiDesc"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            NSLog(@"section=%lu,row=%lu,height=%f",indexPath.section,indexPath.row,actualSize.height+15);
            return actualSize.height+20;
        }else
        {
            if (![[dict objectForKey:@"image"] objectForKey:@"imgUrl"]) {
                
                CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH-1, 1000);
                UIFont *font=[UIFont systemFontOfSize:12];
                NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                CGSize actualSize=[[dict objectForKey:@"text"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
                NSLog(@"section=%lu,row=%lu,height=%f",indexPath.section,indexPath.row,actualSize.height+5+30);
                return actualSize.height+5+35;
            }
            else
            {
                NSDictionary *dictImage=[dict objectForKey:@"image"];
                CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH-1, 1000);
                UIFont *font=[UIFont systemFontOfSize:12];
                NSDictionary *dict1=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
                if ([[dictImage objectForKey:@"memo"]isEqualToString:@""]) {
                    return 1+5+230+50;
                }
                CGSize actualSize=[[dictImage objectForKey:@"memo"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
                NSLog(@"section=%lu,row=%lu,height=%f",indexPath.section,indexPath.row,actualSize.height+1+5+230+40);

                return actualSize.height+1+5+230+45;
            }
        }
        
    }else return 0;
    
}

-(NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp
{
    NSTimeInterval publishString = [timestamp doubleValue]+28800;
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString * returnString = [formatter stringFromDate:publishDate];
    
    return returnString;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
