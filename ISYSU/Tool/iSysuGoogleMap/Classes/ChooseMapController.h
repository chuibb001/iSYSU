//
//  ChooseMapController.h
//  iSysuMap
//
//  Created by 王 清云 on 11-2-23.
//  Copyright 2011 中山大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"


@interface ChooseMapController : UIViewController {
	UIButton *east;
	MapController *myMapController;
	UIButton *north;
	//NorthMapController *myNorthMapController;
	UIButton *south;
	//SouthMapController *mySouthMapController;
	UIButton *zhuhai;
//	//ZhuhaiMapController *myZhuhaiMapController;
}

@property (nonatomic, retain) MapController *myMapController;
//@property (nonatomic, retain) UIButton *east;
//- (void)EastAction:(id)sender;
////@property (nonatomic, retain) NorthMapController *myNorthMapController;
//@property (nonatomic, retain) UIButton *north;
//- (void)NorthAction:(id)sender;
////@property (nonatomic, retain) SouthMapController *mySouthMapController;
//@property (nonatomic, retain) UIButton *south;
//- (void)SouthAction:(id)sender;
////@property (nonatomic, retain) ZhuhaiMapController *myZhuhaiMapController;
//@property (nonatomic, retain) UIButton *zhuhai;

@property (nonatomic, strong) UIButton *leftButton;
- (void)ZhuhaiAction:(id)sender;
@end
