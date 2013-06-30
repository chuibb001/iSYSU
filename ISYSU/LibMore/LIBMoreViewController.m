//
//  LIBMoreViewController.m
//  iSYSULibrary
//
//  Created by Lancy on 12/3/13.
//  Copyright (c) 2013 SYSU APPLE CLUB. All rights reserved.
//

#import "LIBMoreViewController.h"
#import "LIBAppItemCell.h"
#import "LIBMoreInfoLoader.h"
#import "LIBWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "CYHelper.h"


@interface LIBMoreViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,LIBMoreInfoLoaderDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSDictionary *appItems;
@property (strong, nonatomic) LIBMoreInfoLoader *moreInfoLoader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LIBMoreViewController

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
    // Do any additional setup after loading the view from its nib.
    [self initUserinterface];
    [self requestAppItems];
}

- (void)initUserinterface
{
    [self setTitle:@"更多"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.tableview setBackgroundColor:bgColor];
    [self.view setBackgroundColor:bgColor];
    
    [self loadLocalAppItems];
}

- (void)loadLocalAppItems
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"localAppItems.plist"];
    //NSLog(@"path%@",path);
    self.appItems = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (void)saveLocalAppItems
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"localAppItems.plist"];
    [self.appItems writeToFile:path atomically:YES];
}

- (void)requestAppItems
{
    if (!self.moreInfoLoader) {
        self.moreInfoLoader = [[LIBMoreInfoLoader alloc] init];
        [self.moreInfoLoader setDelegate:self];
    }
    
    [self.moreInfoLoader requestAppItems];
}

- (void)moreInfoLoader:(LIBMoreInfoLoader *)loader didGetAppItems:(NSDictionary *)appItems
{
    NSInteger currentVersion = [[self.appItems valueForKey:@"version"] integerValue];
    NSInteger getVersion = [[appItems valueForKey:@"version"] integerValue];
    if (currentVersion < getVersion) {
        self.appItems = appItems; 
        [self saveLocalAppItems];
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.appItems.count;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 67;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 23;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headbackground.png"]];
        [background setFrame:CGRectMake(0, 0, 320, 23)];
        [background setBackgroundColor:[UIColor clearColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 280, 15)];
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        [titleLabel setTextColor:[UIColor colorWithRed:(125.0 / 255.0) green:(138.0 / 255.0) blue:(149.0 / 255.0) alpha:1]];
        [titleLabel setShadowColor:[UIColor whiteColor]];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"关于"];
        [background addSubview:titleLabel];
        
        return background;
    } else {
        return nil;
    }
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"AppItemCell";
        
        
        LIBAppItemCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"LIBAppItemCell" owner:nil options:nil];
            cell=nib[0];
            
            UIImage *backgroundImage = [UIImage imageNamed:@"app_cell_background"];
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:backgroundImage]];
            
            cell.iconImageView.layer.borderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1].CGColor;
            cell.iconImageView.layer.masksToBounds= YES;
            cell.iconImageView.layer.cornerRadius= 8.0f;
            cell.iconImageView.layer.borderWidth = 1.0f;
            
            
        }
        
        NSDictionary *appItem = [self.appItems valueForKey:@"apps"][indexPath.row];
        
        NSURL *openUrl = [NSURL URLWithString:[appItem valueForKey:@"openUrl"]];
        
        if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
            [cell.sideButton setTitle:@"打开" forState:UIControlStateNormal];
        } else {
            [cell.sideButton setTitle:@"下载" forState:UIControlStateNormal];
        }

        
        cell.titleLabel.text = [appItem valueForKey:@"title"];
        cell.descriptionLabel.text = [appItem valueForKey:@"description"];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:[appItem valueForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"bookImage.png"]];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            UIImage *backgroundImage = [UIImage imageNamed:@"about_cell_background"];
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:backgroundImage]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"关于iSYSU"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"关于中山大学苹果俱乐部"];
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"反馈意见"];
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"在APP Store评价我们"];
        }
        
        
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *appItem = [self.appItems valueForKey:@"apps"][indexPath.row];
        
        NSURL *openUrl = [NSURL URLWithString:[appItem valueForKey:@"openUrl"]];
        if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
            [[UIApplication sharedApplication] openURL:openUrl];
        } else {
            NSURL *appStoreUrl = [NSURL URLWithString:[appItem valueForKey:@"appStoreUrl"]];
            [[UIApplication sharedApplication] openURL:appStoreUrl];
        }
    } else if (indexPath.section == 1) {
        LIBWebViewController *webView = [[LIBWebViewController alloc] init];
        [webView setHidesBottomBarWhenPushed:YES];

        if (indexPath.row == 0) {
            [webView setUrlString:@"http://www.applesysu.com/scripts/aboutisysu"];
            [webView setTitle:@"关于iSYSU"];
            [self.navigationController pushViewController:webView animated:YES];

        } else if (indexPath.row == 1) {
            [webView setUrlString:@"http://www.applesysu.com/scripts/aboutapplesysu"];
            [webView setTitle:@"关于中山大学苹果俱乐部"];
            [self.navigationController pushViewController:webView animated:YES];
        } else if (indexPath.row == 2) {
            [self sendFeedback];

//            [webView setUrlString:@"http://www.applesysu.com/scripts/feedback.php"];
//            [webView setTitle:@"反馈意见"];
//            [self.navigationController pushViewController:webView animated:YES];
        }
        else if (indexPath.row == 3) {
            NSURL *appStoreUrl;
            
            for (NSDictionary *appItem in [self.appItems valueForKey:@"apps"]) {
                if ([[appItem valueForKey:@"title"] isEqualToString:@"iSYSU"]) {
                    appStoreUrl = [NSURL URLWithString:[appItem valueForKey:@"appStoreUrl"]];
                }
            }
            [[UIApplication sharedApplication] openURL:appStoreUrl];
            
        }

    }
}

#pragma mark - open feedback mail

- (void)sendFeedback
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.navigationBar.backgroundColor = [UIColor blackColor];
    mc.mailComposeDelegate = self;
    [mc setToRecipients:[NSArray arrayWithObjects:@"applesysu2012@gmail.com", nil]];
    [mc setSubject:@"【iSYSU Library反馈意见】"];
    NSString *messageBody = [NSString stringWithFormat:@"Model: %@ \n OS Version: %@ \n App version: %@ \n\n 您的反馈意见：", [CYSystemInfo deviceModel], [CYSystemInfo osVersion], [CYSystemInfo appVersion]];
    [mc setMessageBody:messageBody isHTML:NO];
    
    [self presentModalViewController:mc animated:YES];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}
@end
