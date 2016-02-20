//
//  lvmamaAppDelegate.m
//  LVMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//  国内游 用户点评 推荐项目

//  周边界面点击以后

#import "lvmamaAppDelegate.h"
#import "HomeViewController.h"
#import "TourViewController.h"
#import "NearbyViewController.h"
#import "UserCenterViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@implementation lvmamaAppDelegate
{
    UITabBarController *_tab;
    //引导页
    UIScrollView *_guideScrollView;
    CGPoint _startPoint;
    int _result;
    int _onceMove;
    BOOL _isMoving;
    UIView *_adWindow;
    UIView *_lauchWindow;
    NSMutableArray *_adArray;
    BMKMapManager* _mapManager;
    //
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"URgT8uKK9CQkNEB6VdZSSCCZ" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    NSLog(@"ret==%d",ret);
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    [UMSocialWechatHandler setWXAppId:@"wxdc1e388c3822c80b" appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" url:@"http://www.umeng.com/social"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    HomeViewController *home=[[HomeViewController alloc]init];
    UINavigationController *navHome=[[UINavigationController alloc]initWithRootViewController:home];
    
    
    TourViewController *tour=[[TourViewController alloc]init];
    UINavigationController *navTour=[[UINavigationController alloc]initWithRootViewController:tour];
    
    
    NearbyViewController *nearby=[[NearbyViewController alloc]init];
    UINavigationController *navNearby=[[UINavigationController alloc]initWithRootViewController:nearby];
    
    
    UserCenterViewController *user=[[UserCenterViewController alloc]init];
    UINavigationController *navUser=[[UINavigationController alloc]initWithRootViewController:user];
    
    
    _tab=[[UITabBarController alloc]init];
    _tab.viewControllers=[NSArray arrayWithObjects:navHome,navTour,navNearby,navUser,nil];
    _tab.tabBar.hidden=YES;
    self.lvTabbar=[[lVTabbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-46, [UIScreen mainScreen].bounds.size.width, 46)];
    [_tab.view addSubview:self.lvTabbar];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"LVTabbar" ofType:@"plist"];
    NSArray *arrPath=[NSArray arrayWithContentsOfFile:path];
    [self.lvTabbar createSECTabbarWithBackgroundImageName:nil andItemArray:arrPath andClass:self andSEL:@selector(btnClick:)];
    ((UIButton *)[((UIView *)[self.lvTabbar.subviews objectAtIndex:0]).subviews objectAtIndex:0]).selected=YES;
    
    self.window.rootViewController=_tab;
    
    _tab.selectedIndex=0;
    self.window.backgroundColor = [UIColor whiteColor];
    

    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"guide"]isEqualToString:@"1"])
    {
        if (!_guideScrollView) {
            _guideScrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [_tab.view addSubview:_guideScrollView];
            _guideScrollView.pagingEnabled=YES;
            _guideScrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*3, 0);
            _guideScrollView.showsHorizontalScrollIndicator=NO;
            _guideScrollView.showsVerticalScrollIndicator=NO;
            _guideScrollView.bounces=YES;
            _guideScrollView.delegate=self;
            for (int i=0; i<2; i++) {
                UIImageView *guidePic=[[UIImageView alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                guidePic.image=[UIImage imageNamed:[NSString stringWithFormat:@"guide%d.png",i+6]];
                [_guideScrollView addSubview:guidePic];
            }
            
            UIButton *goIn=[UIButton buttonWithType:UIButtonTypeCustom];
            [goIn setImage:[UIImage imageNamed:@"AnNiu.png"] forState:UIControlStateNormal];
            goIn.frame=CGRectMake(_guideScrollView.bounds.size.width/2-60+[UIScreen mainScreen].bounds.size.width, _guideScrollView.bounds.size.height-80, 120, 30);
            [goIn addTarget:self action:@selector(goToGuideClick) forControlEvents:UIControlEventTouchUpInside];
            [_guideScrollView addSubview:goIn];
        }
    }
    
    NSURL *pURL = [NSURL URLWithString:ADURL];
    NSURLRequest *pRequest = [NSURLRequest requestWithURL:pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSError *pError = nil;
    NSURLResponse *pRespond = nil;
    NSData *pData = [NSURLConnection sendSynchronousRequest:pRequest returningResponse:&pRespond error:&pError];
    
    NSDictionary *root=[NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableLeaves error:nil];
    
    if ([root objectForKey:@"datas"]!=nil) {
        NSArray *datas=[root objectForKey:@"datas"];
        NSMutableArray *infos=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<datas.count; i++) {
            NSDictionary *items=[datas objectAtIndex:i];
            [infos addObject:items];
        }
        
        if (infos.count) {
            _adArray=[[NSMutableArray alloc]initWithArray:infos];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"guide"]isEqualToString:@"1"]) {
                [self createWindow:infos];
            }
        }
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}



-(void)createWindow:(NSArray *)adArray
{
    if (adArray.count) {
        _adWindow = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UIImageView *back=[[UIImageView alloc]initWithFrame:_adWindow.bounds];
        NSDictionary *dict =[adArray objectAtIndex:0];
        [back sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"imgUrl"]] placeholderImage:nil];
        
        [_adWindow addSubview:back];
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        adButton.frame=_adWindow.bounds;
        [adButton addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
        [_adWindow addSubview:adButton];
        
        _adWindow.userInteractionEnabled=YES;
        back.userInteractionEnabled=YES;
        _adWindow.alpha=0;

        _adWindow.alpha=1;
        [self performSelector:@selector(windowHide) withObject:nil afterDelay:3.0];
        [_tab.view addSubview:_adWindow];
    }
}

-(void)adClick:(UIButton *)button
{
    [self.delegate adDownloadFinish:_adArray];
}

-(void)windowHide
{
    if (_adWindow) {
        for (UIView *subView in _adWindow.subviews) {
            [subView removeFromSuperview];
        }
        [_adWindow removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            _adWindow.hidden=YES;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)adDownloadFinish
{
    NSArray *array=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:ADURL];
    if ([self.delegate respondsToSelector:@selector(adDownloadFinish:)]) {
        [self.delegate adDownloadFinish:array];
    }

    [self performSelector:@selector(removeWindow) withObject:nil afterDelay:2.0f];
}

-(void)removeWindow
{
    [_lauchWindow removeFromSuperview];
    for (UIView *view in _lauchWindow.subviews) {
        [view removeFromSuperview];
    }
}



-(void)goToGuideClick
{
    [UIView animateWithDuration:0.2f animations:^{
        _guideScrollView.alpha=0;
    } completion:^(BOOL finished) {
        [_guideScrollView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"guide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<0) {
        scrollView.contentOffset=CGPointMake(0, 0);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/320==2) {
        [_guideScrollView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"guide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)btnClick:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button=sender;
        for (UIView *view in button.superview.superview.subviews) {
            for (UIButton *btn in view.subviews) {
                btn.selected=NO;
            }
        }
    }else
        return;
    ((UIButton *)sender).selected=YES;
    _tab.selectedIndex=((UIButton *)sender).tag;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
