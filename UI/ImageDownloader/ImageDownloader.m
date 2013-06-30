//
//  ImageDownloader.m
//  Timeline
//
//  Created by simon on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

@synthesize data=_data;
@synthesize indexPath;
@synthesize displayTable,imageCache;

- (id)initWithURLString:(NSString *)url 
{
    
    self = [self init];
    if (self) {
        
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        
        _data = [NSMutableData data];
        
    }
    
    return self;
    
}



// 开始处理-本类的主方法

- (void)start {
    
    if (![self isCancelled]) {
        
        [NSThread sleepForTimeInterval:0];
        // 以异步方式处理事件，并设置代理
        
        _connection=[NSURLConnection connectionWithRequest:_request delegate:self];
        
        while(_connection != nil) {
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];   
            
        }
        
    }
    
}

#pragma mark NSURLConnection delegate Method

// 接收到数据（增量）时

- (void)connection:(NSURLConnection*)connection

    didReceiveData:(NSData*)data 
{
    //不知数据是否缓存在传输层了，网络断了也能收到数据！？
    // 添加数据
    [_data appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    
    _connection=nil;
    
    UIImage *img = [[UIImage alloc] initWithData:self.data];
    
    [self imageDidFinished:img];
    
}

/*成功后更新tableview*/
- (void)imageDidFinished:(UIImage *)image 
{
    //NSLog(@"image=%@",image);
    //NSLog(@"indexpath%@",indexPath);
    if(image!=nil)
    {
        [self.imageCache setObject:image forKey:indexPath];
        aDisplayCell *cell=(aDisplayCell *)[self.displayTable cellForRowAtIndexPath:indexPath];
        cell.aImageView.image=image;
        [cell.aImageView setNeedsDisplay];
    }
    
}

-(void)connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
    _connection=nil; 
}

-(BOOL)isConcurrent 
{
    //返回yes表示支持异步调用，否则为支持同步调用
    return YES;
    
}
- (BOOL)isExecuting
{
    return _connection == nil; 
}
- (BOOL)isFinished
{
    return _connection == nil;  
}


@end
