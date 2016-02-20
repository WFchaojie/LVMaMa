//
//  HomeTripForMyselfViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeTripForMyselfViewController.h"

@interface HomeTripForMyselfViewController ()

@end

@implementation HomeTripForMyselfViewController

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
    [self createWebView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=self.tripTitle;
    [self leftButton];
    // Do any additional setup after loading the view.
}

-(void)createWebView
{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
