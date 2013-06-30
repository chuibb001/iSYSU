//
//  iSysuGoogleMapAppDelegate.h
//  iSysuGoogleMap
//
//  Created by 王 清云 on 11-2-23.
//  Copyright 中山大学 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iSysuGoogleMapAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

