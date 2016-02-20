//
//  HomePindaoViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/24.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomePindaoViewController.h"
#import "PindaoDetailViewController.h"
#import "LVPindaoHeadCell.h"
#import "LVPindaoCell.h"
#import "LogInViewController.h"
#import "LimitInfoViewController.h"
//section的类型的数量
#define SECTION_NUM 5

#define WIDTH 8

#define SECTION_HEIGHT 30
@interface HomePindaoViewController ()<UITableViewDataSource,UITableViewDelegate,Pic,Pay>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *LVTableView;;
@property(nonatomic,strong)UIView *headerView;;
@property(nonatomic,strong)UIScrollView *scrol;
@property(nonatomic,assign)int timerCount;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,assign)int scollCount;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *headerArray;
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)UIView *sectionView;
@end

@implementation HomePindaoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
    if (!_LVTableView) {
        [self createNavigation];
        [self createTableView];
        [self hudShow];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoDownloadFinish) name:PINDAO_GROUP object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_GROUP and:12];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoAroundDownloadFinish) name:PINDAO_AROUND object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_AROUND and:12];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    // Do any additional setup after loading the view.
}
-(void)pindaoDownloadFinish
{
    _headerArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSDictionary *dict=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:PINDAO_GROUP];
    _headerArray=[dict objectForKey:@"recommandList"];
    [self createTabLeHeaderView];
}
-(void)pindaoAroundDownloadFinish
{
    NSDictionary *dict=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:PINDAO_AROUND];
    _dataArray=[dict objectForKey:@"ropGroupbuyList"];
    [self hudHide];
    [self.LVTableView reloadData];
}
-(void)pindaoAbroadDownloadFinish
{
    NSDictionary *dict=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:PINDAO_ABROAD];
    _dataArray=[dict objectForKey:@"ropGroupbuyList"];
    [self hudHide];
    [self.LVTableView reloadData];
}
-(void)pindaoTicketDownloadFinish
{
    NSDictionary *dict=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:PINDAO_TICKET];
    _dataArray=[dict objectForKey:@"ropGroupbuyList"];
    [self hudHide];
    [self.LVTableView reloadData];
}
-(void)pindaoShipDownloadFinish
{
    NSDictionary *dict=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:PINDAO_SHIP];
    _dataArray=[dict objectForKey:@"ropGroupbuyList"];
    [self hudHide];
    [self.LVTableView reloadData];
}
-(void)pindaoChinaDownloadFinish
{
    NSDictionary *dict=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:PINDAO_CHINA];
    _dataArray=[dict objectForKey:@"ropGroupbuyList"];
    [self hudHide];
    [self.LVTableView reloadData];
}

