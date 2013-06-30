//
//  LIBAppItemCell.h
//  iSYSU Library
//
//  Created by Lancy on 17/3/13.
//  Copyright (c) 2013 SYSU APPLE CLUB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIBAppItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *sideButton;

@end
