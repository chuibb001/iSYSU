//
//  ImageTextView.h
//  Timeline
//
//  Created by simon on 12-12-7.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTextView : UIView
{
    NSString *_text;
    NSMutableArray *_emojis;
    
    NSArray *weiboEmotions; //微博表情
    
    UIFont *font;
    UIColor *nomalColor;
    
}

@property (nonatomic, retain) NSMutableArray *emojis;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *colorLink;
@property (nonatomic, strong) UIColor *colorHashtag;

@end
