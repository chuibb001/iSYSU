//
//  CommentCell.h
//  ISYSU
//
//  Created by 王 瑞 on 13-3-21.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextView.h"
@interface CommentCell : UITableViewCell


@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)ImageTextView *content;
@property (nonatomic, retain)UIImageView *avart;
@property (nonatomic, retain)UILabel *date;
@end
