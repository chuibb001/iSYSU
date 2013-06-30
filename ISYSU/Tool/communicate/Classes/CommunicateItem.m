

#import "CommunicateItem.h"


@implementation CommunicateItem

@synthesize numberName, number;

- (void)dealloc {
    [numberName release];
	[number release];
    //[quotation release];
    [super dealloc];
}

@end
