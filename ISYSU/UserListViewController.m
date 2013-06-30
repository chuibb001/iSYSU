//
//  UserListViewController.m
//  ISYSU
//
//  Created by simon on 13-3-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "UserListViewController.h"
#import "UserListViewCell.h"
#import "SVProgressHUD.h"


@interface UserListViewController ()

@end

@implementation UserListViewController

@synthesize userListTableView;
@synthesize userList;
@synthesize tagList;
@synthesize confirmList;
@synthesize bookingLoader;

- (void)viewDidLoad
{   NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    isSuccess=NO;
    [self initNavBarButton];
    
    //转菊花开始
    [SVProgressHUD showWithStatus:@"正在获取用户列表"];
    [self initBookingLoader];
}
-(void)viewDidAppear:(BOOL)animated
{   NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    //self.confirmList = (NSMutableAreay*)[[NSUserDefaults standardUserDefaults] objectForKey:@"confirmList"];
}
# pragma mark - init

- (void)initBookingLoader
{
    if(!self.bookingLoader)
    {
        self.bookingLoader = [[BookingLoader alloc] init];
        [self.bookingLoader setDelegate:self];
    }
    [self.bookingLoader requestItems];
}

- (void)initTableView
{
    self.userListTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.userListTableView.backgroundColor = [UIColor clearColor];
    self.userListTableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
    self.userListTableView.tableFooterView = [[UIView alloc] init];
    self.userListTableView.delegate = self;
    self.userListTableView.dataSource = self;
    
    [self.view addSubview:self.userListTableView];
}

//userList & tagList
- (void)initData
{
    //tagList
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    //confirmList
    self.confirmList = [[NSMutableArray alloc] init];
    [self.confirmList addObjectsFromArray:[defaults objectForKey:@"confirmList"]];
    //self.confirmList = [defaults objectForKey:@"confirmList"];
    NSLog(@"test: %@", self.confirmList);
    //    if (self.confirmList == nil)
    //    {
    //        //NSLog(@"1");
    //        for(int i = 0; i < [self.userList count]; i++)
    //        {
    //
    //            [self.confirmList addObject:[self.userList objectAtIndex:i]];
    //        }
    //    }
    
    //    for(int i=0;i<[self.userList count]; i++)
    //    {
    //        if([[self.tagList objectAtIndex:i] boolValue]==YES)
    //        {
    //            [self.confirmList addObject:[[self.userList objectAtIndex:i] objectForKey:@"id"]];
    //        }
    //    }
    
}

- (void)initNavBarButton
{
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    /*
     UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [rightButton setBackgroundColor:[UIColor clearColor]];
     rightButton.frame = CGRectMake(0, 0, 49,30);
     UIImage *backImage=[[UIImage imageNamed:@"navibutton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
     [rightButton setBackgroundImage:backImage forState:UIControlStateNormal];
     [rightButton setTitle:@"确定" forState:UIControlStateNormal];
     rightButton.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:14.0];
     [rightButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
     
     self.navigationItem.rightBarButtonItem = button1;*/
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 49, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
}

-(void)leftButtonClick
{
    //NSLog(@"isSuccess%d",isSuccess);
    if(isSuccess==NO)
    {
        [self.bookingLoader cancleRequest];
        self.bookingLoader=nil;
        [SVProgressHUD dismiss];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];;
    }
    else
    {
        if([self.confirmList count]==0)
        {
            [SVProgressHUD showErrorWithStatus:@"至少订阅一个微博" duration:1.0];
        }
        else
        {
            //NSLog(@"%@", @"Confirm Button Clicked");
            
            //读取两个Array进入NSUserDefault
            if (![self.confirmList isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"confirmList"]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IdListChanged" object:confirmList];
                [[NSUserDefaults standardUserDefaults] setObject:self.confirmList forKey:@"confirmList"];
                NSLog(@"confirmList: %@", confirmList);
            }
            //[[NSUserDefaults standardUserDefaults] setObject:self.tagList forKey:@"tagList"];
            NSLog(@"confirmList: %@", confirmList);
            //NSLog(@"tagList: %@", tagList);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = 0;
    if ([tableView isEqual:self.userListTableView]) {
        result = 1;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int result = 0;
    if ([tableView isEqual:self.userListTableView]) {
        result = [self.userList count];
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserListViewCell *cell = nil;
    
    if ([tableView isEqual:self.userListTableView]) {
        static NSString *cellIdentifier = @"CommonCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UserListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.weiboNameLabel.text = [[userList objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.weiboDescriptionLabel.text = [[userList objectAtIndex:indexPath.row] objectForKey:@"description"];
        //按钮
        cell.radioButton.tag = [indexPath row];
        [cell.radioButton addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //修改button样式
        BOOL isOn = [self.confirmList containsObject:[[userList objectAtIndex:indexPath.row] objectForKey:@"id"]];
        if(isOn==YES)
        {
            [cell.radioButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            //[cell.contentView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:238.0/255.0 blue:243.0/255.0 alpha:0.5]];
        }
        else if(isOn==NO)
        {
            [cell.radioButton setImage:NULL forState:UIControlStateNormal];
            //[cell.contentView setBackgroundColor:[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.8]];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserListViewCell *cell=(UserListViewCell *)[self.userListTableView cellForRowAtIndexPath:indexPath];
    UIButton *button=cell.radioButton;
    
    BOOL didContain = [self.confirmList containsObject:[[userList objectAtIndex:indexPath.row] objectForKey:@"id"]];
    if(didContain == NO)
    {
        /*修改button样式*/
        [button setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        
        /*添加ID到confirmList*/
        [self.confirmList addObject:[[self.userList objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    else if(didContain == YES)
    {
        /*修改button样式*/
        //[button setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [button setImage:NULL forState:UIControlStateNormal];
        
        
        /*删除响应ID*/
        [self.confirmList removeObject:[[self.userList objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    
    //添加动画
    CGFloat scale = 0.001f;
    button.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        CGFloat scale = 1.1f;
        button.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            button.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                button.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
            } completion:nil];
        }];
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - BookingLoader Delegate
- (void)bookingLoader:(BookingLoader *)loader didFailedGetBookingItemsWithError:(BookingLoaderError)error
{
    [SVProgressHUD dismissWithError:@"刷新失败"];
}

- (void)bookingLoader:(BookingLoader *)loader didGetBookingItems:(NSArray *)appItems
{
    [SVProgressHUD dismissWithSuccess:@"成功获取用户列表"];
    self.userList = [[NSMutableArray alloc] init];
    [self.userList addObjectsFromArray:appItems];
    
    
    [self initData];
    [self initTableView];
    
    isSuccess=YES;
    NSLog(@"issu%d",isSuccess);
}



@end
