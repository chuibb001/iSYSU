//
//  BookingLoader.h
//  ISYSU
//
//  Created by simon on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
/*error type*/
typedef enum {
    BookingLoaderErrorServerNotResponse = 0,
    BookingLoaderErrorBadRequest = 400,
    BookingLoaderErrorSessionExpiredSession = 403,
    BookingLoaderErrorRequestTimeout = 408
} BookingLoaderError;


/*protocol*/
@class BookingLoader;

@protocol BookingLoaderDelegate <NSObject>

@optional
- (void)bookingLoader:(BookingLoader *)loader didGetBookingItems:(NSArray *)appItems;
- (void)bookingLoader:(BookingLoader *)loader didFailedGetBookingItemsWithError:(BookingLoaderError)error;

@end

/*class*/
@interface BookingLoader : NSObject
{
    ASIHTTPRequest *asiRequest;
}

@property (weak, nonatomic) id<BookingLoaderDelegate> delegate;

- (void)requestItems;
- (void)cancleRequest;

@end
