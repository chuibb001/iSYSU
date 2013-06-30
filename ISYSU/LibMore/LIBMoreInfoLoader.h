//
//  LIBMoreInfoLoader.h
//  iSYSU Library
//
//  Created by Lancy on 19/3/13.
//  Copyright (c) 2013 SYSU APPLE CLUB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LIBMoreInfoLoaderErrorServerNotResponse = 0,
    LIBMoreInfoLoaderErrorBadRequest = 400,
    LIBMoreInfoLoaderErrorSessionExpiredSession = 403,
    LIBMoreInfoLoaderErrorRequestTimeout = 408
} LIBMoreInfoLoaderError;

@class LIBMoreInfoLoader;

@protocol LIBMoreInfoLoaderDelegate <NSObject>

@optional
- (void)moreInfoLoader:(LIBMoreInfoLoader *)loader didGetAppItems:(NSDictionary *)appItems;
- (void)moreInfoLoader:(LIBMoreInfoLoader *)loader didFailedGetAppItemsWithError:(LIBMoreInfoLoaderError)error;

@end



@interface LIBMoreInfoLoader : NSObject

@property (weak, nonatomic) id<LIBMoreInfoLoaderDelegate> delegate;

- (void)requestAppItems;

@end
