//
//  ImageDownloader.h
//  Timeline
//
//  Created by simon on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayTableView.h"
#import "aDisplayCell.h"


@interface ImageDownloader : NSOperation 
{
    NSURLRequest* _request;
    
    NSURLConnection* _connection;
    
    NSMutableData* _data;
    
    BOOL _isFinished; 
    
    NSIndexPath *_indexPath;
}

- (id)initWithURLString:(NSString *)url;

@property (readonly) NSData *data;

@property(nonatomic, retain) NSIndexPath *indexPath;

/*在线程内reloadTableView*/
@property(atomic, retain) DisplayTableView *displayTable;
@property(atomic, retain) NSMutableDictionary *imageCache;

@end
