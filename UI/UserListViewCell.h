//
//  UserListViewCell.h
//  ISYSU
//
//  Created by Cho-Yeung Lam on 25/3/13.
//  Copyright (c) 2013 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *weiboNameLabel; //weibo名字
@property (nonatomic, strong) UILabel *weiboDescriptionLabel; //weibo描述
@property (nonatomic, strong) UIButton *radioButton; //选择按钮

@end
