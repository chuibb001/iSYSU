

#import <Foundation/Foundation.h>
#import "CommunicateSectionHeaderView.h"

@class CommunicateCell;

@interface CommunicateTableViewController : UITableViewController <SectionHeaderViewDelegate> {
}

@property (nonatomic, retain) NSArray* plays;
@property (nonatomic, assign) CommunicateCell *quoteCell;
- (void)setUpPlaysArray;
@end

