//
//  NewsDetailViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsDetailGetter.h"
#import "ISYSUNewsData.h"
#import "SVProgressHUD.h"
@interface NewsDetailViewController : UIViewController<ISYSUGetterDelegate>

@property (nonatomic,retain) NSString *articleID;
@property (nonatomic,retain) NewsDetailGetter *detailGetter;
@property (nonatomic,retain) UIWebView *webView;

- (id) initWithArticleIDs:(NSArray*)articleIDs index:(int)index;

@end
