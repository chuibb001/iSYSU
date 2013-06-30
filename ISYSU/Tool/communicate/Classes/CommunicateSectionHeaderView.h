

#import <Foundation/Foundation.h>

@protocol SectionHeaderViewDelegate;


@interface CommunicateSectionHeaderView : UIView {
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, retain) UIButton *squareButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id <SectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end



/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(CommunicateSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(CommunicateSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end

