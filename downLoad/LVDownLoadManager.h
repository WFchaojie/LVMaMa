//
//  NewsDownLoadManager.h
//  Phoenix News
//
//  Created by apple on 14-11-30.
//
//

#import <Foundation/Foundation.h>
#import "LVDownLoad.h"
@interface LVDownLoadManager : NSObject<downLoadFinish>
+(LVDownLoadManager*)sharedDownLoadManager;

-(void)downLoadWithUrl:(NSString*)url and:(int)type;
-(void)downLoadWithPostUrl:(NSString*)url and:(int)type and:(NSDictionary *)dic;

-(id)getDownLoadDataForKey:(NSString*)key;

@end