-(void)createNavigation
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:navView];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 17, self.view.bounds.size.width, 44)];
    title.text=@"特卖会";
    title.textColor=[UIColor blackColor];
    title.font=[UIFont boldSystemFontOfSize:18];
    title.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:title];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 30, 36)];
    address.text=@"北京";
    address.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
    address.font=[UIFont boldSystemFontOfSize:14];
    address.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:address];
    
    UIImageView *arrowDown=[[UIImageView alloc]initWithFrame:CGRectMake(address.bounds.size.width+address.frame.origin.x+2, 36, 8, 5)];
    arrowDown.image=[UIImage imageNamed:@"arrowDownRed.png"];
    [navView addSubview:arrowDown];
    
    UIButton *code=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 36, 36)];
    [code setImage:[UIImage imageNamed:@"filtrateBack.png"] forState:UIControlStateNormal];
    [code addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:code];
    
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line.frame=CGRectMake(0, 63, self.view.bounds.size.width, 1);
    line.alpha=0.5;
    [self.view addSubview:line];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTabLeFooterView
{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,30)];
    footView.backgroundColor=[UIColor whiteColor];
    UILabel *more=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.view.bounds.size.width, 30)];
    more.text=@"查看更多特卖产品";
    more.font=[UIFont systemFontOfSize:12];
    more.textColor=[UIColor blackColor];
    [footView addSubview:more];
    UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow.png"]];
    arrow.frame=CGRectMake(self.view.bounds.size.width-25, 7.5, 10, 15);
    [footView addSubview:arrow];
    _LVTableView.tableFooterView=footView;
    UIImageView *lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    lineSe.frame=CGRectMake(0, -1, self.view.bounds.size.width, 1);
    [footView addSubview:lineSe];
    
    UIImageView *lineSe1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    lineSe1.frame=CGRectMake(0, 29, self.view.bounds.size.width, 1);
    [footView addSubview:lineSe1];
    
    UIButton *footButton=[UIButton buttonWithType:UIButtonTypeCustom];
    footButton.frame=footView.bounds;
    [footView addSubview:footButton];
    [footButton addTarget:self action:@selector(footClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)footClick
{
    
}
-(void)createTabLeHeaderView
{
    if (!_scrol) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1000)];
        _headerView.backgroundColor=[UIColor whiteColor];
        _LVTableView.tableHeaderView=_headerView;
        _scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1000)];
        _scrol.backgroundColor=[UIColor redColor];
        _scrol.pagingEnabled=YES;
        _scrol.bounces=NO;
        _scrol.showsHorizontalScrollIndicator=NO;
        _scrol.showsVerticalScrollIndicator=NO;
        _scrol.backgroundColor=[UIColor whiteColor];
        [_headerView addSubview:_scrol];
        _scrol.delegate=self;
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 245, self.view.bounds.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0.83 green:0.03 blue:0.46 alpha:1];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        [_headerView addSubview:_pageControl];
    }
    
    if (_headerArray.count&&_scrol) {
        _scollCount=(int)_headerArray.count;
        _pageControl.numberOfPages=_scollCount;
        UILabel *channelTagLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+3, 0, 67, 25)];
        channelTagLabel.text=[NSString stringWithFormat:@"精品秒杀"];
        channelTagLabel.font=[UIFont systemFontOfSize:11];
        channelTagLabel.textColor=[UIColor blackColor];
        channelTagLabel.textAlignment=NSTextAlignmentLeft;
        [_headerView addSubview:channelTagLabel];
        
        UILabel *getMore=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 0, 60, 25)];
        getMore.text=@"更多";
        getMore.textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];
        getMore.font=[UIFont systemFontOfSize:11];
        [_headerView addSubview:getMore];
        
        UIImageView *more=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chackMore.png"]];
        more.frame=CGRectMake(self.view.bounds.size.width-15,8,6,10);
        [_headerView addSubview:more];
        
        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame=getMore.frame;
        [moreButton addTarget:self action:@selector(getMore:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:moreButton];
        
        for (int i=0; i<_scollCount; i++) {
            _scrol.contentSize=CGSizeMake(self.view.bounds.size.width*(_scollCount+1), 0);
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width,25, self.view.bounds.size.width, 130)];
            NSDictionary *dict=[_headerArray objectAtIndex:i];
            
            [imageView sd_setImageWithURL:[dict objectForKey:@"smallImage"]];
            
            [_scrol addSubview:imageView];

            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(33+imageView.frame.origin.x, imageView.bounds.size.height+25, self.view.bounds.size.width-28-20, 30)];
            titleLabel.text=[dict objectForKey:@"productName"];
            titleLabel.font=[UIFont boldSystemFontOfSize:12];
            titleLabel.textColor=[UIColor grayColor];
            titleLabel.numberOfLines=1;
            titleLabel.textAlignment=NSTextAlignmentLeft;
            [_scrol addSubview:titleLabel];
            
            UILabel *discountLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+imageView.frame.origin.x, titleLabel.frame.origin.y+10, self.view.bounds.size.width-5, 20)];
            discountLabel.text=[NSString stringWithFormat:@"%.1f折",roundf([[dict objectForKey:@"discount"] floatValue]*10)/10];
            discountLabel.font=[UIFont boldSystemFontOfSize:9];
            discountLabel.textColor=[UIColor whiteColor];
            discountLabel.textAlignment=NSTextAlignmentLeft;
            discountLabel.backgroundColor=[UIColor clearColor];
            [discountLabel sizeToFit];
            
            UIImageView *discountBack=[[UIImageView alloc]initWithFrame:CGRectMake(discountLabel.frame.origin.x-1, discountLabel.frame.origin.y, discountLabel.frame.size.width+2, discountLabel.frame.size.height)];
            discountBack.image=[UIImage imageNamed:@"voiceWindowBtnStartNormal@2x.png"];
            [_scrol addSubview:discountBack];
            [_scrol addSubview:discountLabel];
            
            UILabel *sellPriceYuanLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+imageView.frame.origin.x, discountLabel.frame.origin.y+discountLabel.frame.size.height+5, 200, 40)];
            sellPriceYuanLabel.text=[NSString stringWithFormat:@"疯抢价￥%d起",[[dict objectForKey:@"sellPriceYuan"] intValue]];
            sellPriceYuanLabel.font=[UIFont systemFontOfSize:12];
            sellPriceYuanLabel.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
            sellPriceYuanLabel.textAlignment=NSTextAlignmentLeft;
            [_scrol addSubview:sellPriceYuanLabel];
            
            NSString *string=[NSString stringWithFormat:@"疯抢价￥%d起",[[dict objectForKey:@"sellPriceYuan"] intValue]];
            UIFont *font=[UIFont systemFontOfSize:15];
            UIFont *font0=[UIFont systemFontOfSize:11];

            NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc]initWithString:string];
            NSDictionary *color=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
            
            NSDictionary *fontDict0=[[NSDictionary alloc]initWithObjectsAndKeys:font0,NSFontAttributeName,nil];

            [attribute addAttributes:color range:NSMakeRange(3, string.length-4)];
            [attribute addAttributes:fontDict0 range:NSMakeRange(0, 3)];
            sellPriceYuanLabel.attributedText=attribute;
            
            [sellPriceYuanLabel sizeToFit];
            
            UILabel *marketPriceYuanLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+10+sellPriceYuanLabel.frame.size.width, sellPriceYuanLabel.frame.origin.y+5, 200, 40)];
            marketPriceYuanLabel.text=[NSString stringWithFormat:@"￥%d",[[dict objectForKey:@"marketPriceYuan"] intValue]];
            marketPriceYuanLabel.font=[UIFont systemFontOfSize:9];
            marketPriceYuanLabel.textColor=[UIColor lightGrayColor];
            marketPriceYuanLabel.textAlignment=NSTextAlignmentLeft;
            [_scrol addSubview:marketPriceYuanLabel];
            [marketPriceYuanLabel sizeToFit];
            
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0,marketPriceYuanLabel.bounds.size.height/2-1, marketPriceYuanLabel.bounds.size.width, 1.5)];
            line.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
            [marketPriceYuanLabel addSubview:line];
            
            UILabel *stockCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+self.view.bounds.size.width-120, discountLabel.frame.origin.y+discountLabel.frame.size.height-3, 115, 40)];
            stockCountLabel.text=[NSString stringWithFormat:@"剩余%d份",[[dict objectForKey:@"stockCount"] intValue]];
            stockCountLabel.font=[UIFont systemFontOfSize:10];
            stockCountLabel.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
            stockCountLabel.textAlignment=NSTextAlignmentRight;
            [_scrol addSubview:stockCountLabel];
            
            NSString *stockCountstring=[NSString stringWithFormat:@"剩余%d份",[[dict objectForKey:@"stockCount"] intValue]];
            NSMutableAttributedString *stockAttribute=[[NSMutableAttributedString alloc]initWithString:stockCountstring];
            NSDictionary *stockColor=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
            [stockAttribute addAttributes:stockColor range:NSMakeRange(2,stockCountstring.length-3)];
            stockCountLabel.attributedText=stockAttribute;
            
            UIImageView *lineSe=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
            lineSe.frame=CGRectMake(imageView.frame.origin.x,sellPriceYuanLabel.frame.origin.y+sellPriceYuanLabel.bounds.size.height+6, imageView.bounds.size.width, 1);
            lineSe.alpha=0.3;
            [_scrol addSubview:lineSe];
            
            UILabel *recommandNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+imageView.frame.origin.x, lineSe.frame.origin.y+10, self.view.bounds.size.width-WIDTH*2, 30)];
            recommandNameLabel.text=[dict objectForKey:@"recommandName"];
            recommandNameLabel.font=[UIFont systemFontOfSize:12];
            recommandNameLabel.textColor=[UIColor lightGrayColor];
            recommandNameLabel.numberOfLines=2;
            recommandNameLabel.textAlignment=NSTextAlignmentLeft;
            [_scrol addSubview:recommandNameLabel];
            [recommandNameLabel sizeToFit];
            
            UIImageView *grayArear=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
            grayArear.frame=CGRectMake(imageView.frame.origin.x,lineSe.frame.origin.y+10+30+20, self.view.bounds.size.width, 10);
            [_scrol addSubview:grayArear];
            
            _scrol.frame=CGRectMake(0, 0, self.view.bounds.size.width, grayArear.frame.origin.y+grayArear.bounds.size.height);
            _headerView.frame=CGRectMake(0, 0, self.view.bounds.size.width, grayArear.frame.origin.y+grayArear.bounds.size.height);
            UIView *headerView=_LVTableView.tableHeaderView;
            headerView.frame=_headerView.frame;
            
            UIButton *scrollViewButton=[UIButton buttonWithType:UIButtonTypeCustom];
            scrollViewButton.frame=CGRectMake(imageView.frame.origin.x, 0, imageView.frame.size.width, _scrol.frame.size.height);
            [scrollViewButton addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
            scrollViewButton.tag=100+i;
            [_scrol addSubview:scrollViewButton];
            
            _LVTableView.tableHeaderView=headerView;
        }
        
        //最后一张图
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake((_scollCount+1)*self.view.bounds.size.width,25, self.view.bounds.size.width, 130)];
        NSDictionary *dict1=[_headerArray objectAtIndex:0];
        [imageView1 sd_setImageWithURL:[dict1 objectForKey:@"smallImage"]];
        [_scrol addSubview:imageView1];
        
        UILabel *titleLabel1=[[UILabel alloc]initWithFrame:CGRectMake(33+imageView1.frame.origin.x, imageView1.bounds.size.height+25, self.view.bounds.size.width-28-20, 30)];
        titleLabel1.text=[dict1 objectForKey:@"productName"];
        titleLabel1.font=[UIFont boldSystemFontOfSize:12];
        titleLabel1.textColor=[UIColor grayColor];
        titleLabel1.numberOfLines=1;
        titleLabel1.textAlignment=NSTextAlignmentLeft;
        [_scrol addSubview:titleLabel1];
        
        UILabel *discountLabel1=[[UILabel alloc]initWithFrame:CGRectMake(8+imageView1.frame.origin.x, titleLabel1.frame.origin.y+10, self.view.bounds.size.width-5, 20)];
        discountLabel1.text=[NSString stringWithFormat:@"%.1f折",roundf([[dict1 objectForKey:@"discount"] floatValue]*10)/10];
        discountLabel1.font=[UIFont boldSystemFontOfSize:9];
        discountLabel1.textColor=[UIColor whiteColor];
        discountLabel1.textAlignment=NSTextAlignmentLeft;
        discountLabel1.backgroundColor=[UIColor clearColor];
        [discountLabel1 sizeToFit];
        
        UIImageView *discountBack1=[[UIImageView alloc]initWithFrame:CGRectMake(discountLabel1.frame.origin.x-1, discountLabel1.frame.origin.y, discountLabel1.frame.size.width+2, discountLabel1.frame.size.height)];
        discountBack1.image=[UIImage imageNamed:@"voiceWindowBtnStartNormal@2x.png"];
        [_scrol addSubview:discountBack1];
        [_scrol addSubview:discountLabel1];
        
        UILabel *sellPriceYuanLabel1=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+imageView1.frame.origin.x, discountLabel1.frame.origin.y+discountLabel1.frame.size.height+5, 200, 40)];
        sellPriceYuanLabel1.text=[NSString stringWithFormat:@"疯抢价￥%d起",[[dict1 objectForKey:@"sellPriceYuan"] intValue]];
        sellPriceYuanLabel1.font=[UIFont systemFontOfSize:12];
        sellPriceYuanLabel1.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        sellPriceYuanLabel1.textAlignment=NSTextAlignmentLeft;
        [_scrol addSubview:sellPriceYuanLabel1];
        
        NSString *string1=[NSString stringWithFormat:@"疯抢价￥%d起",[[dict1 objectForKey:@"sellPriceYuan"] intValue]];
        UIFont *font1=[UIFont systemFontOfSize:15];
        UIFont *font01=[UIFont systemFontOfSize:11];
        
        NSMutableAttributedString *attribute1=[[NSMutableAttributedString alloc]initWithString:string1];
        NSDictionary *color1=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,font1,NSFontAttributeName,nil];
        
        NSDictionary *fontDict01=[[NSDictionary alloc]initWithObjectsAndKeys:font01,NSFontAttributeName,nil];
        
        [attribute1 addAttributes:color1 range:NSMakeRange(3, string1.length-4)];
        [attribute1 addAttributes:fontDict01 range:NSMakeRange(0, 3)];
        sellPriceYuanLabel1.attributedText=attribute1;
        
        [sellPriceYuanLabel1 sizeToFit];
        
        UILabel *marketPriceYuanLabel1=[[UILabel alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x+10+sellPriceYuanLabel1.frame.size.width, sellPriceYuanLabel1.frame.origin.y+5, 200, 40)];
        marketPriceYuanLabel1.text=[NSString stringWithFormat:@"￥%d",[[dict1 objectForKey:@"marketPriceYuan"] intValue]];
        marketPriceYuanLabel1.font=[UIFont systemFontOfSize:9];
        marketPriceYuanLabel1.textColor=[UIColor lightGrayColor];
        marketPriceYuanLabel1.textAlignment=NSTextAlignmentLeft;
        [_scrol addSubview:marketPriceYuanLabel1];
        [marketPriceYuanLabel1 sizeToFit];
        
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0,marketPriceYuanLabel1.bounds.size.height/2-1, marketPriceYuanLabel1.bounds.size.width, 1.5)];
        line1.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [marketPriceYuanLabel1 addSubview:line1];
        
        UIImageView *lineSe1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        lineSe1.frame=CGRectMake(imageView1.frame.origin.x,sellPriceYuanLabel1.frame.origin.y+sellPriceYuanLabel1.bounds.size.height+6, imageView1.bounds.size.width, 1);
        lineSe1.alpha=0.3;
        [_scrol addSubview:lineSe1];
        
        UIImageView *grayArear1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear1.frame=CGRectMake(imageView1.frame.origin.x,lineSe1.frame.origin.y+10+30+20, self.view.bounds.size.width, 10);
        [_scrol addSubview:grayArear1];
        
        UILabel *stockCountLabel1=[[UILabel alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x+self.view.bounds.size.width-120, discountLabel1.frame.origin.y+discountLabel1.frame.size.height-3, 115, 40)];
        stockCountLabel1.text=[NSString stringWithFormat:@"剩余%d份",[[dict1 objectForKey:@"stockCount"] intValue]];
        stockCountLabel1.font=[UIFont systemFontOfSize:10];
        stockCountLabel1.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        stockCountLabel1.textAlignment=NSTextAlignmentRight;
        [_scrol addSubview:stockCountLabel1];
        
        NSString *stockCountstring1=[NSString stringWithFormat:@"剩余%d份",[[dict1 objectForKey:@"stockCount"] intValue]];
        NSMutableAttributedString *stockAttribute1=[[NSMutableAttributedString alloc]initWithString:stockCountstring1];
        NSDictionary *stockColor1=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
        [stockAttribute1 addAttributes:stockColor1 range:NSMakeRange(2,stockCountstring1.length-3)];
        stockCountLabel1.attributedText=stockAttribute1;
        
        
        //第一张图左边的（最后一张图）
        UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 130)];
        NSDictionary *dict0=[_headerArray objectAtIndex:(_scollCount-1)];
        [imageView0 sd_setImageWithURL:[dict0 objectForKey:@"smallImage"]];
        
        UILabel *titleLabel0=[[UILabel alloc]initWithFrame:CGRectMake(33+imageView0.frame.origin.x, imageView0.bounds.size.height+25, self.view.bounds.size.width-28-20, 30)];
        titleLabel0.text=[dict0 objectForKey:@"productName"];
        titleLabel0.font=[UIFont boldSystemFontOfSize:12];
        titleLabel0.textColor=[UIColor grayColor];
        titleLabel0.numberOfLines=1;
        titleLabel0.textAlignment=NSTextAlignmentLeft;
        [_scrol addSubview:titleLabel0];
        
        UILabel *discountLabel0=[[UILabel alloc]initWithFrame:CGRectMake(8+imageView0.frame.origin.x, titleLabel0.frame.origin.y+10, self.view.bounds.size.width-5, 20)];
        discountLabel0.text=[NSString stringWithFormat:@"%.1f折",roundf([[dict0 objectForKey:@"discount"] floatValue]*10)/10];
        discountLabel0.font=[UIFont boldSystemFontOfSize:9];
        discountLabel0.textColor=[UIColor whiteColor];
        discountLabel0.textAlignment=NSTextAlignmentLeft;
        discountLabel0.backgroundColor=[UIColor clearColor];
        [discountLabel0 sizeToFit];
        
        UIImageView *discountBack0=[[UIImageView alloc]initWithFrame:CGRectMake(discountLabel0.frame.origin.x-1, discountLabel0.frame.origin.y, discountLabel0.frame.size.width+2, discountLabel0.frame.size.height)];
        discountBack0.image=[UIImage imageNamed:@"voiceWindowBtnStartNormal@2x.png"];
        [_scrol addSubview:discountBack0];
        [_scrol addSubview:discountLabel0];
        
        UILabel *sellPriceYuanLabel0=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH+imageView0.frame.origin.x, discountLabel0.frame.origin.y+discountLabel0.frame.size.height+5, 200, 40)];
        sellPriceYuanLabel0.text=[NSString stringWithFormat:@"疯抢价￥%d起",[[dict0 objectForKey:@"sellPriceYuan"] intValue]];
        sellPriceYuanLabel0.font=[UIFont systemFontOfSize:12];
        sellPriceYuanLabel0.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        sellPriceYuanLabel0.textAlignment=NSTextAlignmentLeft;
        [_scrol addSubview:sellPriceYuanLabel0];
        
        NSString *string0=[NSString stringWithFormat:@"疯抢价￥%d起",[[dict0 objectForKey:@"sellPriceYuan"] intValue]];
        UIFont *font0=[UIFont systemFontOfSize:15];
        UIFont *font00=[UIFont systemFontOfSize:11];
        
        NSMutableAttributedString *attribute0=[[NSMutableAttributedString alloc]initWithString:string0];
        NSDictionary *color0=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,font0,NSFontAttributeName,nil];
        
        NSDictionary *fontDict0=[[NSDictionary alloc]initWithObjectsAndKeys:font00,NSFontAttributeName,nil];
        
        [attribute0 addAttributes:color0 range:NSMakeRange(3, string0.length-4)];
        [attribute0 addAttributes:fontDict0 range:NSMakeRange(0, 3)];
        sellPriceYuanLabel0.attributedText=attribute0;
        
        [sellPriceYuanLabel0 sizeToFit];
        
        UILabel *marketPriceYuanLabel0=[[UILabel alloc]initWithFrame:CGRectMake(imageView0.frame.origin.x+10+sellPriceYuanLabel0.frame.size.width, sellPriceYuanLabel0.frame.origin.y+5, 200, 40)];
        marketPriceYuanLabel0.text=[NSString stringWithFormat:@"￥%d",[[dict0 objectForKey:@"marketPriceYuan"] intValue]];
        marketPriceYuanLabel0.font=[UIFont systemFontOfSize:9];
        marketPriceYuanLabel0.textColor=[UIColor lightGrayColor];
        marketPriceYuanLabel0.textAlignment=NSTextAlignmentLeft;
        [_scrol addSubview:marketPriceYuanLabel0];
        [marketPriceYuanLabel0 sizeToFit];
        
        UIImageView *line0=[[UIImageView alloc]initWithFrame:CGRectMake(0,marketPriceYuanLabel0.bounds.size.height/2-1, marketPriceYuanLabel0.bounds.size.width, 1.5)];
        line0.image=[UIImage imageNamed:@"hotelSeparateShiXian.png"];
        [marketPriceYuanLabel0 addSubview:line0];
        
        UIImageView *lineSe0=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        lineSe0.frame=CGRectMake(imageView0.frame.origin.x,sellPriceYuanLabel0.frame.origin.y+sellPriceYuanLabel0.bounds.size.height+6, imageView0.bounds.size.width, 1);
        lineSe0.alpha=0.3;
        [_scrol addSubview:lineSe0];
        
        UIImageView *grayArear0=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inputBg.png"]];
        grayArear0.frame=CGRectMake(imageView0.frame.origin.x,lineSe0.frame.origin.y+10+30+20, self.view.bounds.size.width, 10);
        [_scrol addSubview:grayArear0];
        
        UILabel *stockCountLabel0=[[UILabel alloc]initWithFrame:CGRectMake(imageView0.frame.origin.x+self.view.bounds.size.width-120, discountLabel0.frame.origin.y+discountLabel0.frame.size.height-3, 115, 40)];
        stockCountLabel0.text=[NSString stringWithFormat:@"剩余%d份",[[dict0 objectForKey:@"stockCount"] intValue]];
        stockCountLabel0.font=[UIFont systemFontOfSize:10];
        stockCountLabel0.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        stockCountLabel0.textAlignment=NSTextAlignmentRight;
        [_scrol addSubview:stockCountLabel0];
        
        NSString *stockCountstring0=[NSString stringWithFormat:@"剩余%d份",[[dict0 objectForKey:@"stockCount"] intValue]];
        NSMutableAttributedString *stockAttribute0=[[NSMutableAttributedString alloc]initWithString:stockCountstring0];
        NSDictionary *stockColor0=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f],NSForegroundColorAttributeName,nil];
        [stockAttribute0 addAttributes:stockColor0 range:NSMakeRange(2,stockCountstring0.length-3)];
        stockCountLabel0.attributedText=stockAttribute0;
        
        
        [self createTimer];
    }
}
#pragma mark Pic Delegate
-(void)picWithTag:(int)tag
{
    NSDictionary *dic=[_dataArray objectAtIndex:tag];
    LimitInfoViewController *limi=[[LimitInfoViewController alloc]init];
    limi.productId=[dic objectForKey:@"productId"];
    limi.suppGoodsId=[dic objectForKey:@"suppGoodsId"];
    limi.branchType=[dic objectForKey:@"branchType"];
    [self.navigationController pushViewController:limi animated:YES];
}
#pragma mark 精品秒杀更多
-(void)getMore:(UIButton *)button
{
    PindaoDetailViewController *pin=[[PindaoDetailViewController alloc]init];
    pin.pindaoTitle=@"精品秒杀";
    [self.navigationController pushViewController:pin animated:YES];
}
-(void)pay:(UIButton*)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}
-(void)createTimer
{
    _timer=[[NSTimer alloc]initWithFireDate:[NSDate date] interval:2.5 target:self selector:@selector(timerScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    _timerCount=0;
    
}

-(void)timerScroll
{
    if (!_timerCount==0) {
        _timerCount=_scrol.contentOffset.x/self.view.bounds.size.width;
    }
    _timerCount++;
    [_scrol setContentOffset:CGPointMake((_timerCount)*self.view.bounds.size.width, 0) animated:YES];
    if (_timerCount==(_scollCount+1)) {
        _timerCount=1;
    }
}
//暂停定时器
-(void)timerPause
{
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)timerRestart
{
    [_timer setFireDate:[NSDate date]];
}

-(void)scrollViewClick:(UIButton *)button
{
    NSDictionary *dic=[_headerArray objectAtIndex:button.tag-100];
    LimitInfoViewController *limi=[[LimitInfoViewController alloc]init];
    limi.productId=[dic objectForKey:@"productId"];
    limi.suppGoodsId=[dic objectForKey:@"suppGoodsId"];
    limi.branchType=[dic objectForKey:@"branchType"];
    [self.navigationController pushViewController:limi animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_scrol) {
        int count=scrollView.contentOffset.x/self.view.bounds.size.width;
        if (count==0) {
            if (scrollView.decelerating==YES) {
                _pageControl.currentPage=_scollCount;
                [scrollView setContentOffset:CGPointMake(_scollCount*self.view.bounds.size.width, 0) animated:NO];
            }
        }else if (count==(_scollCount+1))
        {
            _pageControl.currentPage=0;
            [scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:NO];
        }else
        {
            _pageControl.currentPage=count-1;
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView==_scrol) {
        [self timerPause];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==_scrol) {
        [self performSelector:@selector(timerRestart) withObject:self afterDelay:1.0];
    }
}
-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    _LVTableView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:_LVTableView];
    _LVTableView.bounces=YES;
    [self createTabLeHeaderView];
    [self createTabLeFooterView];
    _LVTableView.showsHorizontalScrollIndicator=NO;
    _LVTableView.showsVerticalScrollIndicator=NO;
    if ([_LVTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_LVTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_LVTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_LVTableView setLayoutMargins: UIEdgeInsetsZero];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellIde=@"cellhead";
        LVPindaoHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[LVPindaoHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.delegate=self;
            NSLog(@"%@",cell.superview);
        }
        cell.cellButton1.imageView.image=nil;
        cell.cellButton2.imageView.image=nil;
        cell.cellButton3.imageView.image=nil;
        cell.cellTitle1.text=@"";
        cell.cellTitle2.text=@"";
        cell.cellTitle3.text=@"";
        cell.pic1=@"";
        cell.pic2=@"";
        cell.pic3=@"";
        cell.title1=@"";
        cell.title2=@"";
        cell.title3=@"";
        cell.pic1=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"smallImage"];
        cell.pic2=[[_dataArray objectAtIndex:indexPath.row+1] objectForKey:@"smallImage"];
        cell.pic3=[[_dataArray objectAtIndex:indexPath.row+2] objectForKey:@"smallImage"];
        cell.title1=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"productName"];
        cell.title2=[[_dataArray objectAtIndex:indexPath.row+1] objectForKey:@"productName"];
        cell.title3=[[_dataArray objectAtIndex:indexPath.row+2] objectForKey:@"productName"];
        return cell;
    }else
    {
        static NSString *cellIde=@"cell";
        LVPindaoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[LVPindaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.delegate=self;
        }
        cell.cellPic.image=nil;
        cell.pic=@"";
        cell.title=@"";
        cell.cellTitle.text=@"";
        cell.cellSellPriceYuan.text=@"";
        cell.sellPriceYuan=0;
        cell.marketPriceYuan=0;
        cell.cellMarketPriceYuan.text=@"";
        cell.cellOrderCount.text=@"";
        cell.orderCount=0;
        NSDictionary *dic=[_dataArray objectAtIndex:indexPath.row+2];
        
        
        cell.pic=[dic objectForKey:@"smallImage"];
        cell.title=[dic objectForKey:@"productName"];
        cell.sellPriceYuan=[[dic objectForKey:@"sellPriceYuan"] intValue];
        cell.marketPriceYuan=[[dic objectForKey:@"marketPriceYuan"] intValue];
        cell.orderCount=[[dic objectForKey:@"orderCount"] intValue];
        return cell;
    }
}
-(void)pay
{
    NSLog(@"pay");
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}

