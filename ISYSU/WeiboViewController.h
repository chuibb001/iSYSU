//
//  WeiboViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboData.h"
#import "OrderDisplayViewController.h"

@interface WeiboViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain)UIButton *loginButton;

@end
