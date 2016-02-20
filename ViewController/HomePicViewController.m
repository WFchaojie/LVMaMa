//
//  HomePicViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/16.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomePicViewController.h"

@interface HomePicViewController ()<UIScrollViewDelegate>

@end

@implementation HomePicViewController
{
    UIView *_navView;
    BOOL _isShow;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication]delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self leftButton];
    [self createScrollView];
    [self createNavigation];
    _isShow=YES;
    // Do any additional setup after loading the view.
}
-(void)createNavigation
{
    _navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    _navView.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
    [self.view addSubview:_navView];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    address.text=[NSString stringWithFormat:@"%d/%lu",self.current+1,(unsigned long)self.pic.count];
    address.textColor=[UIColor blackColor];
    address.font=[UIFont boldSystemFontOfSize:18];
    address.textAlignment=NSTextAlignmentCenter;
    [_navView addSubview:address];
    
    UIButton *code=[[UIButton alloc]initWithFrame:CGRectMake(10, 23, 36, 36)];
    [code setImage:[UIImage imageNamed:@"filtrateBack.png"] forState:UIControlStateNormal];
    [code addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:code];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createScrollView
{
    UIView *back=[[UIView alloc]initWithFrame:CGRectMake(0,  -64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
    back.backgroundColor=[UIColor blackColor];
    [self.view addSubview:back];
    UIScrollView *_scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0,  -64, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height+64)];
    _scrol.pagingEnabled=YES;
    _scrol.bounces=NO;
    _scrol.showsHorizontalScrollIndicator=NO;
    _scrol.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrol];
    _scrol.delegate=self;
    _scrol.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*self.pic.count, 0);
    for (int i=0; i<self.pic.count; i++) {
        UIImageView *picture=[[UIImageView alloc]initWithFrame:CGRectMake(i*back.bounds.size.width, ([UIScreen mainScreen].bounds.size.height+64)/2-75, [UIScreen mainScreen].bounds.size.width, 200)];
        [_scrol addSubview:picture];
        [picture sd_setImageWithURL:[NSURL URLWithString:[self.pic objectAtIndex:i]] placeholderImage:nil];
        picture.userInteractionEnabled=YES;
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=picture.frame;
        [button addTarget:self action:@selector(picClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100+i;
        [_scrol addSubview:button];
    }
    [_scrol setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*self.current, 0) animated:NO];
}
-(void)picClick:(UIButton *)button
{
    if (_isShow==YES) {
        [UIView animateWithDuration:0.7 animations:^{
            _navView.frame=CGRectMake(0, -64, self.view.bounds.size.width, -32);
        } completion:^(BOOL finished) {
            _isShow=NO;
        }];
    }else
    {
        [UIView animateWithDuration:0.7 animations:^{
            _navView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 64);
        } completion:^(BOOL finished) {
            _isShow=YES;
        }];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.7 animations:^{
        _navView.frame=CGRectMake(0, -64, self.view.bounds.size.width, -32);
    } completion:^(BOOL finished) {
        _isShow=NO;
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UILabel *title in _navView.subviews) {
        if ([title isKindOfClass:[UILabel class]]) {
            title.text=[NSString stringWithFormat:@"%.f/%lu",(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width)+1,(unsigned long)self.pic.count];
        }
    }
}

@end
