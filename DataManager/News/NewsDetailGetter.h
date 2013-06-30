//
//  NewsDetailGetter.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISYSUProtocols.h"
#import "InfoHunter.h"
#import "IHURLConnection.h"
#import "NewsScriptLoader.h"

@interface NewsDetailGetter : NSObject<IHURLConnectionDelegate,InfoHunterDelegate,NewsScriptLoaderDelegate>
{
    NSString *articleID;
	id<ISYSUGetterDelegate> delegate;
	IHURLConnection *connection;
	InfoHunter *infoHunter;
    
    NSString *htmlcontent;
}

@property (nonatomic,retain) NewsScriptLoader *loader;

@property(nonatomic,readonly) NSString* articleID;

+ (id) getterWithArticleID:(NSString*)_articleID delegate:(id<ISYSUGetterDelegate>)_delegate;

- (void) cancel;

@end
