//
//  HotelSectionHeaderView.m
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "HotelSectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HotelSectionHeaderView

@synthesize titleLabel, disclosureButton, delegate, section,squareButton;

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <HotelSectionHeaderViewDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        
        delegate = aDelegate;        
        self.userInteractionEnabled = YES;
        
        
        // Create and configure the title label.
        section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 10.0;
        titleLabelFrame.size.width -= 80.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        
        // Create and configure the disclosure button.
        disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disclosureButton.frame = CGRectMake(290.0, 5.0, 35.0, 35.0);
        [disclosureButton setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"arrow90.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
		
//		squareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        squareButton.frame = CGRectMake(20.0, 5.0, 35.0, 35.0);
//        [squareButton setImage:[UIImage imageNamed:@"squareIcon.png"] forState:UIControlStateNormal];
        //[squareButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
        //[squareButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:squareButton];
        
        // Set the colors for the gradient layer.
        /*static NSMutableArray *colors = nil;
         if (colors == nil) {
         colors = [[NSMutableArray alloc] initWithCapacity:3];
         UIColor *color = nil;
         color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
         [colors addObject:(id)[color CGColor]];
         color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
         [colors addObject:(id)[color CGColor]];
         color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
         [colors addObject:(id)[color CGColor]];
         }
         [(CAGradientLayer *)self.layer setColors:colors];
         [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
         *///self.backgroundColor=[UIColor blackColor];
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
        [self addSubview:titleLabel];
        
    }
    
    return self;
}


-(void)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    disclosureButton.selected = !disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (disclosureButton.selected) {
            if (
                
                [delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [delegate sectionHeaderView:self sectionOpened:section];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [delegate sectionHeaderView:self sectionClosed:section];
            }
        }
    }
}


@end
