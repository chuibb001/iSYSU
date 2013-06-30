//
//  HotelTableViewController.h
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelSectionHeaderView.h"


@class HotelCell;

@interface HotelTableViewController : UITableViewController<HotelSectionHeaderViewDelegate>
{}

@property (nonatomic, retain) NSArray* plays;
@property (nonatomic, assign) HotelCell *quoteCell;
- (void)setUpPlaysArray;

@end