#pragma mark row0click
-(void)RowClick:(NSInteger)tag
{

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 150;
    }
    else
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count-2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.sectionView)
    {
        self.sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        self.sectionView.backgroundColor=[UIColor whiteColor];
        NSArray *sectionArray=[NSArray arrayWithObjects:@"周边游",@"国内游",@"出境游",@"门票",@"游轮",nil];
        for (int i=0; i<SECTION_NUM; i++) {
            UILabel *information=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/SECTION_NUM*i,0,self.view.bounds.size.width/SECTION_NUM,self.sectionView.bounds.size.height)];
            information.text=[sectionArray objectAtIndex:i];
            information.font=[UIFont systemFontOfSize:12];
            information.textColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
            information.textAlignment=NSTextAlignmentCenter;
            [self.sectionView addSubview:information];
            information.userInteractionEnabled=YES;
            
            UIButton *informationButton=[UIButton buttonWithType:UIButtonTypeCustom];
            informationButton.frame=information.bounds;
            [informationButton addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
            informationButton.tag=100+i;
            [information addSubview:informationButton];
        }
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabLeftSel.png"]];
        line.frame=CGRectMake(self.view.bounds.size.width/SECTION_NUM/2-16, self.sectionView.bounds.size.height-3, 33, 3);
        [self.sectionView addSubview:line];
        return self.sectionView;
    }else
        return self.sectionView;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        NSDictionary *dic=[_dataArray objectAtIndex:indexPath.row+2];
        LimitInfoViewController *limi=[[LimitInfoViewController alloc]init];
        limi.productId=[dic objectForKey:@"productId"];
        limi.suppGoodsId=[dic objectForKey:@"suppGoodsId"];
        limi.branchType=[dic objectForKey:@"branchType"];
        [self.navigationController pushViewController:limi animated:YES];
    }
}

