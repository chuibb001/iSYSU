    //
//  ChooseMapController.m
//  iSysuMap
//
//  Created by 王 清云 on 11-2-23.
//  Copyright 2011 中山大学. All rights reserved.
//

#import "ChooseMapController.h"
#import "DCGridView.h"

@interface ChooseMapController(private)

- (void)useGridView;
@end

@implementation ChooseMapController
@synthesize myMapController;



-(void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [east setAlpha:0.0];
    [north setAlpha:0.0];
    [south setAlpha:0.0];
    [zhuhai setAlpha:0.0];
    
     self.title = @"地图";
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(34, 30, 100, 100)];
    [image1 setImage:[UIImage imageNamed:@"east.png"]];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(180, 30,100, 100)];
    [image2 setImage:[UIImage imageNamed:@"south.png"]];
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(34, 150, 100, 100)];
    [image3 setImage:[UIImage imageNamed:@"north.png"]];
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(180, 150, 100, 100)];
    [image4 setImage:[UIImage imageNamed:@"zhuhai.png"]];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(34, 80, 100, 100)];
    [button1 setTitle:@"东校区" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(EastAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(180,80,100,100)];


     [button2 setTitle:@"南校区" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(SouthAction:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(34,200,100,100)];
     [button3 setTitle:@"北校区" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(NorthAction:) forControlEvents:UIControlEventTouchUpInside];

[button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(180,200,100,100)];
    [button4 setTitle:@"珠海校区" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(ZhuhaiAction:) forControlEvents:UIControlEventTouchUpInside];
[button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:image1];
    [self.view addSubview:image2];
    [self.view addSubview:image3];
    [self.view addSubview:image4];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    
    [self.view addSubview:button3];
    
    [self.view addSubview:button4];


    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setBackgroundColor:[UIColor clearColor]];
    self.leftButton.frame = CGRectMake(0, 0, 70, 30);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [self.leftButton setTitle:@"校务应用" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [self.leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button99 = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = button99;
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

	//if (self.myMapController == nil)
	{
        
		NSLog (@"string is :%@", @"test");
        NSString *viewControllerName = @"MapController";
		MapController *digController = [[MapController alloc] init];
        self.myMapController = digController;
        
        [digController setMTitle:@"东校区"];
        UIBarButtonItem *but = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
        self.myMapController.navigationItem.leftBarButtonItem = but;
		[digController setHtmlTitle:@"eastMap"];
		//[digController setHtmlTitle:@"digitalSysu"];

		
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];
		
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myMapController animated:YES];
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
        NSString *viewControllerName = @"MapController";
		MapController *digController = [[MapController alloc] init];
		[digController setMTitle:@"南校区"];
		[digController setHtmlTitle:@"southMap"];
		//[digController setHtmlTitle:@"digitalSysu"];

		self.myMapController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];
		
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myMapController animated:YES];
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
        NSString *viewControllerName = @"MapController";
		MapController *digController = [[MapController alloc] init];
		[digController setMTitle:@"北校区"];
		[digController setHtmlTitle:@"northMap"];
		//[digController setHtmlTitle:@"digitalSysu"];

		self.myMapController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];
		
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myMapController animated:YES];
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
        NSString *viewControllerName = @"MapController";
		MapController *digController = [[MapController alloc] init];
		[digController setMTitle:@"珠海校区"];
		[digController setHtmlTitle:@"zhuhaiMap"];
		//[digController setHtmlTitle:@"digitalSysu"];

		self.myMapController = digController;
		[digController release];
        //self.myDigitalSysuController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myChooseMapController release];
		[viewControllerName release];

        //[rowData setValue:targetViewController forKey:kViewControllerKey];
        //[self.myEastMapController release];
    }
    [self.navigationController pushViewController:self.myMapController animated:YES];
}


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





@end
