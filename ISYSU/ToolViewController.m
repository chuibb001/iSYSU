//
//  ToolViewController.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "ToolViewController.h"

@interface ToolViewController ()

@end

@implementation ToolViewController
@synthesize map,myChooseMapController,schoolBus,mySchoolBusController,schoolCalendar,mySchoolCalendarController,communicate,tableViewController,foodViewController,hotelController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
	// Do any additional setup after loading the view.
    [self initNavigationBar];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(28,25,60,62)];
    //   UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(28,25,160,162)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"communication"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(communicateAction:) forControlEvents:UIControlEventTouchUpInside];
    // UILabel *label1 =
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(127.5,25.5,65,61)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"bus"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(busAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(225.5,25,69,60)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(20.5,140.5,67,62)];
    [button4 setBackgroundImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(foodAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(124.5,137.5,71,67)];
    [button5 setBackgroundImage:[UIImage imageNamed:@"hotel"] forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(hotelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(227,138,68,66)];
    [button6 setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 60, 30)];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 90, 60, 30)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(230, 90, 60, 30)];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(30, 205, 60, 30)];
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(130, 205, 60, 30)];
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(230, 205, 60, 30)];
    [label1 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [label2 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [label3 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [label4 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [label5 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [label6 setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    [label1 setText:@"校务通讯"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label2 setText:@"校区班车"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label3 setText:@"校历"];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label4 setText:@"食在中大"];
    [label4 setTextAlignment:NSTextAlignmentCenter];
    [label5 setText:@"宾馆服务"];
    [label5 setTextAlignment:NSTextAlignmentCenter];
    [label6 setText:@"中大地图"];
    [label6 setTextAlignment:NSTextAlignmentCenter];
    
    
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label4 setBackgroundColor:[UIColor clearColor]];
    [label5 setBackgroundColor:[UIColor clearColor]];
    [label6 setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
    [self.view addSubview:label6];
    [self.view addSubview:label5];
    [self.view addSubview:label4];
    [self.view addSubview:label3];
    [self.view addSubview:label2];
    [self.view addSubview:label1];
    
}

-(void) initNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title=@"校务应用";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationItem.backBarButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.backBarButtonItem setTitle:@"back"];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar"]];
}


- (void)communicateAction:(id)sender
{
	
	if (self.tableViewController == nil)
	{
		CommunicateTableViewController* aTableViewController = [[CommunicateTableViewController alloc] initWithStyle:UITableViewStylePlain];
		//aTableViewController.plays = self.plays;
		self.tableViewController = aTableViewController;
		[self.tableViewController setHidesBottomBarWhenPushed:YES];
    }
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}
-(void)hotelAction:(id)sender
{
    if (self.hotelController == nil)
	{
		HotelTableViewController *aHotelController =
        [[HotelTableViewController alloc] initWithStyle:UITableViewStylePlain];
		//aTableViewController.plays = self.plays;
		self.hotelController = aHotelController;
        [self.hotelController setHidesBottomBarWhenPushed:YES];
		
    }
    [self.navigationController pushViewController:self.hotelController  animated:YES];
    
    
}

- (void)mapAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	if (self.myChooseMapController == nil)
	{
        ChooseMapController *digController = [[ChooseMapController alloc] init];
		self.myChooseMapController = digController;
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
        [self.myChooseMapController setHidesBottomBarWhenPushed:YES];
    }
    [self.navigationController pushViewController:self.myChooseMapController animated:YES];
}

- (void)foodAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	if (self.foodViewController == nil)
	{
        // NSString *viewControllerName = @"foodViewController";
        ChooseFoodController *fooController = [[ChooseFoodController alloc] init];
		self.foodViewController = fooController;
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
        [self.foodViewController setHidesBottomBarWhenPushed:YES];
    }
    [self.navigationController pushViewController:self.foodViewController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)busAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	if (self.mySchoolBusController == nil)
	{
        self.mySchoolBusController = [[SchoolBusController alloc] init];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
        [self.mySchoolBusController setHidesBottomBarWhenPushed:YES];
    }
    [self.navigationController pushViewController:self.mySchoolBusController animated:YES];
}
- (void)calendarAction:(id)sender
{
	//NSString *viewControllerName = @"ChooseMapController";
	//ChooseMapController *targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	//[self.navigationController pushViewController:targetViewController animated:YES];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//self.map.backgroundColor = [UIColor blackColor];
	if (self.mySchoolCalendarController == nil)
	{
        self.mySchoolCalendarController = [[CalendarPageOneController alloc] init];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
        [self.mySchoolCalendarController setHidesBottomBarWhenPushed:YES];
    }
    [self.navigationController pushViewController:self.mySchoolCalendarController animated:YES];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
