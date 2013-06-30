
#import <Foundation/Foundation.h>


@interface ISYSUNewsData : NSObject<NSCoding> {
	NSMutableSet *_readNews;	//set of articleID
}

@property(nonatomic,readonly) NSMutableSet* readNews;

+ (id) sharedInstance;
+ (void) save;

@end
