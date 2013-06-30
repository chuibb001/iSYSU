

#import "CommunicateSquare.h"


@implementation CommunicateSquare

@synthesize name, quotations;

- (void)dealloc {
    [name release];
    [quotations release];
    [super dealloc];
}

@end
