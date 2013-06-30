//
//  ChooseMapController.h
//  iSysuMap
//
//  Created by 王 清云 on 11-2-23.
//  Copyright 2011 中山大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodController.h"
#import "DCGridView.h"

@interface ChooseFoodController : UIViewController<DCGridViewDelegate> {
	UIButton *east;
	FoodController *myFoodController;
	UIButton *north;
	//NorthMapController *myNorthMapController;
	UIButton *south;
	//SouthMapController *mySouthMapController;
	UIButton *zhuhai;
	//ZhuhaiMapController *myZhuhaiMapController;
}

@property (nonatomic, retain) FoodController *myFoodController;
@property (nonatomic, retain) UIButton *east;
- (void)EastAction:(id)sender;
//@property (nonatomic, retain) NorthMapController *myNorthMapController;
@property (nonatomic, retain) UIButton *north;
- (void)NorthAction:(id)sender;
//@property (nonatomic, retain) SouthMapController *mySouthMapController;
@property (nonatomic, retain) UIButton *south;
- (void)SouthAction:(id)sender;
//@property (nonatomic, retain) ZhuhaiMapController *myZhuhaiMapController;
@property (nonatomic, retain) UIButton *zhuhai;
- (void)ZhuhaiAction:(id)sender;
-(void)leftButtonClick;
@end
