//
//  LIBMoreInfoLoader.m
//  iSYSU Library
//
//  Created by Lancy on 19/3/13.
//  Copyright (c) 2013 SYSU APPLE CLUB. All rights reserved.
//

#import "LIBMoreInfoLoader.h"
#import "ASIHTTPRequest.h"
#import "NSString+CYHelper.h"

#import "LIBConstants.h"


@implementation LIBMoreInfoLoader

- (void)requestAppItems
{
    NSURL *url = [NSURL URLWithString:(NSString *)kMoreInfoUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:( ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *result = [responseString jsonObject];
    if ([self.delegate respondsToSelector:@selector(moreInfoLoader:didGetAppItems:)]) {
        [self.delegate moreInfoLoader:self didGetAppItems:result];
    }
}
- (void)requestFailed:( ASIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(moreInfoLoader:didFailedGetAppItemsWithError:)]) {
        [self.delegate moreInfoLoader:self didFailedGetAppItemsWithError:LIBMoreInfoLoaderErrorServerNotResponse];
    }
}

@end
