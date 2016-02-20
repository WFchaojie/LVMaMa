//
//  HomeTrainViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeTrainViewController.h"

@interface HomeTrainViewController ()<UIWebViewDelegate>

@end

@implementation HomeTrainViewController

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
    [self hudShow];
    [self createWebView];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self leftButton];
    self.title=@"火车票";
	// Do any additional setup after loading the view.
}
-(void)createWebView
{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    NSString *str=[NSString stringWithContentsOfURL:[NSURL URLWithString:TRAIN] encoding:NSUTF8StringEncoding error:nil];
    //webview.scrollView.contentInset=UIEdgeInsetsMake(-48, 0, 0, 0);
    webview.scrollView.scrollEnabled=NO;
    [webview loadHTMLString:[self filterHTML:str] baseURL:[NSURL URLWithString:TRAIN]];
    webview.delegate=self;
    [self.view addSubview:webview];
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<header" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"</span>条结果" intoString:&text];
        //替换字符
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@</span>条结果",text] withString:@""];
    }
    
    return html;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hudHide];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
