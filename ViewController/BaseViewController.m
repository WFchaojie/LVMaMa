//
//  BaseViewController.m
//  LVMaMa
//
//  Created by apple on 15-6-19.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()<MBProgressHUDDelegate>

@end

@implementation BaseViewController
{
    MBProgressHUD *HUD;
    UIImageView *_animate;
    long long expectedLength;
    long long currentLength;
}
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
    //self.edgesForExtendedLayout = UIRectEdgeNone;
	// Do any additional setup after loading the view.
}
-(void)leftButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"filtrateBack.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 32, 32);
    [button addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 10);

    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=item;
}
-(void)rightBtn:(NSString *)title
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 32);
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.9 green:0 blue:0.44 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
}

-(void)rightButton:(NSArray *)array
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i=array.count-1; i>=0; i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage :[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 32, 32);
        button.imageEdgeInsets = UIEdgeInsetsMake(0,18, 0,-18);
        
        [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
        button.tag=100+i;
        [items addObject:item];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -1;
        [items addObject:negativeSpacer];
    }
    
    self.navigationItem.rightBarButtonItems=items;
}
- (void)hudShow {
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lvmmIcon.png"]];
        _animate=[[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, HUD.customView.bounds.size.width+20,HUD.customView.bounds.size.height+20)];
        [HUD.customView addSubview:_animate];
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText=@"驴妈妈去旅游";
    }

    [HUD show:YES];
    [self startAnimate];
}
-(void)startAnimate
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=1; i<9; i++) {
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png",i]]];
    }
    _animate.animationImages=array;
    _animate.animationDuration=0.8;
    _animate.animationRepeatCount=0;
    [_animate startAnimating];
}
-(void)hudHide
{
    [HUD hide:YES];
}
-(void)rightClick:(UIButton *)button
{

}
-(void)rightClick
{

}
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
