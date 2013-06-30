//
//  BigImageView.h
//  TimePill
//
//  Created by simon on 13-3-22.
//
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@protocol  BigImageViewDelegate;

@interface BigImageView : UIView

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIScrollView *scrollv;
@property(nonatomic, retain) UIImageView *imagev;
@property(nonatomic, retain) DACircularProgressView *progress;
@property(nonatomic, assign) id<BigImageViewDelegate> delegate;
@property(nonatomic, assign) int total_Bytes;
@property(nonatomic, assign) int current_Bytes;

-(void)startWithImage:(UIImage *)image;
- (id)initWithFrame:(CGRect)frame;
-(void)ResetImage:(UIImage *)image;
-(void)downloadFail;
-(void)stopAndHide;
-(void)AddProgress;

@end

@protocol BigImageViewDelegate
-(void)DidTapToCancle;
-(void)downloadFail;
@end