//
//  HotelSectionHeaderView.h
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelSectionHeaderViewDelegate;


@interface HotelSectionHeaderView : UIView

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, retain) UIButton *squareButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id <HotelSectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <HotelSectionHeaderViewDelegate>)aDelegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end


/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol HotelSectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(HotelSectionHeaderView*)hotelSectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(HotelSectionHeaderView*)hotelSectionHeaderView sectionClosed:(NSInteger)section;
@end
