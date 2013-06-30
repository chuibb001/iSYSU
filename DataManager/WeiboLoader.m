//
//  WeiboLoader.m
//  ISYSU
//
//  Created by simon on 13-3-29.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "WeiboLoader.h"

@implementation WeiboLoader

-(id)init
{
    self=[super init];
    if(self)
    {
        self.tempArray=[[NSMutableArray alloc] init];
        self.returnWeibo=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)requestWeiboWithIds:(NSArray *)ids Page:(int)p
{
    self.idList=ids;
    page=p;
    max=30;
    count=max/[self.idList count];  
    current_receive_count=0;
    max_receive_count=[self.idList count];
    current=0;
    //NSLog(@"idlist %d",[self.idList count]);
    [self startRequest];
    
}


#pragma mark SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    /*数据处理*/
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSLog(@"小计 %d",[statuses count]);
    
    if([statuses count]>count)  //K掉顶置的微博！！不按顺序他妈的！
    {
        NSMutableArray *a=[[NSMutableArray alloc] init];
        for(int i=1;i<[statuses count];i++)
        {
            [a addObject:[statuses objectAtIndex:i]];
        }
        [self.tempArray addObject:a];
        current_receive_count++;
    }
    else if([statuses count]>0)
    {
        [self.tempArray addObject:statuses];
        current_receive_count++;
    }
    else   /*某个人返回0条，不计入总数*/
    {
        max_receive_count--;
    }
    
    current++;
    if(current<[self.idList count])
    {
        [self startRequest];
    }
    else
    {
        [self readyToReload];
    }
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    max_receive_count--;
    
    current++;
    if(current<[self.idList count])
    {
        [self startRequest];
    }
    else
    {
        [self readyToReload];
    }
}
-(void)startRequest
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:[self.idList objectAtIndex:current] forKey:@"uid"];
    [params setValue:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    [params setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    request=[[SinaWeiboData shared].sinaweibo requestWithURL:@"statuses/user_timeline.json"
                                              params:params
                                          httpMethod:@"GET"
                                            delegate:self];
}
-(void)cancelRequest
{
    self.delegate=nil;
    [request cancelConnection];
}

-(void)readyToReload
{
    /*全部汇总完了*/
    if(current_receive_count==max_receive_count)
    {
        /*前提是保证至少有一个人返回微博*/
        if(max_receive_count!=0)
        {

            
            [self merge:0 andHigh:[self.tempArray count]-1];
            NSLog(@"tempArray count=%d",[self.tempArray count]);
            for(NSDictionary *dic in [self.tempArray objectAtIndex:0])
            {
                [self.returnWeibo addObject:dic];
                //NSLog(@"%@",[dic objectForKey:@"created_at"]);
            }
            
            NSLog(@"本次刷新的微博数%d",[self.returnWeibo count]);
            
            if([self.delegate respondsToSelector:@selector(requestDidSuccessWithData:)])
            {
                //NSLog(@"respondsToSelector");
                [self.delegate requestDidSuccessWithData:self.returnWeibo];
                if(page==1)
                {
                    [self writeToFile];
                }
            }     
            
        }
        else  //没有返回任何微博
        {

            if([self.delegate respondsToSelector:@selector(requestDidFailWithError)])
                [self.delegate requestDidFailWithError];
        }
        
        /*复位*/
        /*current_receive_count=0;
        max_receive_count=[self.idList count];*/
    }
    
}

#pragma mark merge sort
-(void)merge:(int)low andHigh:(int)high
{
    if(low<high)
    {
        double mid_double=round(((double)low+(double)high)/2);
        int mid=(int)mid_double;
        //NSLog(@"%d %d %d",low,high,mid);
        [self merge:low andHigh:mid-1];
        [self merge:mid andHigh:high];
        [self sort:low andHigh:mid];
    }
}
-(void)sort:(int)low andHigh:(int)high
{
    //NSLog(@"sort %d %d",low ,high);
    NSArray *first_array=[self.tempArray objectAtIndex:low];
    NSArray *second_array=[self.tempArray objectAtIndex:high];
    
    NSMutableArray *order_array=[[NSMutableArray alloc] init];
    
    int first=0;
    int second=0;
    /*
     for(NSDictionary *dic in first_array)
     {
     NSLog(@"排序前a%@",[dic objectForKey:@"created_at"]);
     }
     
     for(NSDictionary *dic in second_array)
     {
     NSLog(@"排序前b%@",[dic objectForKey:@"created_at"]);
     }
     */
    while (first!=[first_array count] && second!=[second_array count]) {
        
        NSDate *date1=[self fdateFromString:[[first_array objectAtIndex:first] objectForKey:@"created_at"]];
        NSDate *date2=[self fdateFromString:[[second_array objectAtIndex:second] objectForKey:@"created_at"]];
        NSComparisonResult result=[date1 compare:date2];
        if(result == NSOrderedDescending) //date1比较大
        {
            [order_array addObject:[first_array objectAtIndex:first]];
            first++;
        }
        else if (result == NSOrderedAscending)
        {
            [order_array addObject:[second_array objectAtIndex:second]];
            second++;
        }
        else
        {
            [order_array addObject:[first_array objectAtIndex:first]];
            first++;
            [order_array addObject:[second_array objectAtIndex:second]];
            second++;
        }
    }
    
    while (first!=[first_array count]) {
        [order_array addObject:[first_array objectAtIndex:first]];
        first++;
    }
    
    while (second!=[second_array count]) {
        [order_array addObject:[second_array objectAtIndex:second]];
        second++;
    }
    
    if(low<[self.tempArray count])
        [self.tempArray replaceObjectAtIndex:low withObject:order_array];
    /*NSArray *a=[self.tempArray objectAtIndex:low] ;
     for(NSDictionary *dic in a)
     {
     NSLog(@"排序后%@",[dic objectForKey:@"created_at"]);
     }*/

}

#pragma mark 文件
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count]!=0)
    {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingPathComponent:@"archive_weibo"];
    }
    return nil;
}
-(void)writeToFile
{
    //把第一次加载的数据保存在文件
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.returnWeibo forKey:@"default_weibo"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];

}
#pragma mark - 处理微博日期
- (NSDate *)fdateFromString:(NSString *)string {
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
    NSDate* date = [formater dateFromString:string];
    /*调整8小时时差*/
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
@end
