//
//  DisPlayDataSource.h
//  Timeline
//
//  Created by simon on 12-12-12.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DisPlayDataSource <NSObject>
@optional
@required

/*加载更多*/
- (void)loadMoreData;

/*下拉更新*/
- (void)refreshData;

@end
