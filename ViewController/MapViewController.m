//
//  MapViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/11/12.
//  Copyright © 2015年 LVmama. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface MapViewController ()<BMKMapViewDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService * locService;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMap];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self addCustomGestures];//添加自定义的手势
    [self downLoad];
    // Do any additional setup after loading the view.
}

-(void)downLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MapArrayDownloadFinish) name:MAP object:nil];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:MAP and:18];
}

-(void)MapArrayDownloadFinish
{
    
}

- (void)showAnnotations:(NSArray *)annotations animated:(BOOL)animated
{
    
    
}

//创建地图
-(void)createMap
{
    if (!_mapView) {
        _mapView=[[BMKMapView alloc]init];
        _mapView.frame=CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view addSubview:_mapView];
        _mapView.delegate=self;
        CLLocationCoordinate2D coor;
        coor.latitude = 40.08144069;
        coor.longitude = 116.39561515;
        _mapView.showMapScaleBar=YES;
        _mapView.buildingsEnabled=YES;
        _mapView.zoomLevel=10;
        _locService = [[BMKLocationService alloc]init];
        [_locService startUserLocationService];
        _mapView.showsUserLocation=YES;
        _mapView.centerCoordinate=coor;
        [self.view addSubview:_mapView];
        
    }
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 40.073736446978664;
    coor.longitude = 116.41359726101427;
    annotation.coordinate = coor;
    
    annotation.title = @"test";
    annotation.subtitle = @"this is a test!";
    [_mapView addAnnotation:annotation];
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;

}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {

}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

#pragma mark - 添加自定义的手势（若不自定义手势，不需要下面的代码）

- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:doubleTap];
    
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    /*
     *do something
     */
    NSLog(@"my handleSingleTap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
    NSLog(@"my handleDoubleTap");
}


@end
