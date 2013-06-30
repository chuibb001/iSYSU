//
//  NewsListGetter.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "NewsListGetter.h"

#define kURL	@"http://news2.sysu.edu.cn/news01/index.htm"

@implementation NewsListGetter

- (id) initWithDelegate:(id<ISYSUGetterDelegate>)_delegate andPage:(int)_page{
	self=[super init];
	if(self){
		delegate = _delegate;
        page=_page;
        if(page==1)
        {
            urlStr=kURL;
        }
        else
        {
            urlStr=[[NSString alloc] initWithFormat:@"http://news2.sysu.edu.cn/news01/index%d.htm",page-1];

        }
        connection = [IHURLConnection connectionWithURLString:urlStr  delegate:self];
        self.loader=[[NewsScriptLoader alloc] init];
	}
	
	return self;
}

/*静态构造*/
+ (id) getterWithDelegate:(id<ISYSUGetterDelegate>)delegate andPage:(int)page{
	return [[self alloc] initWithDelegate:delegate andPage:page];
}

- (void) cancel{
	if(connection==nil&& infoHunter==nil)
		return;
	
	[connection cancel];
	connection = nil;
	[infoHunter cancel];
	infoHunter = nil;
	
}

-(void)requestScript
{
    self.loader.delegate=self;
    self.loader.type=1;
    [self.loader requestItems];
}

#pragma mark NewsScriptDelegate
-(void)didGetItems:(NSString *)script
{
    [InfoHunter hunterWithString:htmlcontent script:script delegate:self];  //html+解析脚本+delegate
    
}
-(void)didFail
{
    NSString *script = [NewsListGetter script];  //返回newsList.ihs的脚本
    [InfoHunter hunterWithString:htmlcontent script:script delegate:self];  //html+解析脚本+delegate
}

#pragma mark handle script
/*更新newsList.ihs*/
+ (void)updateTheScriptWithUrlString:(NSString *)urlString;
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"newsList" ofType:@"ihs"];
    NSString *url = [urlString stringByAppendingString:@"newsList.ihs"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data != nil) {
        [data writeToFile:path atomically:YES];
       // NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
       // NSLog(@"str:%@", str);
    }
}

/*从nesList.ihs得到脚本字符串*/
+ (NSString*) script{
	static NSString *_script = nil;
	if(_script==nil){
       // [self updateTheScriptWithUrlString:SCRIPTS_URL];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"newsList" ofType:@"ihs"];
		_script = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	}
	return _script;
}

#pragma mark IHURLConnectionDelegate

- (void) connectionFailed:(IHURLConnection *)_connection{
	connection = nil;
	[delegate getterFailed:self];
}

- (void) connection:(IHURLConnection*)_connection finishedLoadingWithData:(NSData*)data{
    
	connection = nil;
    /*string为整个网页html文件*/
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(string){
        htmlcontent=string;
        /*请求脚本*/
        [self requestScript];
        
    }else{
        [delegate getterFailed:self];
    }
}


#pragma mark InfoHunterDelegate

- (void) hunter:(InfoHunter *)hunter finishedWithResult:(NSMutableDictionary *)dict{
    /*解析成功直接返回dic*/
	if(dict!=nil)
		[delegate getterSucceeded:self withInfo:dict];
	else
		[delegate getterFailed:self];
}


@end
