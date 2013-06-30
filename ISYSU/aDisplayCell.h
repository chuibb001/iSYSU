//
//  aDisplayCell.h
//  Timeline
//
//  Created by simon on 12-12-13.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextView.h"

@interface aDisplayCell : UITableViewCell
{
    NSString *weiboID;
}

@property(retain,nonatomic) UIImageView *headImageView;
@property(retain,nonatomic) UILabel *nameLabel;
@property(retain,nonatomic) UIButton *repostButton;
@property(retain,nonatomic) UIButton *commentButton;
@property(retain,nonatomic) ImageTextView *textView;
@property(retain,nonatomic) ImageTextView *repostTextView;
@property(retain,nonatomic) UIImageView *aImageView;
@property(retain,nonatomic) UIImageView *repostBackgroundView;
@property(retain,nonatomic) UILabel *timeLabel;

-(void)storeWeiboID:(NSString *)weiboID;
-(NSString *)getWeiboID;
@end
