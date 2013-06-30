
#import "ISYSUNewsData.h"


@implementation ISYSUNewsData

@synthesize readNews=_readNews;


- (id) init{
	self = [super init];
	if(self){
		_readNews = [[NSMutableSet alloc] init];
	}
	
	return self;
}

- (void) dealloc{
	[_readNews release];
	
	[super dealloc];
}

+ (id) sharedInstance{
	static ISYSUNewsData *_sharedInstance = nil;
	if(_sharedInstance==nil){
		NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *filePath = [documentsPath stringByAppendingString:@"/newsData"];
		_sharedInstance = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] retain];
		if(_sharedInstance==nil)
			_sharedInstance = [[ISYSUNewsData alloc] init];
	}
	
	return _sharedInstance;
}

+ (void) save{
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsPath stringByAppendingString:@"/newsData"];
	[NSKeyedArchiver archiveRootObject:[self sharedInstance] toFile:filePath];
}

#pragma mark -
#pragma mark NSCoding

#define kReadNewsKey	@"readNews"

- (id) initWithCoder:(NSCoder*)decoder{
	self = [super init];
	if(self){
		_readNews = [[decoder decodeObjectForKey:kReadNewsKey] retain];
	}
	
	return self;
}

- (void) encodeWithCoder:(NSCoder*)coder{
	[coder encodeObject:_readNews forKey:kReadNewsKey];
}

@end
