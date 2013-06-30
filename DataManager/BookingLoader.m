//
//  BookingLoader.m
//  ISYSU
//
//  Created by simon on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "BookingLoader.h"

#import "CYHelper.h"

#import "LIBConstants.h"

@implementation BookingLoader

- (void)requestItems
{
    NSURL *url = [NSURL URLWithString:(NSString *)kBookingUrl];
     asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest setDelegate:self];
    [asiRequest startAsynchronous];
    
}
- (void)requestFinished:( ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *result = [responseString jsonObject];
    //NSLog(@"%@",[(NSArray *)result objectAtIndex:0]);
    NSLog(@"订阅信息");
    if ([self.delegate respondsToSelector:@selector(bookingLoader:didGetBookingItems:)]) {
        NSLog(@"订阅信息response");
        [self.delegate bookingLoader:self didGetBookingItems:(NSArray *)result];
    }
}
- (void)requestFailed:( ASIHTTPRequest *)request
{
    NSLog(@"订阅信息f");
    if ([self.delegate respondsToSelector:@selector(bookingLoader:didFailedGetBookingItemsWithError:)]) {
        NSLog(@"订阅信息fail");
        [self.delegate bookingLoader:self didFailedGetBookingItemsWithError:BookingLoaderErrorServerNotResponse];
    }
}
- (void)cancleRequest
{
    [asiRequest clearDelegatesAndCancel];
    self.delegate=nil;
}

@end
