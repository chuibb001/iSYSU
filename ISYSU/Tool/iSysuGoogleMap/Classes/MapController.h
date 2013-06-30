//
//  MapController.h
//  iSysuGoogleMap
//
//  Created by 王 清云 on 11-3-2.
//  Copyright 2011 中山大学. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapController : UIViewController {
    UIWebView *webView;
	NSString *mTitle;
	NSString *htmlTitle;
}
@property (nonatomic, retain)UIWebView *webView;
@property (retain) NSString *mTitle;
@property (retain) NSString *htmlTitle;
@end
