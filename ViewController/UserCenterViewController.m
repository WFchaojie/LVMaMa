//
//  UserCenterViewController.m
//  LvMaMa
//
//  Created by apple on 15-5-27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserCenterViewController.h"
#import "lvmamaAppDelegate.h"
#import "LogInViewController.h"
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UserCenterViewController
{
    UITableView *_LVTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_picArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
        [_dataArray addObject:[NSArray arrayWithObjects:@"全部订单", @"待审核",nil]];
        [_dataArray addObject:[NSArray arrayWithObjects:@"电子票",nil]];
        [_dataArray addObject:[NSArray arrayWithObjects:@"优惠券", @"钱包",nil]];
        [_dataArray addObject:[NSArray arrayWithObjects:@"常用信息", @"我的收藏",@"我的游记",@"离线游记",@"历史浏览",nil]];
        [_dataArray addObject:[NSArray arrayWithObjects:@"设置", @"关于驴妈妈",@"客服电话",nil]];
        _picArray=[[NSMutableArray alloc]initWithCapacity:0];
        [_picArray addObject:[NSArray arrayWithObjects:@"defualt", @"defualt",nil]];
        [_picArray addObject:[NSArray arrayWithObjects:@"myLVMMIcon20.png",nil]];
        [_picArray addObject:[NSArray arrayWithObjects:@"myLVMMIcon30.png",@"myLVMMIcon31.png",nil]];
        [_picArray addObject:[NSArray arrayWithObjects:@"myLVMMIcon40.png",@"myLVMMIcon41.png",@"myLVMMIcon42.png",@"myLVMMIcon43.png",@"myLVMMIcon44.png",nil]];
        [_picArray addObject:[NSArray arrayWithObjects:@"myLVMMIcon50.png",@"myLVMMIcon51.png",@"myLVMMIcon52.png",nil]];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ((lvmamaAppDelegate *)[[UIApplication sharedApplication] delegate]).lvTabbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-46, self.view.bounds.size.width, 46);
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
	// Do any additional setup after loading the view.
}

-(void)createHeader
{
    UIImageView *back=[[UIImageView alloc]init];
    
    if (iPhone6Plus) {
        back.frame=CGRectMake(0, 0, self.view.bounds.size.width, 180);
    }else
    {
        back.frame=CGRectMake(0, 0, self.view.bounds.size.width, 150);
    }
    back.image=[UIImage imageNamed:@"myBackimage.png"];
    back.userInteractionEnabled=YES;
    _LVTableView.tableHeaderView=back;
    
    UIImageView *logo=[[UIImageView alloc]init];

    if (iPhone6Plus) {
        logo.frame=CGRectMake(back.bounds.size.width/2-26, back.bounds.size.height/2-26, 52, 52);
    }else
    {
        logo.frame=CGRectMake(back.bounds.size.width/2-13, back.bounds.size.height/2-13, 26, 26);
    }
    logo.image=[UIImage imageNamed:@"loadingIcon.png"];
    logo.userInteractionEnabled=YES;
    [back addSubview:logo];
    
    UILabel *information=[[UILabel alloc]init];
    if (iPhone6Plus) {
        information.frame=CGRectMake(0, logo.frame.origin.y+logo.frame.size.height+5, self.view.bounds.size.width, 20);
        information.font=[UIFont boldSystemFontOfSize:16];
    }else
    {
        information.frame=CGRectMake(0, logo.frame.origin.y+logo.frame.size.height+5, self.view.bounds.size.width, 20);
        information.font=[UIFont boldSystemFontOfSize:14];
    }

    
    information.text=@"欢迎来到驴妈妈";
    information.textColor=[UIColor whiteColor];
    information.textAlignment=NSTextAlignmentCenter;
    [back addSubview:information];
    
    UIImageView *registerBack=[[UIImageView alloc]init];
    
    if (iPhone6Plus) {
        registerBack.frame=CGRectMake(10, back.bounds.size.height-40+5, self.view.bounds.size.width/2-15, 33-5);
    }else
    {
        registerBack.frame=CGRectMake(10, back.bounds.size.height-30, self.view.bounds.size.width/2-15, 23);
    }
    registerBack.image=[UIImage imageNamed:@"btnOrangeCorner.png"];
    registerBack.layer.cornerRadius=2;
    registerBack.clipsToBounds=YES;
    [back addSubview:registerBack];
    registerBack.userInteractionEnabled=YES;
    
    UILabel *registerLabel=[[UILabel alloc]initWithFrame:registerBack.bounds];
    registerLabel.text=@"注册";
    registerLabel.font=[UIFont boldSystemFontOfSize:13];
    registerLabel.textColor=[UIColor whiteColor];
    registerLabel.textAlignment=NSTextAlignmentCenter;
    [registerBack addSubview:registerLabel];
    
    UIImageView *registerArrow=[[UIImageView alloc]initWithFrame:CGRectMake(registerBack.bounds.size.width-15, 5, 10, 12)];
    
    registerArrow.image=[UIImage imageNamed:@"commendArrow.png"];
    [registerBack addSubview:registerArrow];
    
    UIButton *registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame=registerBack.bounds;
    [registerButton addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.tag=100;
    [registerBack addSubview:registerButton];
    
    UIImageView *loginBack=[[UIImageView alloc]init];
    if (iPhone6Plus) {
        loginBack.frame=CGRectMake(10+self.view.bounds.size.width/2-5, back.bounds.size.height-40+5, self.view.bounds.size.width/2-15, 33-5);
    }else
    {
        loginBack.frame=CGRectMake(10+self.view.bounds.size.width/2-5, back.bounds.size.height-30, self.view.bounds.size.width/2-15, 23);
    }
    loginBack.image=[UIImage imageNamed:@"btnRedCornerSel.png"];
    loginBack.layer.cornerRadius=2;
    loginBack.clipsToBounds=YES;
    [back addSubview:loginBack];
    loginBack.userInteractionEnabled=YES;
    
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:registerBack.bounds];
    loginLabel.text=@"登录";
    loginLabel.font=[UIFont boldSystemFontOfSize:13];
    loginLabel.textColor=[UIColor whiteColor];
    loginLabel.textAlignment=NSTextAlignmentCenter;
    [loginBack addSubview:loginLabel];
    
    UIImageView *loginArrow=[[UIImageView alloc]init];
    if (iPhone6Plus) {
        loginArrow.frame=CGRectMake(loginBack.bounds.size.width-15, 5+3, 10, 12);
    }else
    {
        loginArrow.frame=CGRectMake(loginBack.bounds.size.width-15, 5, 10, 12);
    }
    loginArrow.image=[UIImage imageNamed:@"commendArrow.png"];
    [loginBack addSubview:loginArrow];
    
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame=loginBack.bounds;
    [loginButton addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag=102;
    [loginBack addSubview:loginButton];
}

//注册登陆
-(void)goRegister:(UIButton *)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
        
    }];
}
-(void)createTableView
{
    if (!_LVTableView) {
        _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-46+20) style:UITableViewStyleGrouped];
        _LVTableView.delegate=self;
        _LVTableView.dataSource=self;
        _LVTableView.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [_LVTableView setSeparatorInset:UIEdgeInsetsZero];
        [_LVTableView setLayoutMargins:UIEdgeInsetsZero];

        [self.view addSubview:_LVTableView];
        [self createHeader];
    }
}

