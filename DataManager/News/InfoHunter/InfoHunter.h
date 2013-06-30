
/*	
 *	InfoHunter Framework
 *	Author: 张明锐(Mingrui Zhang)
 *	Email:	mingrui.developer@gmail.com
 */


#import <Foundation/Foundation.h>

#import "NSString(InfoHunter).h"

@class InfoHunter;

@protocol InfoHunterDelegate
//dict==nil if hunting failed
- (void) hunter:(InfoHunter*)hunter finishedWithResult:(NSMutableDictionary*)dict;
@end


@interface InfoHunter : NSObject {
	@private
	NSString *_string;
	NSString *_script;
	id<InfoHunterDelegate> _delegate;
	NSThread *_threadPtr;
	NSMutableDictionary *_result;
}


#pragma mark -
#pragma mark synchronous version

//return nil if hunting failed
+ (NSMutableDictionary*) huntWithString:(NSString*)string script:(NSString*)script;
#ifdef IHINTERNAL
+ (NSMutableDictionary*) huntWithAttributedString:(NSMutableAttributedString*)attributedString script:(NSString*)script;
#endif
//return nil if parsing succeeded, or error description if failed.
+ (NSString*) testScript:(NSString*)script;


#pragma mark -
#pragma mark asynchronous version

+ (InfoHunter*) hunterWithString:(NSString*)string script:(NSString*)script delegate:(id<InfoHunterDelegate>)delegate;
- (void) cancel;


@end
