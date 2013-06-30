//
//  NewsViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISYSUProtocols.h"
#import "NewsListGetter.h"
#import "DisplayTableView.h"
#import "DisplayCell.h"
#import "NewsDetailViewController.h"
#import "Toast+UIView.h"

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DisPlayDataSource,ISYSUGetterDelegate>
{
    NSString *firstId;
}

@property (nonatomic,retain) DisplayTableView *articleTableView;
@property (nonatomic,retain) NSMutableArray *articles;
@property (nonatomic,readwrite) int page;
@property (nonatomic,readwrite) Boolean first;

@property (nonatomic,retain) UIImageView *TableHeader;
@property (nonatomic,retain) NewsListGetter *newsGetter;
@property (nonatomic,retain) NSMutableArray *readList;

@end
