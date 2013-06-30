//
//  WeiboDetailViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

//评论页面
#import <UIKit/UIKit.h>

@interface WeiboDetailViewController : UIViewController<UITextViewDelegate>
{
    
    UIView *emotionsBack;  //表情栏的background
    UIScrollView *emotionsView;  //表情栏的滚动视图
    UIPageControl *pageControl; //表情分页控制
    NSArray *weiboEmotions; //微博表情
    NSArray *weiboEmotions2; //微博表情2
    
    CGFloat animDuration; //键盘退出需要的时间
    CGRect keyboards;
    UIButton *tooEmotion;
    UIButton *toEmotion;
    
    BOOL NotYet;
    
    UIView *toolView; //工具栏的背景
}



@property (nonatomic, retain)NSString *aID;
@property (nonatomic, retain)UITextView *content;
-(id)initWithID:(NSString *)ID;
@end
