//
//  NewsDownLoadManager.m
//  Phoenix News
//
//  Created by apple on 14-11-30.
//
//

#import "LVDownLoadManager.h"
@implementation LVDownLoadManager
{
    NSMutableDictionary *_resultDict;
    NSMutableDictionary *_taskDict;
}
+(LVDownLoadManager*)sharedDownLoadManager
{
    static LVDownLoadManager * sharedDownLoadManager;
    if (sharedDownLoadManager==nil) {
        sharedDownLoadManager=[[LVDownLoadManager alloc]init];
    }
    return sharedDownLoadManager;
}
-(id)init
{
    if (self=[super init]) {
        _resultDict=[[NSMutableDictionary alloc]init];
        _taskDict=[[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)downLoadWithUrl:(NSString*)url and:(int)type
{
    if ([_taskDict objectForKey:url]) {
        NSLog(@"任务正在下载");
    }else
    {
        LVDownLoad *downLoad=[[LVDownLoad alloc]init];
        downLoad.url=url;
        downLoad.type=type;
        downLoad.delegate=self;
        [downLoad downLoad];
        [_taskDict setObject:downLoad forKey:downLoad.url];
    }
}
-(void)downLoadWithPostUrl:(NSString*)url and:(int)type and:(NSDictionary *)dic
{
    if ([_taskDict objectForKey:url]==dic) {
        NSLog(@"任务正在下载");
    }else
    {
        LVDownLoad *downLoad=[[LVDownLoad alloc]init];
        downLoad.url=url;
        downLoad.type=type;
        downLoad.delegate=self;
        [downLoad downLoadWithDic:dic];
        [_taskDict setObject:dic forKey:downLoad.url];
    }
}

-(void)downLoadFinish:(LVDownLoad *)downLoad
{
    [_taskDict removeObjectForKey:downLoad.url];
    if (downLoad.type==0) {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSDictionary *item0=[datas objectAtIndex:0];
        NSArray *infos=[item0 objectForKey:@"infos"];
        NSMutableArray *returnInfos=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<infos.count; i++) {
            NSDictionary *items=[infos objectAtIndex:i];
            [returnInfos addObject:items];
        }
        
        [_resultDict setObject:returnInfos forKey:downLoad.url];

    }else if (downLoad.type==1)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSDictionary *item0=[datas objectAtIndex:0];
        NSArray *infos0=[item0 objectForKey:@"infos"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *returnInfos0=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<infos0.count; i++) {
            NSDictionary *items=[infos0 objectAtIndex:i];
            [returnInfos0 addObject:items];
        }
        [returnArray addObject:returnInfos0];
        
        NSDictionary *item1=[datas objectAtIndex:1];
        NSArray *infos1=[item1 objectForKey:@"infos"];
        NSMutableArray *returnInfos1=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<infos1.count; i++) {
            NSDictionary *items=[infos1 objectAtIndex:i];
            [returnInfos1 addObject:items];
        }
        [returnArray addObject:returnInfos1];
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==2)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSDictionary *item0=[datas objectAtIndex:0];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        /*
        NSArray *infos0=[item0 objectForKey:@"infos"];
        NSMutableArray *returnInfos0=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<=infos0.count-1; i++) {
            NSDictionary *items=[infos0 objectAtIndex:i];
            [returnInfos0 addObject:items];
        }
        NSDictionary *item1=[datas objectAtIndex:1];
        NSArray *infos1=[item1 objectForKey:@"infos"];
        for (int i=0; i<infos1.count; i++) {
            NSDictionary *items=[infos1 objectAtIndex:i];
            [returnInfos0 addObject:items];
        }
        [returnArray addObject:returnInfos0];
        */
        NSMutableArray *returnInfos1=[[NSMutableArray alloc]initWithCapacity:0];
        NSDictionary *item2=[datas objectAtIndex:2];
        NSArray *infos2=[item2 objectForKey:@"infos"];
        if (infos2.count!=0)
        {
            for (NSInteger i=infos2.count-1; i>=0; i--) {
                NSDictionary *items=[infos2 objectAtIndex:i];
                [returnInfos1 addObject:items];
            }
        }
        [returnArray addObject:returnInfos1];
        
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==3)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSDictionary *item0=[datas objectAtIndex:0];
        NSArray *infos0=[item0 objectForKey:@"infos"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *returnInfos0=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<infos0.count; i++) {
            NSDictionary *items=[infos0 objectAtIndex:i];
            [returnInfos0 addObject:items];
        }
        NSDictionary *item1=[datas objectAtIndex:1];
        NSMutableArray *returnInfos1=[[NSMutableArray alloc]initWithCapacity:0];
        NSArray *infos1=[item1 objectForKey:@"infos"];
        for (int i=0; i<infos1.count; i++) {
            NSDictionary *items=[infos1 objectAtIndex:i];
            [returnInfos1 addObject:items];
        }
        [returnArray addObject:returnInfos0];
        [returnArray addObject:returnInfos1];
        [_resultDict setObject:returnArray forKey:downLoad.url];

    }else if (downLoad.type==4)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSArray *array=[data objectForKey:@"list"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        if (array.count!=0) {
            for (int i=0; i<array.count; i++)
            {
                NSDictionary *dict=[array objectAtIndex:i];
                [returnArray addObject:dict];
            }
            NSDictionary *next=[NSDictionary dictionaryWithObject:[data objectForKey:@"hasNext"] forKey:@"hasNext"];
            [returnArray addObject:next];
            [_resultDict setObject:returnArray forKey:downLoad.url];
        }
    }else if (downLoad.type==5)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSArray *hotelList=[data objectForKey:@"hotelList"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<hotelList.count; i++) {
            NSDictionary *dict=[hotelList objectAtIndex:i];
            [returnArray addObject:dict];
        }
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==6)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        [returnArray addObject:data];
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==7)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        NSArray *list=[data objectForKey:@"items"];
        for (NSDictionary *item in list) {
            NSMutableDictionary *dictItem=[[NSMutableDictionary alloc]initWithDictionary:item];
            [returnArray addObject:dictItem];
        }
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==8)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        if (data!=nil) {
            [returnArray addObject:data];
        }
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==9)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<datas.count; i++) {
            NSMutableDictionary *items=[NSMutableDictionary dictionaryWithDictionary:[datas objectAtIndex:i]];
            NSMutableArray *infos=[[NSMutableArray alloc]initWithCapacity:0];
            for (NSArray *array in [items objectForKey:@"infos"]) {
                [infos addObject:array];
            }
            [items setObject:infos forKey:@"infos"];
            [returnArray addObject:items];
        }

        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==10)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSDictionary *groupbuyDetail=[data objectForKey:@"groupbuyDetail"];
        [_resultDict setObject:groupbuyDetail forKey:downLoad.url];
    }else if (downLoad.type==11)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *returnArray=[rootDict objectForKey:@"urls"];
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==12)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        [_resultDict setObject:data forKey:downLoad.url];
    }else if (downLoad.type==13)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *headArray = [[NSMutableArray alloc]initWithCapacity:0];
        NSMutableDictionary *headData=[[NSMutableDictionary alloc]initWithDictionary:data];
        [headData removeObjectForKey:@"tripDays"];
        [headArray addObject:headData];
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
        NSArray *tripDays=[data objectForKey:@"tripDays"];
        
        for (NSDictionary *dict in tripDays) {
            NSMutableArray *tripDays=[[NSMutableArray alloc]initWithCapacity:0];
            for (NSDictionary *tracks in [dict objectForKey:@"tracks"]) {
                NSMutableArray *dataTracks=[[NSMutableArray alloc]initWithCapacity:0];

                NSMutableDictionary *tracksDict=[[NSMutableDictionary alloc]initWithCapacity:0];
                [tracksDict setObject:[dict objectForKey:@"date"] forKeyedSubscript:@"date"];
                [tracksDict setObject:[tracks objectForKey:@"poiDesc"] forKeyedSubscript:@"poiDesc"];
                [tracksDict setObject:[tracks objectForKey:@"poiName"] forKeyedSubscript:@"poiName"];
                [dataTracks addObject:tracksDict];
                for (NSDictionary *segments in [tracks objectForKey:@"segments"]) {
                    NSMutableDictionary *segmentsData=[[NSMutableDictionary alloc]initWithDictionary:segments];
                    [segmentsData setObject:[tracks objectForKey:@"poiName"] forKeyedSubscript:@"poiName"];
                    [dataTracks addObject:segmentsData];
                }
                [tripDays addObjectsFromArray:dataTracks];
            }
            [dataArray addObject:tripDays];
        }
        [returnArray addObject:headArray];

        [returnArray addObject:dataArray];
        
        [_resultDict setObject:returnArray forKey:downLoad.url];
        
    }else if (downLoad.type==14)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSMutableArray *returnInfos=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<datas.count; i++) {
            NSDictionary *items=[datas objectAtIndex:i];
            [returnInfos addObject:items];
        }
        
        [_resultDict setObject:returnInfos forKey:downLoad.url];
    }else if (downLoad.type==15)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSArray *datas=[rootDict objectForKey:@"datas"];
        NSDictionary *item0=[datas objectAtIndex:0];
        NSArray *infos=[item0 objectForKey:@"infos"];
        NSMutableArray *returnInfos=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<infos.count; i++) {
            NSDictionary *items=[infos objectAtIndex:i];
            [returnInfos addObject:items];
        }
        [returnInfos addObject:[item0 objectForKey:@"isLastPage"]];
        [_resultDict setObject:returnInfos forKey:downLoad.url];
    }else if (downLoad.type==16)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSArray *array=[data objectForKey:@"secKillOnlyList"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        if (array.count!=0) {
            for (int i=0; i<array.count; i++)
            {
                NSDictionary *dict=[array objectAtIndex:i];
                [returnArray addObject:dict];
            }
            NSDictionary *next=[NSDictionary dictionaryWithObject:[data objectForKey:@"hasNext"] forKey:@"hasNext"];
            [returnArray addObject:next];
            [_resultDict setObject:returnArray forKey:downLoad.url];
        }
    }else if (downLoad.type==17)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSDictionary *groupbuyDetail=[data objectForKey:@"groupbuyDetail"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:0];
        [returnArray addObject:groupbuyDetail];
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }else if (downLoad.type==18)
    {
        NSDictionary *rootDict=[downLoad.jsonData objectForKey:downLoad.url];
        NSDictionary *data=[rootDict objectForKey:@"data"];
        NSArray *hotelList=[data objectForKey:@"hotelList"];
        NSMutableArray *returnArray=[[NSMutableArray alloc]initWithArray:hotelList];
        [_resultDict setObject:returnArray forKey:downLoad.url];
    }
        [[NSNotificationCenter defaultCenter]postNotificationName:downLoad.url object:nil];
}
-(id)getDownLoadDataForKey:(NSString *)key
{
    return [_resultDict objectForKey:key];
}
@end
