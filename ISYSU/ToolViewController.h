//
//  ToolViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolBusController.h"
#import "CalendarPageOneController.h"
#import "ChooseMapController.h"
#import "CommunicateTableViewController.h"
#import "CommunicateSquare.h"
#import "CommunicateItem.h"
#import "HotelTableViewController.h"
#import "ChooseFoodController.h"

@interface ToolViewController : UIViewController
{
    UIButton *schoolBus;
    UIButton *communication;
    UIButton *canteen;
    UIButton *maps;
    HotelTableViewController *hotelController;
    UIButton *hotel;
	SchoolBusController *mySchoolBusController;
	UIButton *schoolCalendar;
	CalendarPageOneController *mySchoolCalendarController;
    ChooseMapController *myChooseMapController;
    UIButton *communicate;
	CommunicateTableViewController* tableViewController;
    ChooseFoodController *foodViewController;
}

@property (nonatomic, retain) UIButton *communicate;
- (void)communicateAction:(id)sender;
@property (nonatomic,strong)HotelTableViewController *hotelController;
@property (nonatomic, retain) CommunicateTableViewController* tableViewController;
@property (nonatomic, retain) ChooseMapController *myChooseMapController;
@property (nonatomic,retain) ChooseFoodController *foodViewController;
@property (nonatomic, retain) UIButton *map;
- (void)mapAction:(id)sender;
@property (nonatomic, retain) SchoolBusController *mySchoolBusController;
@property (nonatomic, retain) UIButton *schoolBus;
- (void)busAction:(id)sender;
@property (nonatomic, retain) CalendarPageOneController *mySchoolCalendarController;
@property (nonatomic, retain) UIButton *schoolCalendar;
- (void)calendarAction:(id)sender;


@end
