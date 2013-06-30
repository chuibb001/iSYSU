

#import "CommunicateTableViewController.h"
#import "CommunicateCell.h"
#import "CommunicateSectionInfo.h"
#import "CommunicateSectionHeaderView.h"

#import "CommunicateSquare.h"
#import "CommunicateItem.h"




#pragma mark -
#pragma mark TableViewController


// Private TableViewController properties and methods.
@interface CommunicateTableViewController ()

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, retain) NSIndexPath* pinchedIndexPath;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) CGFloat initialPinchHeight;
@property (nonatomic, assign) NSString *number;

// Use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously.
@property (nonatomic, assign) NSInteger uniformRowHeight;


@end



#define HEADER_HEIGHT 45
#define ROW_HEIGHT 45

@implementation CommunicateTableViewController

@synthesize plays=plays_, sectionInfoArray=sectionInfoArray_, quoteCell=newsCell_, pinchedIndexPath=pinchedIndexPath_, uniformRowHeight=rowHeight_, openSectionIndex=openSectionIndex_, initialPinchHeight=initialPinchHeight_;

#pragma mark Initialization and configuration

- (void)setUpPlaysArray {
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CommunicateData" ofType:@"plist"];
	NSArray *playDictionariesArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[playDictionariesArray count]];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        CommunicateSquare *play = [[CommunicateSquare alloc] init];
        play.name = [playDictionary objectForKey:@"square"];
        
        NSArray *quotationDictionaries = [playDictionary objectForKey:@"numbers"];
        NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[quotationDictionaries count]];
        
        for (NSDictionary *quotationDictionary in quotationDictionaries) {
			
            CommunicateItem *quotation = [[CommunicateItem alloc] init];
            [quotation setValuesForKeysWithDictionary:quotationDictionary];
            
            [quotations addObject:quotation];
            [quotation release];
        }
        play.quotations = quotations;
        
        [playsArray addObject:play];
        [play release];
    }
    
    self.plays = playsArray;
    [playDictionariesArray release];
}
-(BOOL)canBecomeFirstResponder {
    
    return YES;
}


- (void)setExtraCellLineHidden{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableHeaderView:view];
    
    
}


- (void)viewDidLoad {
	[self setUpPlaysArray];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [self setExtraCellLineHidden];
    
    
	
	/*UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
     [self.tableView addGestureRecognizer:recognizer];
     [recognizer release];*/
    
    // Set up default values.
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
	/*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */
    rowHeight_ =ROW_HEIGHT;
    openSectionIndex_ = NSNotFound;
    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.backgroundColor = [UIColor clearColor];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [bar pushNavigationItem:item animated:YES];
    [self.view addSubview:bar];
    
    self.title=@"校内通讯";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 70, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"校务应用" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}







- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (CommunicateSquare *play in self.plays) {
			
			CommunicateSectionInfo *sectionInfo = [[CommunicateSectionInfo alloc] init];
			sectionInfo.play = play;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:ROW_HEIGHT];
			NSInteger countOfQuotations = [[sectionInfo.play quotations] count];
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
			[sectionInfo release];
		}
		
		self.sectionInfoArray = infoArray;
		[infoArray release];
	}
	
}


- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    // To reduce memory pressure, reset the section info array if the view is unloaded.
	self.sectionInfoArray = nil;
}


#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return [self.plays count];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
	CommunicateSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.play quotations] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CommunicateCellIdentifier = @"Cell";
    
    CommunicateCell *cell = (CommunicateCell*)[tableView dequeueReusableCellWithIdentifier:CommunicateCellIdentifier];
    
    if (!cell) {
        
        cell = [[CommunicateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommunicateCellIdentifier];
        //		cell = self.quoteCell;
        //  self.quoteCell = nil;
        
    }
    
    CommunicateSquare *play = (CommunicateSquare *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
    cell.quotation = [play.quotations objectAtIndex:indexPath.row];
    // cell.textLabel.text = cell.quotation.numberName;
    return cell;
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	CommunicateSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		NSString *playName = sectionInfo.play.name;
        sectionInfo.headerView = [[[CommunicateSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:playName section:section delegate:self] autorelease];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	CommunicateSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

-(void)pushActionsheetwithNumber:(NSString *)number{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:number,nil];
    self.number = [[NSString alloc] initWithString:number];
    [actionSheet showInView:[self view]];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    // NSIndexPath *pressedIndexPath = [self.tableView indexPathForRowAtPoint:[tapRecognizer locationInView:self.tableView]];
	
	if (indexPath && (indexPath.row != NSNotFound) && (indexPath.section != NSNotFound)) {
		
		CommunicateSquare *play = (CommunicateSquare *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
		CommunicateItem *quotation = [play.quotations objectAtIndex:indexPath.row];
        [self pushActionsheetwithNumber:quotation.number];
    }
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", quotation.number]]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSURL *url = [ [ NSURL alloc ]
                      initWithString:[NSString stringWithFormat:@"tel://%@", self.number] ];
        [[UIApplication sharedApplication ] openURL: url ];
        NSLog(@"Call to %@", self.number);
    }
}



#pragma mark Section header delegate

-(void)sectionHeaderView:(CommunicateSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	CommunicateSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		CommunicateSectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
}


-(void)sectionHeaderView:(CommunicateSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	CommunicateSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;
}


#pragma mark Memory management

-(void)dealloc {
    
    [plays_ release];
    [sectionInfoArray_ release];
    [pinchedIndexPath_ release];
    [super dealloc];
    
}

@end
