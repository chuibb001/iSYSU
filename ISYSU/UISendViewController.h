//
//  UISendViewController.h
//  ISYSU
//
//  Created by 王 瑞 on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISendViewController: UIViewController<UITextViewDelegate>
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
    
    UIView *toolView;
}



@property (nonatomic, retain)NSString *aID;
@property (nonatomic, retain)UITextView *content;
-(id)initWithID:(NSString *)ID;
@end
