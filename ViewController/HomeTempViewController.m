//
//  HomeTempViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-8.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeTempViewController.h"

@interface HomeTempViewController ()

@end

@implementation HomeTempViewController

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
    self.navigationController.navigationBarHidden=YES;
    self.title=self.tempTitle;
    [self leftButton];
	// Do any additional setup after loading the view.
}
-(void)createWebView
{
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webview.backgroundColor=[UIColor whiteColor];
    NSString *str=[NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *webArray=[str componentsSeparatedByString:@"<script type=\"text/javascript\" src=\"http://pic.lvmama.com/mobile/js/debug/base/ztheader.js\"></script>"];
    NSString *webstring=[webArray componentsJoinedByString:@""];
    
    [webview loadHTMLString:webstring baseURL:[NSURL URLWithString:self.url]];
    [self.view addSubview:webview];
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<script type=\"text/javascript\"" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"src=\"http://pic.lvmama.com/mobile/js/debug/base/base.js\"></script>" intoString:&text];
        //替换字符
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@src=\"http://pic.lvmama.com/mobile/js/debug/base/base.js\"></script>",text] withString:@""];
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
