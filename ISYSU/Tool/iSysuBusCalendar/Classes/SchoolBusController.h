#import <UIKit/UIKit.h>

@interface SchoolBusController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
UITableViewDataSource, UIActionSheetDelegate>
{
	UITableView	*myTableView;
	NSMutableArray *menuList;
	
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *menuList;


@end
