//
//  WeiboLoader.h
//  ISYSU
//
//  Created by simon on 13-3-29.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboDownloader.h"
@class WeiboLoader;

@protocol WeiboLoaderDelegate <NSObject>

-(void)requestDidSuccessWithData:(NSMutableArray *)result;
-(void)requestDidFailWithError;

@end

@interface WeiboLoader : NSObject<SinaWeiboRequestDelegate>
{
    int page;
    int count;
    int max;  //每次拉取微博的最大值
    int current;
    
    /*汇总时使用*/
    int current_receive_count;  //当前接收到第几个人的
    int max_receive_count;   //总共要接收多少个人（考虑到某些人会返回0条，就不算他了）
    
    SinaWeiboRequest *request;
}

@property (atomic,retain) NSMutableArray *returnWeibo;
@property (nonatomic,retain) NSMutableArray *tempArray; //排序
@property (retain, nonatomic) NSArray *idList;
@property (assign, nonatomic) id<WeiboLoaderDelegate> delegate;

-(void)requestWeiboWithIds:(NSArray *)ids Page:(int)p;
-(void)cancelRequest;
@end
