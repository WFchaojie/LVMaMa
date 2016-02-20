//
//  HomeOnePriceViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeOnePriceViewController.h"

@interface HomeOnePriceViewController ()

@end

@implementation HomeOnePriceViewController

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
    self.navigationController.navigationBarHidden=YES;
    [self createWebView];
	// Do any additional setup after loading the view.
}
-(void)createWebView
{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:HOME_ONE_PRICE]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
