//
//  NewsScriptLoader.h
//  ISYSU
//
//  Created by simon on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsScriptLoaderDelegate;


@interface NewsScriptLoader : NSObject

@property (nonatomic,weak) id<NewsScriptLoaderDelegate> delegate;
@property (nonatomic,assign) int type;

-(void)requestItems;

@end

@protocol NewsScriptLoaderDelegate <NSObject>

-(void)didGetItems:(NSString *)script;
-(void)didFail;

@end