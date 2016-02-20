//
//  HomeActivityDetailViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeActivityDetailViewController.h"

@interface HomeActivityDetailViewController ()<UIWebViewDelegate>

@end

@implementation HomeActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createWebView];
    self.navigationController.navigationBarHidden=YES;
	// Do any additional setup after loading the view.
}
-(void)createWebView
{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webview.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]];
    webview.delegate=self;
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [webview addSubview:button];
    button.frame=CGRectMake(0, 20, 36, 36);
}
-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%ld",(long)navigationType);
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
