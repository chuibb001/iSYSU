//
//  WeiboListViewController.h
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

//微博评论列表
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "aDisplayCell.h"
#import "BigImageView.h"
#import "AppDelegate.h"
#import "MainViewController.h"
@interface WeiboListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,BigImageViewDelegate>
{
    NSMutableArray *comments;
    
    UIButton *commentBtn;
    UIButton *repostBtn;
    
}

@property (nonatomic, retain) UITableView *commentTableView;
@property (nonatomic, retain) NSString *aID;
@property (nonatomic, retain) NSString *weiboId;
@property (nonatomic, retain) aDisplayCell *headerCell;
@property (nonatomic, retain) NSDictionary *dic;


/*大图下载*/
@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *bigImageData;
@property(nonatomic, retain) BigImageView *bigImageView;


/*工具栏*/
@property(nonatomic, retain) UIImageView *ToolBarBackground;

-(id)initWithComments:(NSMutableArray *)commentsList withID:(NSString *)weiboID;

@end
