//
//  WeiboDownloader.m
//  ISYSU
//
//  Created by simon on 13-3-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "WeiboDownloader.h"

@implementation WeiboDownloader

-(id)initWithUserId:(NSString *)user Page:(NSString *)p Count:(NSString *)c
{
    self = [self init];
    if (self) {
        self.userId=user;
        self.page=p;
        self.count=c;
        shouldEnd=NO;
    }
    return self;
}

- (void)start {
   
    if (![self isCancelled]) {
        //NSLog(@"开始");
       // [NSThread sleepForTimeInterval:0];
        // 以异步方式处理事件，并设置代理
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setValue:self.userId forKey:@"uid"];
        [params setValue:self.count forKey:@"count"];
        [params setValue:self.page forKey:@"page"];
        [[SinaWeiboData shared].sinaweibo requestWithURL:@"statuses/user_timeline.json"
                           params:params
                       httpMethod:@"GET"
                         delegate:self];
        
        while(shouldEnd==NO) {
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
        }
    }
}

#pragma mark SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    shouldEnd=YES;
   // NSLog(@"成功");
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"weiboDidGet" object:result];
    if([self.delegate respondsToSelector:@selector(weiboDidGet:)])
        [self.delegate weiboDidGet:result];
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"weiboDidFail" object:nil];
    if([self.delegate respondsToSelector:@selector(weiboDidFail)])
        [self.delegate weiboDidFail];
}
-(BOOL)isConcurrent
{
    //返回yes表示支持异步调用，否则为支持同步调用
    return YES;
    
}
- (BOOL)isExecuting
{
    return shouldEnd==NO;
}
- (BOOL)isFinished
{
    return shouldEnd;
}

@end
