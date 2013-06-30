//
//  HotelTableViewController.m
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "HotelTableViewController.h"
#import "HotelCell.h"
#import "HotelSectionInfo.h"
#import "HotelSectionHeaderView.h"
#import "HotelSquare.h"
#import "HotelItem.h"

@interface HotelTableViewController ()

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, retain) NSIndexPath* pinchedIndexPath;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) NSString *number;
@property (nonatomic, assign) CGFloat initialPinchHeight;
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, assign) NSArray *test;
@end

#define HEADER_HEIGHT 45
#define ROW_HEIGHT 135


@implementation HotelTableViewController

@synthesize plays=plays_, sectionInfoArray=sectionInfoArray_, quoteCell=newsCell_, pinchedIndexPath=pinchedIndexPath_, uniformRowHeight=rowHeight_, openSectionIndex=openSectionIndex_, initialPinchHeight=initialPinchHeight_,test;

- (void)setUpPlaysArray {
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HotelList" ofType:@"plist"];
    
    
	NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *values = [[NSArray alloc] initWithArray:[dic allValues]];
    NSArray *playDictionariesArray = [[NSArray alloc] initWithArray:values];
    
    NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[playDictionariesArray count]];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        HotelSquare *play = [[HotelSquare alloc] init];
        play.name = [playDictionary objectForKey:@"square"];
        
        NSArray *quotationDictionaries = [playDictionary objectForKey:@"hotel"];
        
        NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[quotationDictionaries count]];
        
        for (NSDictionary *quotationDictionary in quotationDictionaries) {
			
            HotelItem *quotation = [[HotelItem alloc] init];
            [quotation setValuesForKeysWithDictionary:quotationDictionary];
            
            [quotations addObject:quotation];
        }
        play.quotations = quotations;
        
        [playsArray addObject:play];
    }
    
    self.plays = playsArray;
    
}


-(BOOL)canBecomeFirstResponder {
    
    return YES;
}



- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (HotelSquare *play in self.plays) {
			HotelSectionInfo *sectionInfo = [[HotelSectionInfo alloc] init];
			sectionInfo.play = play;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:ROW_HEIGHT];
			NSInteger countOfQuotations = [[sectionInfo.play quotations] count];
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}
	
}


- (void)setExtraCellLineHidden{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableHeaderView:view];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpPlaysArray];
    self.title = @"宾馆信息";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    self.test = [[NSArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    [self setExtraCellLineHidden];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    rowHeight_ =ROW_HEIGHT;
    openSectionIndex_ = NSNotFound;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.plays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HotelSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.play quotations] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HotelCell *cell = (HotelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[HotelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //		cell = self.quoteCell;
        //  self.quoteCell = nil;
        
    }
    
    HotelSquare *play = (HotelSquare *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
    NSLog(@"%d",[play.quotations count]);
    cell.quotation = [play.quotations objectAtIndex:indexPath.row];
    // cell.textLabel.text = cell.quotation.numberName;
    return cell;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	HotelSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
		NSString *playName = sectionInfo.play.name;
        sectionInfo.headerView = [[HotelSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:playName section:section delegate:self];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	HotelSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    //return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    return 125;
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
		
		HotelSquare *play = (HotelSquare *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
		HotelItem *quotation = [play.quotations objectAtIndex:indexPath.row];
        
        self.number = [[NSString alloc] initWithString:quotation.numbers];
        [self pushActionsheetwithNumber:quotation.numbers];
        // [self pushActionsheetwithNumber:self.test];
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", quotation.number]]];
        //		NSURL *url = [ [ NSURL alloc ]
        //					  initWithString:[NSString stringWithFormat:@"tel://%@", quotation.number] ];
        //		[[UIApplication sharedApplication ] openURL: url ];
        //		NSLog(@"Call to %@", quotation.number);
	}
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

-(void)sectionHeaderView:(HotelSectionHeaderView*)hotelSectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	HotelSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
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
		
		HotelSectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
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
}


-(void)sectionHeaderView:(HotelSectionHeaderView*)hotelSectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	HotelSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}



@end
