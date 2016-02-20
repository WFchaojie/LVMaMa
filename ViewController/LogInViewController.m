//
//  LogInViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-19.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController
{
    NSString *userName;
    NSString *password;
}
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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self createNavigation];
    [self createBody];
	// Do any additional setup after loading the view.
}
-(void)createBody
{
    NSArray *array=[NSArray arrayWithObjects:@"账 号：",@"密 码：",nil];
    NSArray *hint=[NSArray arrayWithObjects:@"请输入邮箱/手机号/用户名",@"请输入密码",nil];
    UIView *back=[[UIView alloc]initWithFrame:CGRectMake(0, 10+64, self.view.bounds.size.width, 70)];
    back.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:back];
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,35*i, 60, 35)];
        label.text=[array objectAtIndex:i];
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:14];
        [back addSubview:label];
        
        UITextField *field=[[UITextField alloc]initWithFrame:CGRectMake(60, i*35, self.view.bounds.size.width-50, 35)];
        field.font=[UIFont systemFontOfSize:14];
        field.placeholder=[hint objectAtIndex:i];
        [back addSubview:field];
    }
    for (int i=0; i<3; i++) {
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
        line.frame=CGRectMake(0, i*35, self.view.bounds.size.width, 1);
        line.alpha=0.5;
        [back addSubview:line];
    }
    UIButton *logIn=[UIButton buttonWithType:UIButtonTypeCustom];
    [logIn setBackgroundImage:[UIImage imageNamed:@"middleRedBtnBg.png"] forState:UIControlStateNormal];
    [logIn setTitle:@"登录" forState:UIControlStateNormal];
    logIn.frame=CGRectMake(40, 74+80, self.view.bounds.size.width-80, 30);
    [logIn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    logIn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [self.view addSubview:logIn];
    
    UILabel *leftHint=[[UILabel alloc]initWithFrame:CGRectMake(8, 120, 150, 15)];
    leftHint.text=@"还没有驴妈妈账号吗？";
    leftHint.font=[UIFont systemFontOfSize:14];
    leftHint.textColor=[UIColor grayColor];
    [back addSubview:leftHint];
    
    UILabel *rightHint=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-125, 64+10+120, 125, 15)];
    rightHint.font=[UIFont systemFontOfSize:14];
    rightHint.textColor=[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f];
    [self.view addSubview:rightHint];
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:@"点击这里快速注册>"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,4)];
    rightHint.attributedText=string;
    
    UILabel *otherLogin=[[UILabel alloc]initWithFrame:CGRectMake(0,145+74, self.view.bounds.size.width, 15)];
    otherLogin.text=@"其他方式登录";
    otherLogin.font=[UIFont systemFontOfSize:14];
    otherLogin.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:otherLogin];
    otherLogin.textColor=[UIColor grayColor];
    
    UIImageView *line1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line1.frame=CGRectMake(0, 145+74+7, 100, 1);
    [self.view addSubview:line1];
    line1.alpha=0.5;
    
    UIImageView *line2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line2.frame=CGRectMake(self.view.bounds.size.width-100, 145+74+7, 100, 1);
    [self.view addSubview:line2];
    line2.alpha=0.5;
    NSArray *icon=[[NSArray alloc]initWithObjects:@"sinaWeibo.png",@"qqIcon.png",@"aliPay.png",@"wechatIconUnable.png",nil];
    for (int i=0; i<4; i++) {
        UIButton *picButton=[UIButton buttonWithType:UIButtonTypeCustom];
        picButton.frame=CGRectMake(10+i*((self.view.bounds.size.width-20-15*3)/4+15), 160+74+10, (self.view.bounds.size.width-20-15*3)/4, (self.view.bounds.size.width-20-15*3)/4);
        picButton.tag=100+i;
        [picButton setImage:[UIImage imageNamed:[icon objectAtIndex:i]] forState:UIControlStateNormal];
        [self.view addSubview:picButton];
    }
}
-(void)login
{
    NSLog(@"登录");
}
//自定义导航条
-(void)createNavigation
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.view addSubview:navView];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 30)];
    address.userInteractionEnabled=YES;
    address.text=@"会员登录";
    address.font=[UIFont boldSystemFontOfSize:18];
    address.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:address];
    
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(10, 20, 40, 44);
    leftButton.tag=100;
    leftButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftButton];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor colorWithRed:0.78f green:0.24f blue:0.44f alpha:1.00f] forState:UIControlStateNormal];
    [rightButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(self.view.bounds.size.width-70, 20, 60, 44);
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
    rightButton.tag=101;
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton];
    
    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hotelSeparateShiXian.png"]];
    line.frame=CGRectMake(0, 64, self.view.bounds.size.width, 1);
    [self.view addSubview:line];

}
-(void)rightClick
{

}
-(void)leftClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
