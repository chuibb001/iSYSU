//
//  WeiboOperation.m
//  ISYSU
//
//  Created by simon on 13-3-30.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "WeiboOperation.h"

@implementation WeiboOperation

- (void)start
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboDidGet" object:nil];
}
@end
