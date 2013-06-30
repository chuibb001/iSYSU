//
//  UserListViewController.h
//  ISYSU
//
//  Created by simon on 13-3-24.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingLoader.h"

@interface UserListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BookingLoaderDelegate>
{
    Boolean isSuccess;
}
@property (nonatomic, strong) UITableView *userListTableView;
@property (nonatomic, strong) NSMutableArray *userList; //所有热门用户的列表
@property (nonatomic, strong) NSMutableArray *tagList; //选择页面选中用户的记录
@property (nonatomic, strong) NSMutableArray *confirmList; //最终确认名单
@property (nonatomic, strong) BookingLoader *bookingLoader;

@end
