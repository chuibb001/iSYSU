//
//  NewsScriptLoader.m
//  ISYSU
//
//  Created by simon on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "NewsScriptLoader.h"
#import "ASIHTTPRequest.h"
#import "CYHelper.h"

#import "LIBConstants.h"
@implementation NewsScriptLoader

-(void)requestItems
{
    NSURL *url;
    if(self.type==1)
         url= [NSURL URLWithString:(NSString *)kNewsListUrl];
    else
        url= [NSURL URLWithString:(NSString *)kNewsArticleUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:( ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
   // NSLog(@"%@",responseString);
    if ([self.delegate respondsToSelector:@selector(didGetItems:)]) {
        [self.delegate didGetItems:responseString];
    }
}
- (void)requestFailed:( ASIHTTPRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(didFail)]) {
        [self.delegate didFail];
    }
}

@end
