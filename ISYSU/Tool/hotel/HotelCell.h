//
//  HotelCell.h
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelItem.h"

@interface HotelCell : UITableViewCell
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *addressLabel;
@property (nonatomic, retain) UILabel *numberLabel;

@property (nonatomic, retain) HotelItem *quotation;

@end
