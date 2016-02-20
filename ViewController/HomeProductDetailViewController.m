//
//  HomeProductDetailViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/21.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeProductDetailViewController.h"

@interface HomeProductDetailViewController ()<UIWebViewDelegate>

@end

@implementation HomeProductDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hudShow];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productDownloadFinish) name:[NSString stringWithFormat:PRODUCT_URL,self.ID] object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:PRODUCT_URL,self.ID] and:11];
    NSLog(@"%@",[NSString stringWithFormat:PRODUCT_URL,self.ID]);
    self.title=@"产品详情";
    [self leftButton];
    [self rightButton:[NSArray arrayWithObjects:@"placeDetailUncollected.png",@"shareBtn.png",nil]];
    // Do any additional setup after loading the view.
}
-(void)rightClick:(UIButton *)button
{
    [[[UIAlertView alloc]initWithTitle:@"很遗憾" message:@"服务器的接口是post" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}
-(void)productDownloadFinish
{
    NSArray *returnArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:PRODUCT_URL,self.ID]];
    NSDictionary *dict=[returnArray lastObject];
    NSString *url=[dict objectForKey:@"url_long"];
    [self createWebviewWithURL:url];
}
-(void)createWebviewWithURL:(NSString *)url
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    webView.delegate=self;
    NSString *str=[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    NSArray *webArray=[str componentsSeparatedByString:@""];
    NSString *webstring=[webArray componentsJoinedByString:@""];
    
    [webView loadHTMLString:webstring baseURL:[NSURL URLWithString:url]];
    [self.view addSubview:webView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hudHide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
