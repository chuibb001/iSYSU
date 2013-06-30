//
//  DCGridView.h
//  DCGridView
//
//  Created by Dwyane Cheuk on 11-3-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCGridView;
@protocol DCGridViewDelegate
@optional
- (void) DCGridView:(DCGridView *)gridView didChooseIndex:(NSInteger)index;
@end


@interface DCGridView : UIView {
	NSArray *_grids;
	NSArray *_images;
	NSArray *_selectedImages;
	NSMutableArray *_titles;
	
	float kGridOriginX, kGridOriginY;
	float kGridWidth, kGridHeight;
	float kGridRowSpace, kGridColSpace;
	NSInteger kNumOfGridRow, kNumOfGridCol;
	NSInteger kNumOfGrids;
	
    BOOL _shouldUseImageFrame;
	BOOL _shouldUseTitle;
	BOOL _adjustsImageWhenHighlighted;
	NSObject<DCGridViewDelegate> *_delegate;
}

@property (nonatomic, assign) NSObject<DCGridViewDelegate> *delegate;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, assign) BOOL shouldUseImageFrame;
@property (nonatomic, assign) BOOL shouldUseTitle;
@property (nonatomic, assign) BOOL adjustsImageWhenHighlighted;

-(void)setNumOfGrids:(NSInteger)numOfGrids;
-(void)setNumOfRow:(NSInteger)numOfRow andNumOfCol:(NSInteger)numOfCol;
-(void)setOriginalX:(CGFloat)x andY:(CGFloat)y;
-(void)setGridWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)setRowSpace:(CGFloat)rowSpace andColSpace:(CGFloat)colSpace;

-(void)setImages:(NSArray *)images forControlState:(UIControlState)state;
-(void)showGrids;

@end