-(void)sectionClick:(UIButton *)button
{
    [self hudShow];
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
                    int center=self.view.bounds.size.width/SECTION_NUM/2;
                    if (button.tag==100) {
                        line.frame=CGRectMake(center-16, 27, 33, 3);
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoAroundDownloadFinish) name:PINDAO_AROUND object:nil];
                        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_AROUND and:12];
                    }else if (button.tag==101)
                    {
                        line.frame=CGRectMake(center*3-16, 27, 33, 3);
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoChinaDownloadFinish) name:PINDAO_CHINA object:nil];
                        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_CHINA and:12];
                    }else if (button.tag==102)
                    {
                        line.frame=CGRectMake(center*5-16, 27, 33, 3);
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoAbroadDownloadFinish) name:PINDAO_ABROAD object:nil];
                        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_ABROAD and:12];
                    }else if (button.tag==103)
                    {
                        line.frame=CGRectMake(center*7-12, 27, 24, 3);
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoTicketDownloadFinish) name:PINDAO_TICKET object:nil];
                        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_TICKET and:12];
                    }else if (button.tag==104)
                    {
                        line.frame=CGRectMake(center*9-12, 27, 24, 3);
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pindaoShipDownloadFinish) name:PINDAO_SHIP object:nil];
                        [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:PINDAO_SHIP and:12];
                    }
                }];
            }
        }
    }
    button.selected=YES;
    ((UILabel *)button.superview).textColor=[UIColor colorWithRed:0.84f green:0.25f blue:0.46f alpha:1.00f];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
