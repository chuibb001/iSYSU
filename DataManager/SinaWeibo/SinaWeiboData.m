//
//  SinaWeiboData.m
//  sinaweibo_ios_sdk_demo
//
//  Created by 01 developer on 12-10-18.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SinaWeiboData.h"
@implementation SinaWeiboData

@synthesize sinaweibo,shouldEnd,startTime,endTime;

+(SinaWeiboData *)shared{
    static SinaWeiboData *aSina;
    if (aSina==nil) {
        aSina=[[SinaWeiboData alloc] init];
    }
    return aSina;
}


-(id)init{
    self=[super init];
    if(self)
    {
        userInfo=[[NSMutableDictionary alloc] init];
        user_statuses=[[NSMutableArray alloc] init];
        friends_statuses=[[NSMutableArray alloc] init];
        friends=[[NSMutableArray alloc] init];
        isLast=NO;
        next_count=1;
        isFirstLoadingFriends= YES;
        
        [self initSinaWeibo];
    }
    return self;
}
-(void)initSinaWeibo
{
    //实例化SinaWeibo对象，指定它的delegate
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    //把登陆参数取出
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    } 
}
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)ToLogin
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    [userInfo release], userInfo = nil;
    [user_statuses release], user_statuses = nil;
    
    [sinaweibo logIn];  
}
-(void)ToLogout
{
    [sinaweibo logOut];  
}

-(Boolean)isAuthValid
{
    return sinaweibo.isAuthValid;
}


#pragma mark 微博评论
-(void)getComments:(NSString *) weiboId
{
    NSLog(@"getComments");
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:weiboId forKey:@"id"];
    [params setValue:@"50" forKey:@"count"];
    [sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
    [params release];
    params=nil;
}
-(void)getReposts:(NSString *) weiboId
{
    NSLog(@"getReposts");
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:weiboId forKey:@"id"];
    [params setValue:@"50" forKey:@"count"];
    [sinaweibo requestWithURL:@"statuses/repost_timeline.json" params:params httpMethod:@"GET" delegate:self];
    [params release];
    params=nil;
}

-(void)sendComment:(NSString *)weiboID withComment:(NSString *)content{
    NSLog(@"sendComment");
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:weiboID forKey:@"id"];
    [params setValue:content forKey:@"comment"];
    [sinaweibo requestWithURL:@"comments/create.json" params:params httpMethod:@"POST" delegate:self];
    [params release];
    params=nil;
}
-(void)reSend:(NSString *)weiboID content:(NSString *)con{
    NSLog(@"reSend!");
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    if (![con isEqualToString:@""]) {
        [params setValue:con forKey:@"status"];
    }
    [params setValue:weiboID forKey:@"id"];
    [sinaweibo requestWithURL:@"statuses/repost.json" params:params httpMethod:@"POST" delegate:self];
    [params release];
    params=nil;
}

#pragma mark - 成功调用此方法
//成功调用此方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    /*---------------------------------个人信息--------------------------------*/
    if ([request.url hasSuffix:@"users/show.json"])
    {

        userInfo=result;
        //数据加载完毕，发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_userInfo" object:userInfo];
    }
    /*------------------------------评论列表-------------------------------*/
    else if ([request.url hasSuffix:@"comments/show.json"])
    {
        NSDictionary *dir=result;
        NSString *total_number=[dir objectForKey:@"total_number"];
        NSLog(@"评论总数%@",total_number);
        
        /*init*/
        comments=[[NSMutableArray alloc] init];
        /*返回数据包中的评论数组*/
        NSArray *temp=[dir objectForKey:@"comments"];
        /*加到全局变量comments中*/
        [comments addObjectsFromArray:temp];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_comments" object:comments];
    }
    else if ([request.url hasSuffix:@"statuses/repost_timeline.json"])
    {
        NSDictionary *dir=result;
        NSString *total_number=[dir objectForKey:@"total_number"];
        NSLog(@"转发总数%@",total_number);
        
        /*init*/
        reposts=[[NSMutableArray alloc] init];
        /*返回数据包中的评论数组*/
        NSArray *temp=[dir objectForKey:@"reposts"];
        /*加到全局变量comments中*/
        [reposts addObjectsFromArray:temp];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_reposts" object:reposts];
    }else if ([request.url hasSuffix:@"comments/create.json"]){
        [SVProgressHUD dismissWithSuccess:@"评论微博成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_sendcomment" object:nil];
    }else if([request.url hasSuffix:@"statuses/repost.json"]){
        [SVProgressHUD dismissWithSuccess:@"转发微博成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_reSend" object:nil];
    }
}

#pragma mark - 失败调用此方法 
//失败调用此方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release], userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        if([[request.params objectForKey:@"uid"] isEqual:[self sinaweibo].userID]) //如果该请求是“获取用户状态”
            [user_statuses release], user_statuses = nil;
        else  //如果该请求是“获取好友状态”
            [friends_statuses release], friends_statuses = nil;
        [SVProgressHUD dismissWithError:@"同步微博数据失败"];
    }
    else if([request.url hasSuffix:@"friendships/friends.json"])
    {
        [friends release], friends = nil;
        [SVProgressHUD dismissWithError:@"同步微博关注失败"];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        [SVProgressHUD dismissWithError:@"同步微博失败"];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [SVProgressHUD dismissWithError:@"同步微博失败"];
    }else if([request.url hasSuffix:@"comments/create.json"]){
        [SVProgressHUD dismissWithError:@"发送失败"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_sendcommentFail" object:nil];
    }else if ([request.url hasSuffix:@"statuses/repost.json"]){
        [SVProgressHUD dismissWithError:@"转发失败"];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_reSendFail" object:nil];
    }
}

#pragma mark - SinaWeibo Delegate   
//登陆的委托函数
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"didlogin");
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self storeAuthData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weibologinsuccess" object:nil];
    [SVProgressHUD showSuccessWithStatus:@"登陆微博成功" duration:1.0f];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{

    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weibologoutsuccess" object:nil];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"renrenloginfail" object:nil];
    [SVProgressHUD showErrorWithStatus:@"登陆微博失败" duration:1.0f];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    
}
@end
