//
//  LVHomeSpecialURLViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LVHomeSpecialURLViewController.h"

@interface LVHomeSpecialURLViewController ()

@end

@implementation LVHomeSpecialURLViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self createWebView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title=self.homeTitle;
    [self leftButton];
    // Do any additional setup after loading the view.
}
-(void)createWebView
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    webView.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    NSString *str=[NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:nil];
    NSArray *webArray=[str componentsSeparatedByString:@"<script type=\"text/javascript\" src=\"http://pic.lvmama.com/mobile/js/code/base/header.js\"></script>"];
    NSString *webstring=[webArray componentsJoinedByString:@""];
    
    NSArray *webArrayFooter=[webstring componentsSeparatedByString:@"<script type=\"text/javascript\" src=\"http://pic.lvmama.com/mobile/js/code/base/footer.js\"></script>"];
    NSString *webstringFooter=[webArrayFooter componentsJoinedByString:@""];
    
    [webView loadHTMLString:webstringFooter baseURL:[NSURL URLWithString:self.url]];
    [self.view addSubview:webView];
    
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
