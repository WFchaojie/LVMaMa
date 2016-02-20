//
//  HomeUserCommentViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/18.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "HomeUserCommentViewController.h"
#import "LVHomeCommentCell.h"
@interface HomeUserCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HomeUserCommentViewController
{
    UITableView *_LVTableView;
    NSMutableArray *_commentArray;
    BOOL _hasNext;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[LVDownLoadManager sharedDownLoadManager]downLoadWithUrl:[NSString stringWithFormat:USER_COMMENT,self.ID] and:4];
    NSLog(@"%@",[NSString stringWithFormat:USER_COMMENT,self.ID]);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserCommentDownloadFinish) name:[NSString stringWithFormat:USER_COMMENT,self.ID] object:nil];
    [self leftButton];
    self.title=@"用户点评";
    _commentArray=[[NSMutableArray alloc]initWithCapacity:0];
    [self createTableView];
    // Do any additional setup after loading the view.
}
-(void)UserCommentDownloadFinish
{
    _commentArray=[[LVDownLoadManager sharedDownLoadManager]getDownLoadDataForKey:[NSString stringWithFormat:USER_COMMENT,self.ID]];
    _hasNext=[[[_commentArray lastObject] objectForKey:@"hasNext"] boolValue];
    [_commentArray removeObject:[_commentArray lastObject]];

    [_LVTableView reloadData];
    if (_hasNext==NO) {
        UIView *footView;
        if (_LVTableView.tableFooterView) {
            footView=_LVTableView.tableFooterView;
        }else
            footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        footView.backgroundColor=[UIColor clearColor];
        UILabel *footLabel=[[UILabel alloc]initWithFrame:footView.bounds];
        [footView addSubview:footLabel];
        footLabel.text=@"已加载显示完全部内容";
        footLabel.textColor=[UIColor grayColor];
        footLabel.font=[UIFont systemFontOfSize:14];
        footLabel.textAlignment=NSTextAlignmentCenter;
        _LVTableView.tableFooterView=footView;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _LVTableView.backgroundColor=[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    [self.view addSubview:_LVTableView];
    if ([_LVTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_LVTableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([_LVTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_LVTableView setLayoutMargins: UIEdgeInsetsZero];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellName=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        return cell;
    }else{
        static NSString *cellName=@"cellCommentComment";
        LVHomeCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[LVHomeCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        cell.cellCommnet.text=@"";
        cell.cellTime.text=@"";
        cell.cellUserName.text=@"";
        cell.celluserPic.image=nil;
        cell.commnet=@"";
        cell.time=@"";
        cell.userName=@"";
        cell.userPic=@"";
        NSDictionary *dict=[_commentArray objectAtIndex:(indexPath.row-1)];
        cell.commnet=[dict objectForKey:@"content"];
        if ([[dict objectForKey:@"cmtPictures"] count]) {
            cell.picArray=[dict objectForKey:@"cmtPictures"];
        }
        cell.time=[dict objectForKey:@"createdTime"];
        cell.userName=[dict objectForKey:@"userNameExp"];
        cell.userPic=[dict objectForKey:@"userImg"];
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 0;
    }else
    {
        int height=0;
        NSDictionary *dict=[_commentArray objectAtIndex:(indexPath.row-1)];
        CGSize size=CGSizeMake(self.view.bounds.size.width-WIDTH*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dictSize=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[[dict objectForKey:@"content"]  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dictSize context:nil].size;
        height+=actualSize.height+60;
        
        if ([[dict objectForKey:@"cmtPictures"] count] ) {
            height+=50;
        }
        return height;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count+1;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark tableview分割线左边有空隙
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
