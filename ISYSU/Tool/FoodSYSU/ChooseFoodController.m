    //
//  ChooseMapController.m
//  iSysuMap
//
//  Created by 王 清云 on 11-2-23.
//  Copyright 2011 中山大学. All rights reserved.
//

#import "ChooseFoodController.h"
#import "DCGridView.h"

@interface ChooseFoodController(private)

- (void)useGridView;

@end

@implementation ChooseFoodController
@synthesize east,south,myFoodController,north,zhuhai;
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.title = @"食在中大";
	//self.east.alpha=1.0;
   }
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)EastAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	//if (self.myMapController == nil)
	self.east.alpha=0.7;
	//if (self.myMapController == nil)
	{
		NSLog (@"string is :%@", @"test");
        NSString *viewControllerName = @"FoodController";
		FoodController *digController = [[FoodController alloc] init];		[digController setMTitle:@"食在中东"];
		[digController setHtmlTitle:@"食在中东"];
		//[digController setHtmlTitle:@"digitalSysu"];

		self.myFoodController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];
		
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myFoodController animated:YES];

}
- (void)SouthAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	//if (self.myMapController == nil)

	//if (self.myMapController == nil)
	{
		NSLog (@"string is :%@", @"test");
        NSString *viewControllerName = @"FoodController";
		FoodController *digController = [[FoodController alloc] init];
		[digController setMTitle:@"食在南校"];
		[digController setHtmlTitle:@"食在南校"];
		//[digController setHtmlTitle:@"digitalSysu"];

		self.myFoodController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];
		
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myFoodController animated:YES];
}
- (void)NorthAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	//if (self.myMapController == nil)

	//if (self.myMapController == nil)
	{
		NSLog (@"string is :%@", @"test");
        NSString *viewControllerName = @"FoodController";
		FoodController *digController = [[FoodController alloc] init];
		[digController setMTitle:@"食在北校"];
		[digController setHtmlTitle:@"食在北校"];
		//[digController setHtmlTitle:@"digitalSysu"];

		self.myFoodController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];
		
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myFoodController animated:YES];
}
- (void)ZhuhaiAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];

	//if (self.myMapController == nil)
	{
		NSLog (@"string is :%@", @"test");
        NSString *viewControllerName = @"FoodController";
		FoodController *digController = [[FoodController alloc] init];
		[digController setMTitle:@"食在珠海"];
		[digController setHtmlTitle:@"食在珠海"];
		//[digController setHtmlTitle:@"digitalSysu"];
        
		self.myFoodController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];

        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myFoodController animated:YES];
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
//        return nil;
//	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"picSYSU_bg.png"]];
//
//    self.title = @"食在中大";
//	
//	return self;
//}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PhotoSYSU_bg.png"]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
	NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"PhotoSYSU_bg" ofType:@"png"];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgPath];
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:img];
	[img release];
	CGRect frame = CGRectMake(0, -65, 320, 480);
	backgroundImageView.frame = frame;
	
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	[self useGridView];
	//self.east.alpha=1;
	/*self.east.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"east.png"]];
	self.south.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"south.png"]];
	self.north.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"north.png"]];
	self.zhuhai.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhuhai.png"]];*/
	
	/*[self.east setImage:[UIImage imageNamed:@"east.png"] forState:UIControlStateNormal];
	[self.south setImage:[UIImage imageNamed:@"south.png"] forState:UIControlStateNormal];
	[self.north setImage:[UIImage imageNamed:@"north.png"] forState:UIControlStateNormal];
	[self.zhuhai setImage:[UIImage imageNamed:@"zhuhai.png"] forState:UIControlStateNormal];*/
//    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    bar.backgroundColor = [UIColor clearColor];
//    
//    [bar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
//    //导航item
//    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
//    [bar pushNavigationItem:item animated:YES];
//    [self.view addSubview:bar];
//    
//    self.title=@"食在中大";
//    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setBackgroundColor:[UIColor clearColor]];
//    leftButton.frame = CGRectMake(0, 0, 70, 30);
//    
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
//    [leftButton setTitle:@"校务应用" forState:UIControlStateNormal];
//    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
//    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
//    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = button2;
}



- (void)useGridView {
	DCGridView *_gridView = [[DCGridView alloc] init];
	CGFloat width = 190/2, height = 190/2;
	
	[_gridView setNumOfGrids:4];
	[_gridView setNumOfRow:2 andNumOfCol:2];
	[_gridView setOriginalX:30 andY:20];
	[_gridView setGridWidth:width andHeight:height];
	[_gridView setRowSpace:40 andColSpace:60];
	
	_gridView.frame = self.view.frame;
	_gridView.backgroundColor = [UIColor clearColor];
	_gridView.delegate = self;
	
	NSMutableArray *images = [NSMutableArray arrayWithCapacity:12];
	for (int i = 0; i < 4; i++) {
		NSString *imgPath;
		if (i == 0) {
			imgPath = [[NSBundle mainBundle] pathForResource:@"eastFood" ofType:@"png"];
		} else if (i == 1) {
			imgPath = [[NSBundle mainBundle] pathForResource:@"southFood" ofType:@"png"];
		} else if (i == 2) {
			imgPath = [[NSBundle mainBundle] pathForResource:@"northFood" ofType:@"png"];
		} else {
			imgPath = [[NSBundle mainBundle] pathForResource:@"zhuhaiFood" ofType:@"png"];
		}
		
		
		//NSString *imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"AlbumCover%d", i+1] ofType:@"png"];
		//NSString *imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"AlbumCover%d", i+1] ofType:@"png"];
		UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
		[images addObject:img];
	}
	[_gridView setImages:images forControlState:UIControlStateNormal];
	_gridView.titles = [NSArray arrayWithObjects:@"食在中东", @"食在南校", @"食在北校", @"食在珠海", nil];
	_gridView.shouldUseTitle = YES;
	_gridView.adjustsImageWhenHighlighted = NO;
	[self.view addSubview:_gridView];
	
	[_gridView showGrids];
}

- (void)DCGridView:(DCGridView *)gridView didChooseIndex:(NSInteger)index {
	if (index == 0) {
		[self EastAction:nil];
	} else if (index == 1) {
		[self SouthAction:nil];
	} else if (index == 2) {
		[self NorthAction:nil];
	} else {
		[self ZhuhaiAction:nil];
	}
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[east release];
	[south release];
	[north release];
	[zhuhai release];
	[myFoodController release];
    [super dealloc];
}


@end
