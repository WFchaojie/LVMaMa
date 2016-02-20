//
//  NewsDownLoad.h
//  Phoenix News
//
//  Created by apple on 14-11-30.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class LVDownLoad;
@protocol downLoadFinish <NSObject>

-(void)downLoadFinish:(LVDownLoad*)downLoad;

@end
@interface LVDownLoad : NSObject
@property (nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSMutableDictionary *jsonData;
@property(nonatomic,weak)__weak id<downLoadFinish>delegate;
@property(nonatomic)int type;
-(void)downLoad;
-(void)downLoadWithDic:(NSDictionary *)dic;

@end
