//
//  WeiboSettingViewController.h
//  ISYSU
//
//  Created by simon on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboData.h"
#import <QuartzCore/CALayer.h>
#import "UserListViewController.h"

@interface WeiboSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) UITableView *settableView;
@property (nonatomic,retain)NSArray *array;

@end
