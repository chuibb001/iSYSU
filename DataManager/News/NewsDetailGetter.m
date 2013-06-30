//
//  NewsDetailGetter.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "NewsDetailGetter.h"

@implementation NewsDetailGetter
@synthesize articleID;

- (id) initWithArticleID:(NSString*)_articleID delegate:(id<ISYSUGetterDelegate>)_delegate{
	self=[super init];
	if(self){
		articleID = _articleID;
		delegate = _delegate;
		NSString *urlString = [NSString stringWithFormat:@"http://news2.sysu.edu.cn/news01/%@.htm",articleID];
		connection = [IHURLConnection connectionWithURLString:urlString delegate:self];
        self.loader=[[NewsScriptLoader alloc] init];
	}
	
	return self;
}

+ (id) getterWithArticleID:(NSString*)articleID delegate:(id<ISYSUGetterDelegate>)delegate{
	return [[self alloc] initWithArticleID:articleID delegate:delegate];
}

- (void) cancel{
	if(connection==nil&&infoHunter==nil)
		return;
	
	[connection cancel];
	connection = nil;
	[infoHunter cancel];
	infoHunter = nil;
	
}

-(void)requestScript
{
    self.loader.delegate=self;
    self.loader.type=2;
    [self.loader requestItems];
}

#pragma mark NewsScriptDelegate
-(void)didGetItems:(NSString *)script
{
    [InfoHunter hunterWithString:htmlcontent script:script delegate:self];  //html+解析脚本+delegate
}
-(void)didFail
{
    NSString *script = [NewsDetailGetter script];
    infoHunter = [InfoHunter hunterWithString:htmlcontent script:script delegate:self];
}

+ (void)updateTheScriptWithUrlString:(NSString *)urlString;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newsArticle" ofType:@"ihs"];
    NSString *url = [urlString stringByAppendingString:@"newsArticle.ihs"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data != nil) {
        [data writeToFile:path atomically:YES];
      //  NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"str:%@", str);
    }
}

+ (NSString*) script{
	static NSString *_script = nil;
	if(_script==nil){
        [self updateTheScriptWithUrlString:SCRIPTS_URL];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"newsArticle" ofType:@"ihs"];
		_script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	}
	return _script;
}

#pragma mark IHURLConnectionDelegate

- (void) connectionFailed:(IHURLConnection *)connection{
	connection = nil;
	[delegate getterFailed:self];
}

- (void) connection:(IHURLConnection*)connection finishedLoadingWithData:(NSData*)data{
	connection = nil;
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(string){
        htmlcontent=string;
        [self requestScript];
    }else{
        [delegate getterFailed:self];
    }
}

#pragma mark InfoHunterDelegate

- (void) hunter:(InfoHunter *)hunter finishedWithResult:(NSMutableDictionary *)dict{
	if(dict!=nil)
		[delegate getterSucceeded:self withInfo:dict];
	else
		[delegate getterFailed:self];
	
}
@end
