//
//  TourDestinationDetailViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-13.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "TourDestinationDetailViewController.h"
#import "LVTourCell.h"
#import "LVProductCell.h"
#import "LVTourCommentCell.h"
@interface TourDestinationDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TourDestinationDetailViewController
{
    UIWebView *_webView;
    UIScrollView *_tourScrollView;
    NSMutableArray *_dataArray;
    NSMutableArray *_textArray;
    NSMutableArray *_commentArray;
    UITableView *_textTableView;
    UITableView *_productTableView;
    UITableView *_commentTableView;
    UITableView *_photoTableView;
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
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_SHOW,self.ID] and:8];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourDownloadFinish) name:[NSString stringWithFormat:TOUR_SHOW,self.ID] object:nil];
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_TEXT,self.ID] and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourTextDownloadFinish) name:[NSString stringWithFormat:TOUR_TEXT,self.ID] object:nil];
    
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:TOUR_COMMENT,self.ID] and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentDownloadFinish) name:[NSString stringWithFormat:TOUR_COMMENT,self.ID] object:nil];
    NSLog(@"text=%@",[NSString stringWithFormat:TOUR_TEXT,self.ID]);
    self.title=self.deTitle;
    [self leftButton];
    [self createScrollView];
    [self createWebView];
    [self createPhoto];

	// Do any additional setup after loading the view.
}
-(void)commentDownloadFinish
{
    _commentArray=[[NSMutableArray alloc]initWithCapacity:0];
    _commentArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_COMMENT,self.ID]];
    if (_commentArray.count) {
        [_commentArray removeLastObject];
    }
    [self createCommentTableView];
}
-(void)createCommentTableView
{
    if (!_commentTableView) {
        _commentTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30-64) style:UITableViewStylePlain];
        _commentTableView.delegate=self;
        _commentTableView.dataSource=self;
        _commentTableView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.view insertSubview:_commentTableView belowSubview:_webView];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30)];
        view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _commentTableView.tableFooterView=view;

        if (_commentArray.count==0) {
            UIView *view=_commentTableView.tableFooterView;
            view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
            _commentTableView.tableFooterView=view;
            UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lvDefault.png"]];
            logo.frame=CGRectMake(0, 160, self.view.bounds.size.width, 55);
            [view addSubview:logo];
            logo.contentMode=UIViewContentModeCenter;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 55+160+10, self.view.bounds.size.width, 20)];
            label.text=@"还没有人评论";
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            [view addSubview:label];
        }
    }else
    {
        [self.view bringSubviewToFront:_commentTableView];
        [_commentTableView reloadData];
    }
}
-(void)TourTextDownloadFinish
{
    _textArray=[[NSMutableArray alloc]initWithCapacity:0];
    _textArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_TEXT,self.ID]];
    if (_textArray.count) {
        [_textArray removeLastObject];

    }
    [self createTextTableView];
}
-(void)createTextTableView
{
    if (!_textTableView) {
        _textTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30-64) style:UITableViewStylePlain];
        _textTableView.delegate=self;
        _textTableView.dataSource=self;
        _textTableView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.view insertSubview:_textTableView belowSubview:_webView];
        if (_textArray.count==0) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30)];
            view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
            _textTableView.tableFooterView=view;
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
    }else
    {
        [self.view bringSubviewToFront:_textTableView];
        [_textTableView reloadData];
    }
}
-(void)createWebView
{
    if (!_webView) {
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30)];
        [self.view addSubview:_webView];
    }else{
        NSDictionary *dict=[_dataArray objectAtIndex:0];
        [_webView loadHTMLString:[dict objectForKey:@"simple"] baseURL:nil];
        [self.view bringSubviewToFront:_webView];
    }
}
-(void)createScrollView
{
    UIScrollView *scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    scrol.showsHorizontalScrollIndicator=NO;
    scrol.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrol];
    NSArray *array=[NSArray arrayWithObjects:@"简介",@"旅行地",@"游记",@"照片墙",@"相关产品",@"点评",nil];
    int x=10;
    for (int i=0; i<array.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
        label.font=[UIFont systemFontOfSize:15];
        label.text=[array objectAtIndex:i];
        
        CGSize size=CGSizeMake(self.view.bounds.size.width, 30);
        UIFont *font=[UIFont systemFontOfSize:15];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[[array objectAtIndex:i] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        label.frame=CGRectMake(x, 0, actualSize.width, 30);
        [scrol addSubview:label];
        label.userInteractionEnabled=YES;
        
        UIButton *btn=[[UIButton alloc]initWithFrame:label.bounds];
        btn.tag=100+i;
        [label addSubview:btn];
        [btn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];

        if (i==array.count-1) {
            scrol.contentSize=CGSizeMake(x+actualSize.width+10, 0);
        }
        if (iPhone6Plus) {
            x+=actualSize.width+30;
        }else
        {
            x+=actualSize.width+15;
        }
        
        if (i==0) {
            label.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
            btn.selected=YES;
        }else
            label.textColor=[UIColor grayColor];

    }
}
-(void)scrollClick:(UIButton *)button
{
    for (UILabel *label in button.superview.superview.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor=[UIColor grayColor];
        }
        for (UIButton *btn in label.subviews) {
            btn.selected=NO;
        }
    }
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    if (button.tag==100) {
        [self createWebView];
    }else if (button.tag==101)
    {
        [self createTourAddress];
    }else if (button.tag==102)
    {
        [self createTextTableView];
    }else if (button.tag==104)
    {
        [self createProductTableView];
    }
    else if (button.tag==105)
    {
        [self createCommentTableView];
    }else if (button.tag==103)
    {
        [self createPhoto];
    }
}

