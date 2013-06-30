//
//  DCGridView.m
//  DCGridView
//
//  Created by Dwyane Cheuk on 11-3-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DCGridView.h"

@interface DCGridView(private)

- (NSArray *)prepareFrames;
- (NSArray *)combineGrids:(NSArray *)grids withImages:(NSArray *)images;

@end

@implementation DCGridView
@synthesize titles=_titles, shouldUseTitle=_shouldUseTitle, adjustsImageWhenHighlighted=_adjustsImageWhenHighlighted, delegate=_delegate;
@synthesize shouldUseImageFrame=_shouldUseImageFrame;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //self.backgroundColor = [UIColor whiteColor];
		kNumOfGridRow = 4;
		kNumOfGridCol = 3;
		kNumOfGrids = 10;
        _shouldUseImageFrame = NO;
    }
    return self;
}

- (void)dealloc {
	[_images release];
    [super dealloc];
	NSLog(@"DCGridView dealloced");
}

- (void)showGrids {
	_grids = [[self prepareFrames] retain];
	_grids = [self combineGrids:_grids withImages:_images];
	for (int i = 0; i < [_grids count]; i++) {
		UIButton *grid = [_grids objectAtIndex:i];
		[grid addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[grid addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
		[grid addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
		
		
		[self addSubview:grid];
		if (self.shouldUseTitle) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(grid.frame.origin.x,
																	   grid.frame.origin.y + grid.frame.size.height,
																	   grid.frame.size.width, 
																	   20)];
			label.text = [self.titles objectAtIndex:i];
			label.textAlignment = UITextAlignmentCenter;
			label.backgroundColor = [UIColor clearColor];
			[self addSubview:label];
			[label release];
		}
	}
}

- (NSArray *)prepareFrames {
	NSMutableArray *grids = [NSMutableArray arrayWithCapacity:kNumOfGrids];
	
	for (int row = 0; row < kNumOfGridRow; row++) {
		for (int col = 0; col < kNumOfGridCol; col++) {
			UIButton *button;
			int index = row*kNumOfGridCol + col;
			if (index >= kNumOfGrids) {
				return grids;
			}
			
			if (index < [grids count]) {
				button = [grids objectAtIndex:index];
			} else {
				button = [UIButton buttonWithType:UIButtonTypeCustom];
				button.tag = index;
				
				[grids addObject:button];
			}
			
			CGRect frame = CGRectMake(kGridOriginX+col*(kGridColSpace+kGridWidth),
									  kGridOriginY+row*(kGridRowSpace+kGridHeight), 
									  kGridWidth, 
									  kGridHeight);
			button.frame = frame;
			//button.backgroundColor = [UIColor blueColor];
		}
	}
	
	return grids;
}

- (NSArray *)combineGrids:(NSArray *)grids withImages:(NSArray *)images{
	
	for (int i = 0; i < [grids count] && i < [images count]; i++) {
		UIButton *button = [grids objectAtIndex:i];
		UIImage *image = [images objectAtIndex:i];
		
        /*
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kGridWidth, kGridHeight)];
		
		imageView.image = image;
		[button addSubview:imageView];
		[imageView release];
         */
		/*
		if (self.adjustsImageWhenHighlighted) {
			[button setImage:image forState:UIControlStateNormal];
		} else {
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kGridWidth, kGridHeight)];
			
			imageView.image = image;
			[button addSubview:imageView];
			[imageView release];
		}
		 */
        
        [button setImage:image forState:UIControlStateNormal];
		if (_shouldUseImageFrame) {
            [button setBackgroundImage:[UIImage imageNamed:@"App_buttonbg_0"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"App_buttonbg_1"] forState:UIControlStateHighlighted];
        }
		
		button.adjustsImageWhenHighlighted = self.adjustsImageWhenHighlighted;
	}
	return grids;
}

- (void)buttonTouchDown:(UIButton *)button {
	[UIView beginAnimations:nil context:nil];
	[button setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
	[UIView commitAnimations];
}

- (void)buttonTouchUpInside:(UIButton *)button {
	//[UIView beginAnimations:nil context:nil];
	[button setTransform:CGAffineTransformIdentity];
	//[UIView commitAnimations];
	if (_delegate != nil && [_delegate respondsToSelector:@selector(DCGridView:didChooseIndex:)]) {
		[_delegate DCGridView:self didChooseIndex:button.tag];
	}
}

- (void)buttonTouchUpOutside:(UIButton *)button {
	//[UIView beginAnimations:nil context:nil];
	[button setTransform:CGAffineTransformIdentity];
	//[UIView commitAnimations];
}


- (void)setNumOfGrids:(NSInteger)numOfGrids {
	kNumOfGrids = numOfGrids;
}

- (void)setNumOfRow:(NSInteger)numOfRow andNumOfCol:(NSInteger)numOfCol {
	if (numOfRow > 0) {
		kNumOfGridRow = numOfRow;
	}
	if (numOfCol > 0) {
		kNumOfGridCol = numOfCol;
	}
}

- (void)setOriginalX:(CGFloat)x andY:(CGFloat)y {
	kGridOriginX = x;
	kGridOriginY = y;
}

- (void)setGridWidth:(CGFloat)width andHeight:(CGFloat)height {
	kGridWidth = width;
	kGridHeight = height;
}

- (void)setRowSpace:(CGFloat)rowSpace andColSpace:(CGFloat)colSpace {
	kGridRowSpace = rowSpace;
	kGridColSpace = colSpace;
}

- (void)setImages:(NSArray *)images forControlState:(UIControlState)state {
	if (_images == images) {
		return;
	}
	[_images release];
	_images = [images retain];
}


@end
