//
//  OrderDisplayViewController.h
//  Timeline
//
//  Created by simon on 12-12-21.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayTableView.h"
#import "aDisplayCell.h"
#import "ImageTextView.h"
#import "ImageDownloader.h"
#import "SVProgressHUD.h"
#import "WeiboDownloader.h"
#import "SinaWeiboData.h"
#import "UIImageView+WebCache.h"
#import "BigImageView.h"
#import "UserListViewController.h"
#import "Toast+UIView.h"
#import "WeiboSettingViewController.h"
#import "WeiboViewController.h"
#import "WeiboLoader.h"
@interface OrderDisplayViewController : UIViewController<DisPlayDataSource,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,BigImageViewDelegate,WeiboLoaderDelegate>


/*微博下载*/
@property (retain, nonatomic) NSMutableArray *idList;
@property (retain, nonatomic) DisplayTableView *tableView;
@property(nonatomic, retain) NSOperationQueue *queue;
@property(nonatomic, strong) WeiboLoader *weiboLoader;

/*要显示的数据*/
@property(nonatomic, retain) NSMutableArray *listData;

/*大图下载*/
@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *bigImageData;
@property(nonatomic, retain) NSMutableDictionary *bigImageCache;
@property(nonatomic, retain) BigImageView *bigImageView;
@property(nonatomic, assign) int currentBigImageIndex;



@end