-(void)createPhoto
{
    if (!_photoTableView) {
        _photoTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30-64) style:UITableViewStylePlain];
        _photoTableView.delegate=self;
        _photoTableView.dataSource=self;
        _photoTableView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.view insertSubview:_photoTableView belowSubview:_webView];
        
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30)];
            view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
            _photoTableView.tableFooterView=view;
            UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lvDefault.png"]];
            logo.frame=CGRectMake(0, 160, self.view.bounds.size.width, 55);
            [view addSubview:logo];
            logo.contentMode=UIViewContentModeCenter;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 55+160+10, self.view.bounds.size.width, 20)];
            label.text=@"没有找到相关数据";
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            [view addSubview:label];
    }else
    {
        [self.view bringSubviewToFront:_photoTableView];
    }
}

-(void)createTourAddress
{
    if (!_tourScrollView) {
        _tourScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        _tourScrollView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _tourScrollView.contentSize=CGSizeMake(0, _tourScrollView.bounds.size.height+1);
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, (self.view.bounds.size.width-5))];
        view.backgroundColor=[UIColor whiteColor];
        UILabel *hint=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 200, 20)];
        [view addSubview:hint];
        hint.text=@"必去景点";
        hint.font=[UIFont systemFontOfSize:12];
        [_tourScrollView addSubview:view];
        [self.view insertSubview:_tourScrollView belowSubview:_webView];
        UILabel *getMore=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 0, 60, 20)];
        getMore.text=@"更多";
        getMore.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
        getMore.font=[UIFont systemFontOfSize:12];
        [view addSubview:getMore];
        
        UIImageView *more=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chackMore.png"]];
        more.frame=CGRectMake(self.view.bounds.size.width-13,5,6,10);
        [view addSubview:more];
        int count=0;
        for (int j=0; j<2; j++) {
            for (int i=0; i<2; i++) {
                NSDictionary *item=[[[_dataArray objectAtIndex:0] objectForKey:@"view"] objectAtIndex:count];
                UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*(self.view.bounds.size.width-20)/2, 30+j*(self.view.bounds.size.width-20)/2, (self.view.bounds.size.width-25)/2, (self.view.bounds.size.width-25)/2)];
                [pic sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"defaultFocusImage.png"]];
                [_tourScrollView addSubview:pic];

                UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, pic.bounds.size.height-30, pic.bounds.size.width, 30)];
                backView.backgroundColor=[UIColor blackColor];
                backView.alpha=0.5;
                [pic addSubview:backView];
                
                UILabel *name=[[UILabel alloc]initWithFrame:backView.frame];
                name.text=[item objectForKey:@"name"];
                name.font=[UIFont boldSystemFontOfSize:12];
                name.textColor=[UIColor whiteColor];
                name.textAlignment=NSTextAlignmentCenter;
                [pic addSubview:name];
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=pic.bounds;
                button.tag=100+count;
                pic.userInteractionEnabled=YES;
                [pic addSubview:button];
                [button addTarget:self action:@selector(tourClick:) forControlEvents:UIControlEventTouchUpInside];
                count++;
            }
        }
    }else
    {
        [self.view bringSubviewToFront:_tourScrollView];
    }
}

