//
//  WeiboSettingViewController.m
//  ISYSU
//
//  Created by simon on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "WeiboSettingViewController.h"

@interface WeiboSettingViewController ()

@end

@implementation WeiboSettingViewController
@synthesize settableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view setBackgroundColor:bgColor];
    
    self.array = [[NSArray alloc] initWithObjects:@"管理我的订阅",@"退出我的账号",nil];
    // self.settableView se
    
    self.settableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) style:UITableViewStyleGrouped];
    UIView *clearView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    clearView.backgroundColor=[UIColor clearColor];
    self.settableView.backgroundView=clearView;
    [self.settableView setBackgroundColor:[UIColor clearColor]];
    
    //self.settableView.layer.cornerRadius=10.0;
    //self.settableView.layer.masksToBounds=YES;
    //self.settableView.layer.borderColor=[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1].CGColor;
    //self.settableView.layer.borderWidth=1.0;
    self.settableView.delegate = self;
    self.settableView.dataSource = self;
    self.settableView.scrollEnabled=NO;
    
    [self.view addSubview:self.settableView];

    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 70, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"热门微博" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
    

	// Do any additional setup after loading the view.
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"System Bold" size:17.0]];
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.settableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int row=[indexPath row];
    if(row==0)
    {
        UserListViewController *uservc=[[UserListViewController alloc] init];
        [self.navigationController pushViewController:uservc animated:YES];
        
        
    }
    else if(row==1)
    {
        /*清空*/
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"confirmList"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"tagList"];
        
        [[SinaWeiboData shared] ToLogout];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"archive_weibo"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
