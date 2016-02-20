//
//  PindaoDetailViewController.m
//  LVMaMa
//
//  Created by 武超杰 on 15/7/31.
//  Copyright (c) 2015年 LVmama. All rights reserved.
//

#import "PindaoDetailViewController.h"
#import "LogInViewController.h"
@interface PindaoDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *LVTableView;
@end

@implementation PindaoDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftButton];
    [self rightButton];
    self.title=self.pindaoTitle;
    // Do any additional setup after loading the view.
}
-(void)rightButton
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *array=[NSArray arrayWithObjects:@"shareBtn.png",nil];
    for (int i=(int)array.count-1; i>=0; i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 0, 32, 32);
        [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
        button.tag=100+i;
        [items addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems=items;
}
-(void)rightClick:(UIButton *)button
{
    LogInViewController *log=[[LogInViewController alloc]init];
    log.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:log animated:YES completion:^{
    }];
}
-(void)createTableView
{
    _LVTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _LVTableView.delegate=self;
    _LVTableView.dataSource=self;
    [self.view addSubview:_LVTableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
