//
//  MainViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//




/*------------
    已弃用
 --------------*/
#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

@property (nonatomic,readwrite) int currentIndex;
@property (nonatomic,retain) NSMutableArray *tabs;
@property (nonatomic,retain) UIImageView *slideBg;
@property (nonatomic,retain) NSArray *image_selected;
@property (nonatomic,retain) NSArray *image_unselected;
@property (nonatomic,retain) UIImageView *TabBarBackground;
@end
