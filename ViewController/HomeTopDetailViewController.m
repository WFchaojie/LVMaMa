//
//  HomeTopDetailViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-5.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeTopDetailViewController.h"

@interface HomeTopDetailViewController ()<UIWebViewDelegate>

@end

@implementation HomeTopDetailViewController

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
    [self hudShow];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=self.homeTitle;
    [self leftButton];
    [self createWebView];

	// Do any additional setup after loading the view.
}

-(void)createWebView
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    NSString *str=[NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:nil];
    webView.delegate=self;
    NSArray *webArray=[str componentsSeparatedByString:@"<script type=\"text/javascript\" src=\"http://pic.lvmama.com/mobile/js/debug/base/ztheader.js\"></script>"];
    NSString *webstring=[webArray componentsJoinedByString:@""];
    
    webView.delegate=self;
    [webView loadHTMLString:webstring baseURL:[NSURL URLWithString:self.url]];
    [self.view addSubview:webView];
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;

    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<meta id=\"share\"" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"\">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@\">",text] withString:@""];
    }
    NSLog(@"%@",html);

    return html;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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