#pragma mark tableview delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>0) {
        static NSString *cellIde=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=@"";
        cell.imageView.image=nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.section>0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=[[_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:12];
            cell.textLabel.textColor=[UIColor grayColor];
            cell.imageView.image=[UIImage imageNamed:[[_picArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        }
        return cell;
    }else
    {
        if (indexPath.row==0) {
            static NSString *cellIde=@"cellName";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text=@"";
            cell.detailTextLabel.text=@"";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"全部订单";
            cell.detailTextLabel.text=@"查看所有订单";
            cell.textLabel.font=[UIFont systemFontOfSize:12];
            cell.textLabel.textColor=[UIColor grayColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=[UIColor grayColor];
            return cell;
        }else
        {
            static NSString *cellIde=@"cellName";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            NSArray *picArray=[NSArray arrayWithObjects:@"myDeliver.png",@"myPay.png",@"myReceive.png",@"myEvaluate.png",@"myCellIcon20.png",nil];
            NSArray *textArray=[NSArray arrayWithObjects:@"待审核",@"待支付",@"待出行",@"待点评",@"退款",nil];
            for (int i=0; i<5; i++) {
                UIImageView *back=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width/5, 0, self.view.bounds.size.width/5, 40)];
                back.image=[UIImage imageNamed:[picArray objectAtIndex:i]];
                [cell addSubview:back];
                back.contentMode=UIViewContentModeCenter;
                
                UILabel *information=[[UILabel alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width/5, back.bounds.size.height-3, self.view.bounds.size.width/5, 20)];
                information.text=[textArray objectAtIndex:i];
                information.font=[UIFont boldSystemFontOfSize:12];
                information.textColor=[UIColor grayColor];
                information.textAlignment=NSTextAlignmentCenter;
                [cell addSubview:information];
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(i*self.view.bounds.size.width/5, 0, self.view.bounds.size.width/5, cell.bounds.size.height);
                [button addTarget:self action:@selector(processes:) forControlEvents:UIControlEventTouchUpInside];
                button.tag=100+i;
                [cell addSubview:button];
            }
            
            return cell;
        }
    }
}
-(void)processes:(UIButton *)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 40;
        }else{
            if (iPhone6Plus) {
                return 60;
            }else
            {
                return 60;
            }
        }
    }else
    {
        if (iPhone6Plus) {
            return 50;
        }else
        {
            return 40;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    foot.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    return foot;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    return head;
}
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>0) {
        LogInViewController *log=[[LogInViewController alloc]init];
        log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:log animated:YES completion:^{
        }];
    }else
    {
        if (indexPath.row==0) {
            LogInViewController *log=[[LogInViewController alloc]init];
            log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [self presentViewController:log animated:YES completion:^{
            }];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
