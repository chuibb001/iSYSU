
#import <Foundation/Foundation.h>

#define SCRIPTS_URL @"http://pcast.sysu.edu.cn/isysu/"



@protocol ISYSUGetterDelegate
@required
- (void) getterFailed:(id)getter;
- (void) getterSucceeded:(id)getter withInfo:(NSDictionary*)info;
@end