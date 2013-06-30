//
//  AppDelegate.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NewsViewController.h"
#import "WeiboViewController.h"
#import "ToolViewController.h"
#import "LIBMoreViewController.h"
#import "OrderDisplayViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
        
    [self customizeiPhoneTheme];
    [self configureiPhoneTabBar];
    
    self.window.rootViewController=self.tabBarController;
    [self.window makeKeyAndVisible];
    
   
    return YES;
}

- (void)configureTabBarItemWithImageName:(NSString*)imageName andText:(NSString *)itemText forViewController:(UIViewController *)viewController
{
    UIImage* selectedImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_selected.png"]];
    UIImage* unselectedImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_unselected.png"]];
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:itemText image:selectedImage tag:0];
    [item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
    [viewController setTabBarItem:item1];
}

- (void)configureiPhoneTabBar
{
    NewsViewController *newsVC=[[NewsViewController alloc] init];
    OrderDisplayViewController *weiboVC=[[OrderDisplayViewController alloc] init];
    ToolViewController *toolVC=[[ToolViewController alloc] init];
    LIBMoreViewController *moreVC = [[LIBMoreViewController alloc] initWithNibName:@"LIBMoreViewController" bundle:nil];
    
    UINavigationController *nav1=[[UINavigationController alloc] initWithRootViewController:newsVC];
    UINavigationController *nav2=[[UINavigationController alloc] initWithRootViewController:weiboVC];
    UINavigationController *nav3=[[UINavigationController alloc] initWithRootViewController:toolVC];
    UINavigationController *nav4=[[UINavigationController alloc] initWithRootViewController:moreVC];
    
    NSMutableArray *vcs=[[NSMutableArray alloc] init];
    [vcs addObject:nav1];
    [vcs addObject:nav2];
    [vcs addObject:nav3];
    [vcs addObject:nav4];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers=vcs;  //设置选项卡的显示页面
    //[self.tabBarController setViewControllers:vcs animated:NO];
    self.tabBarController.selectedIndex=0;
	
    [self configureTabBarItemWithImageName:@"news" andText:@"新闻" forViewController:nav1];
    [self configureTabBarItemWithImageName:@"weibo" andText:@"微博" forViewController:nav2];
    [self configureTabBarItemWithImageName:@"tool" andText:@"工具" forViewController:nav3];
    [self configureTabBarItemWithImageName:@"more" andText:@"更多" forViewController:nav4];
}

- (void)customizeiPhoneTheme
{
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBarImage = [UIImage imageNamed:@"navibar.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButton = [[UIImage imageNamed:@"navibutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected.png"]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*调用本地微博客户端来授权的时候必须加上下面的代码*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[SinaWeiboData shared].sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[SinaWeiboData shared].sinaweibo handleOpenURL:url];
}
@end