-(void)tourClick:(UIButton *)button
{
    TourDestinationDetailViewController *tour=[[TourDestinationDetailViewController alloc]init];
    NSDictionary *item=[[[_dataArray objectAtIndex:0] objectForKey:@"view"] objectAtIndex:(button.tag-100)];
    tour.deTitle=[item objectForKey:@"name"];
    tour.ID=[item objectForKey:@"id"];
    [self.navigationController pushViewController:tour animated:YES];
}


-(void)TourDownloadFinish
{
    _dataArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:TOUR_SHOW,self.ID]];
    [self createWebView];
    [self createTourAddress];
    [self createProductTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_textTableView) {
        return _textArray.count;
    }else if (tableView==_productTableView)
    {
       return [[[_dataArray objectAtIndex:0]objectForKey:@"products"] count];
    }else if (tableView==_commentTableView)
    {
        return _commentArray.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_textTableView) {
        static NSString *cellName=@"TourCell";
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
        
        NSDictionary *dict=[_textArray objectAtIndex:indexPath.row];
        cell.cellPic=[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"thumb"]];
        cell.cellThumb=[[_textArray objectAtIndex:indexPath.row]objectForKey:@"userImg"];
        cell.cellTitle=[[_textArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        cell.cellUserName=[dict objectForKey:@"username"];
        
        return cell;
    }else if (tableView==_productTableView)
    {
        static NSString *cellName=@"ProductCell";
        LVProductCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[LVProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.cellPic.image=nil;
        cell.cellTitle.text=@"";
        NSDictionary *dict=[[[_dataArray objectAtIndex:0] objectForKey:@"products"] objectAtIndex:indexPath.row];
        cell.pic=[NSString stringWithFormat:@"http://pic.lvmama.com/%@",[dict objectForKey:@"imageThumb"]];
        cell.title=[dict objectForKey:@"productName"];
        
        return cell;
    }else if (tableView==_commentTableView)
    {
        static NSString *cellName=@"CommentCell";
        LVTourCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[LVTourCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.cellPic.image=nil;
        cell.cellTime.text=@"";
        cell.cellTitle.text=@"";
        NSDictionary *dict=[_commentArray objectAtIndex:indexPath.row];
        cell.pic=[dict objectForKey:@"userImage"];
        cell.time=[dict objectForKey:@"createTime"];
        cell.userName=[dict objectForKey:@"userName"];
        cell.userContent=[dict objectForKey:@"memo"];
        return cell;
    }
    else
    {
        static NSString *cellName=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

-(void)createProductTableView
{
    if (!_productTableView) {
        _productTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-30-64) style:UITableViewStylePlain];
        _productTableView.delegate=self;
        _productTableView.dataSource=self;
        _productTableView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self.view insertSubview:_productTableView belowSubview:_webView];
        if ([[[_dataArray objectAtIndex:0] objectForKey:@"products"] count]==0) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30)];
            view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
            _textTableView.tableFooterView=view;
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
    }else
    {
        [self.view bringSubviewToFront:_productTableView];
        [_productTableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_textTableView) {
        return 305;
    }else if (tableView==_productTableView)
    {
        if (iPhone6Plus) {
            return 70+20;
        }else
        {
            return 70;
        }
    }else if (tableView==_commentTableView)
    {
        return 60;
    }
    else return 80;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
