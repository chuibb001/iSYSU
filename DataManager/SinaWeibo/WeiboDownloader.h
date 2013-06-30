//
//  WeiboDownloader.h
//  ISYSU
//
//  Created by simon on 13-3-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeiboData.h"
@class WeiboDownloader;
@protocol WeiboOperationDelegate <NSObject>

-(void)weiboDidGet:(id)result;
-(void)weiboDidFail;

@end

@interface WeiboDownloader : NSOperation<SinaWeiboRequestDelegate>
{
    Boolean shouldEnd;
}

@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *page;
@property (nonatomic,retain) NSString *count;
@property (nonatomic,weak) id<WeiboOperationDelegate> delegate;

-(id)initWithUserId:(NSString *)user Page:(NSString *)p Count:(NSString *)c;
@end
