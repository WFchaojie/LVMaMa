//
//  TourPlaceViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/8/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "TourPlaceViewController.h"
#import "ReusableView.h"
#import "XLPlainFlowLayout.h"
#import "PlaceCollectionCell.h"
#import "TourDestinationDetailViewController.h"
@interface TourPlaceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation TourPlaceViewController
static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";
NSString *_url;
NSMutableArray *_dataArray;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=NO;
}

-(instancetype)init
{
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.naviHeight = 44.0;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    [self createCollection];
    if (self.index==100) {
        _url=IN_LAND_AREA;
        self.title=@"国内目的地选择";
    }else
    {
        self.title=@"国外港澳台目的地选择";
        _url=OUT_LAND_AREA;
    }
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:_url and:4];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TourDownloadFinish) name:_url object:nil];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    [self leftButton];
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
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)TourDownloadFinish
{
    _dataArray = [[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:_url];
    [self.collectionView reloadData];
}
-(void)createCollection
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[PlaceCollectionCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dict= [_dataArray objectAtIndex:indexPath.row];

    cell.pic=@"";
    cell.ctitle=@"";
    cell.ctitle=[dict objectForKey:@"title"];
    cell.pic=[NSString stringWithFormat:@"http://pic.lvmama.com/pics/%@",[dict objectForKey:@"image"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TourDestinationDetailViewController *tour=[[TourDestinationDetailViewController alloc]init];
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    tour.ID=[dict objectForKey:@"id"];
    [self.navigationController pushViewController:tour animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind==UICollectionElementKindSectionFooter) {
        ReusableView *footer = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }
    
    if (indexPath.section >=0) {
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        header.text = @"  热门目的地";
        header.moreText = @"更多目的地 >  ";
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section>=0) {
        return CGSizeMake(0, 30);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 20);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(95,100);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


@end



