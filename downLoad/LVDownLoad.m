//
//  NewsDownLoad.m
//  Phoenix News
//
//  Created by apple on 14-11-30.
//
//

#import "LVDownLoad.h"

@implementation LVDownLoad

-(void)downLoad
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明请求的数据是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.jsonData=[[NSMutableDictionary alloc]init];
        [self.jsonData setObject:responseObject forKey:self.url];
        [self.delegate downLoadFinish:self];
        [self performSelectorInBackground:@selector(downLoadFinish) withObject:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        NSLog(@"error=%@",error);
        [[[UIAlertView alloc]initWithTitle:@"网络连接失败" message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NOINTERNET" object:nil];
    }];

    
}
-(void)downLoadFinish
{

}
-(void)downLoadWithDic:(NSDictionary *)dic
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];

    //发送请求
    [manager POST:_url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.jsonData=[[NSMutableDictionary alloc]init];
        [self.jsonData setObject:responseObject forKey:self.url];
        [self.delegate downLoadFinish:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
