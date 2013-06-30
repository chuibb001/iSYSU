#import "SchoolBusController.h"

#import "BusPageOneController.h"

#import "BusCell.h"

#import "Constants.h"	// contains the dictionary keys


@implementation SchoolBusController

@synthesize menuList, myTableView;

static NSArray *pageNames = nil;

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
    
}


- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
	// Make the title of this page the same as the title of this app
	//self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    //self.view.backgroundColor=[UIColor blackColor];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
	self.title = @"校车";
	self.menuList = [NSMutableArray array];
    [self setExtraCellLineHidden:self.myTableView];
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    v.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    //[self.myTableView setTableFooterView:v];
    
    [self.view addSubview:self.myTableView];
	// We will lazily create our view controllers as the user requests them (at a later time),
	// but for now we will encase each title an explanation text into a NSDictionary and add it to a mutable array.
	// This dictionary will be used by our table view data source to populate the text in each cell.
	//
	// When it comes time to create the corresponding view controller we will replace each NSDictionary.
	//
	// If you want to add more pages, simply call "addObject" on "menuList"
	// with an additional NSDictionary.  Note we use NSLocalizedString to load a localized version of its title.
    if (!pageNames)
	{
		pageNames = [[NSArray alloc] initWithObjects:@"BusPageOne", @"BusPageTwo",@"BusPageThree",@"BusPageFour",@"BusPageFive",@"BusPageSix", nil];
    }
	
    for (NSString *pageName in pageNames)
	{
		[self.menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString([pageName stringByAppendingString:@"From"], @""), kFromKey,
								  NSLocalizedString([pageName stringByAppendingString:@"To"], @""), kToKey,
								  NSLocalizedString([pageName stringByAppendingString:@"Title"], @""), kTitleKey,
								  nil]];
	}
	
    [self.myTableView reloadData];
	/*
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
     imageView.image = [UIImage imageNamed:@"justbg.png"];
     [self.myTableView setBackgroundView:imageView];*/
    
	
	
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
	self.myTableView = nil;
	self.menuList = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:NO];
}



#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewIdentifier = @"tableViewIdentifier";
	//如果没有可重用的单元，就从nib中加载一个。
	BusCell *cell = (BusCell *)[tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
	if (cell == nil) {
		//加载nib时，获得一个数组，其中包含nib的所有对象，
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BusCell" owner:self options:nil];
        //迭代nib中所有对象来查找customcell类的实例
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[BusCell class]]) {
				cell=(BusCell *)oneObject;
			}
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
            
            
		}
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
        
	}
    
	//return cell;
	//static NSString *kCellIdentifier = @"cellID";
	
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	//if (!cell)
	//{
    //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
    //BusCell *cell = [[BusCell alloc] initWithNibName:@"BusCell" bundle:nil];
    /*cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     
     cell.textLabel.backgroundColor = [UIColor clearColor];
     cell.textLabel.opaque = NO;
     cell.textLabel.textColor = [UIColor blackColor];
     cell.textLabel.highlightedTextColor = [UIColor whiteColor];
     cell.textLabel.font = [UIFont boldSystemFontOfSize:18];*/
    
    /*cell.detailTextLabel.backgroundColor = [UIColor clearColor];
     cell.detailTextLabel.opaque = NO;
     cell.detailTextLabel.textColor = [UIColor grayColor];
     cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
     cell.detailTextLabel.font = [UIFont systemFontOfSize:14];*/
    //}
    
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *dataDictionary = [menuList objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    //cell.textLabel.text = [dataDictionary valueForKey:kTitleKey];
    //cell.detailTextLabel.text = [dataDictionary valueForKey:kDetailKey];
	cell.fromLabel.text = [dataDictionary valueForKey:kFromKey];
    NSLog(@"%@",cell.fromLabel.text);
	cell.toLabel.text = [dataDictionary valueForKey:kToKey];
    UIView *myview = [[UIView alloc] init];
	//设置UIView对象的外观大小
	myview.frame = CGRectMake(0, 0, 320, 44);
	//设置UIView对象的背景色。 [UIColor colorWithPatternImage：[UIImage imageNamed:@"0006.png"]] 从图片中创建颜色
	
	myview.backgroundColor = [UIColor colorWithRed: (CGFloat)253.0/255.0 green: (CGFloat)249.0/255.0 blue: (CGFloat)220.0/255.0 alpha: 1.0];
	//设置cell被选中时的颜色
	cell.selectedBackgroundView = myview;
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell.png"]];
	return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *rowData = [self.menuList objectAtIndex:indexPath.row];
	BusPageOneController *targetViewController = [rowData objectForKey:kViewControllerKey];
	if (!targetViewController)
	{
        // The view controller has not been created yet, create it and set it to our menuList array
        NSString *viewControllerName = @"BusPageOneController";
        targetViewController = [[BusPageOneController alloc] init];
        [rowData setValue:targetViewController forKey:kViewControllerKey];
		NSDictionary *dataDictionary = [menuList objectAtIndex:indexPath.row];
		NSString *t1=[dataDictionary valueForKey:kTitleKey];
		NSString *t2=[dataDictionary valueForKey:kTitleKey];
		targetViewController.mTitle=t1;
		targetViewController.htmlTitle=t2;
        
        [targetViewController release];
        //[rowData release];
        [viewControllerName release];
		[t1 release];
		[t2 release];
        //[dataDictionary release];
	}
    
    [self.navigationController pushViewController:targetViewController animated:YES];
}



@end

