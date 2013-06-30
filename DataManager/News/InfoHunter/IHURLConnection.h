
/*	
 *	InfoHunter Framework
 *	Author: 张明锐(Mingrui Zhang)
 *	Email:	mingrui.developer@gmail.com
 */


#import <Foundation/Foundation.h>

@class IHURLConnection;
@protocol IHURLConnectionDelegate
@required
- (void) connectionFailed:(IHURLConnection*)connection;
- (void) connection:(IHURLConnection*)connection finishedLoadingWithData:(NSData*)data;
@end


@interface IHURLConnection : NSObject {
	@private
	NSString *_urlString;
	id<IHURLConnectionDelegate> _delegate;
	NSURLConnection *_connectionPtr;
	NSMutableData *_data;
	NSUInteger _dataSize;	//only for indication
}

@property(nonatomic,readonly) NSString *urlString;
@property(nonatomic,readonly) NSData *data;

//CAUTION: urlString should be added percent escapes
//CAUTION: delegate won't be retained
//will delay the error reply with delegate methods, never return nil!
+ (id) connectionWithURLString:(NSString*)urlString delegate:(id<IHURLConnectionDelegate>)delegate;
+ (id) connectionWithURLString:(NSString*)urlString userAgent:(NSString*)userAgent delegate:(id<IHURLConnectionDelegate>)delegate;


- (void) cancel;

@end

