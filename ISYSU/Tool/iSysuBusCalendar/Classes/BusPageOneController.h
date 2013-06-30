//
//  BusPageOneController.h
//  iSysuLu
//
//  Created by 王 清云 on 11-2-25.
//  Copyright 2011 中山大学. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BusPageOneController : UIViewController {
	UIWebView *webView;
	NSString *mTitle;
	NSString *htmlTitle;
}
@property (nonatomic, retain) UIWebView *webView;
@property (retain) NSString *mTitle;
@property (retain) NSString *htmlTitle;
@end
