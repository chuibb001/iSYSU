//
//  NewsListGetter.h
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
@interface NewsListGetter : NSObject<IHURLConnectionDelegate,InfoHunterDelegate,NewsScriptLoaderDelegate>
{
    id<ISYSUGetterDelegate> delegate;
    IHURLConnection * connection;
    InfoHunter * infoHunter;
    int page;
    NSString *urlStr;
    NSString *htmlcontent;
}

@property (nonatomic,retain) NewsScriptLoader *loader;

+ (id) getterWithDelegate:(id<ISYSUGetterDelegate>)delegate andPage:(int)page;

- (void) cancel;

@end
