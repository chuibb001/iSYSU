//
//  DisplayCell.h
//  Timeline
//
//  Created by simon on 12-12-13.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayCell : UITableViewCell

@property(retain,nonatomic) UILabel *articleTitle;
@property(retain,nonatomic) UILabel *articleDate;
@property(retain,nonatomic) UIImageView *readTag;

@end
