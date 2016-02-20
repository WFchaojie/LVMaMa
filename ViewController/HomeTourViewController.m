//
//  HomeTourViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeTourViewController.h"

@interface HomeTourViewController ()

@end

@implementation HomeTourViewController

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
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title=@"定制游";
    [self leftButton];
	// Do any additional setup after loading the view.
}
-(void)createWebView
{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    webview.backgroundColor=[UIColor whiteColor];
    NSString *str=[NSString stringWithContentsOfURL:[NSURL URLWithString:HOME_TOUR] encoding:NSUTF8StringEncoding error:nil];    
    [webview loadHTMLString:[self filterHTML:str] baseURL:[NSURL URLWithString:HOME_TOUR]];
    [self.view addSubview:webview];
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<div style=\"width:0; height:0;" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"定制游</h1>" intoString:&text];
        //替换字符
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@定制游</h1>",text] withString:@""];
    }
    NSLog(@"%@",html);
    return html;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
