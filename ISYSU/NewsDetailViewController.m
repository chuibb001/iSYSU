//
//  NewsDetailViewController.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize articleID;
@synthesize webView;
@synthesize detailGetter;

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initNavigation];
    [self initWebView];
    [self initData];
    [self addGesture];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:1];
}
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    NSLog(@"%f %f",translation.x,translation.y);
    if(translation.x>40 && translation.y<10 &&translation.y>-10)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self cancle];
        
    }
}
-(void)cancle
{
    [SVProgressHUD dismiss];
    [self.detailGetter cancel];
    //[self.webView loadHTMLString:nil baseURL:nil];
}
#pragma mark ISYSUGetterDelegate
//新闻获取失败
- (void) getterFailed:(id)getter{
	self.detailGetter = nil;
	[SVProgressHUD dismissWithError:@"加载失败.."];
}

//新闻获取成功，加载新闻内容
- (void) getterSucceeded:(id)getter withInfo:(NSDictionary *)info{
    [SVProgressHUD dismiss];
	self.detailGetter = nil;
	NSString *title = [info objectForKey:@"title"];
	NSString *subTitle = [info objectForKey:@"subTitle"];
	if(subTitle==nil)
		subTitle = @"";
	NSString *source = [info objectForKey:@"source"];
	NSString *author = [info objectForKey:@"author"];
	if([source isEqualToString:author])
		author = @"";
    
	NSString *dateTime = [info objectForKey:@"dateTime"];
	NSString *content = [info objectForKey:@"content"];
	content = [content stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
	content = [content stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
	content = [content stringByReplacingOccurrencesOfString:@"<div align=center>" withString:@""];
    
    
	NSString *template = [NewsDetailViewController template];
	NSString *htmlString = [NSString stringWithFormat:template,title,subTitle,source,author,dateTime,content];
	NSURL *baseURL = [NSURL URLWithString:@"http://news2.sysu.edu.cn/"];
	[self.webView loadHTMLString:htmlString baseURL:baseURL];
	
	//mark read
	[[[ISYSUNewsData sharedInstance] readNews] addObject:self.articleID];
	[ISYSUNewsData save];
}

+ (NSString*) template{
	static NSString *_template = nil;
	if(_template==nil){
		NSString *path = [[NSBundle mainBundle] pathForResource:@"newsArticle" ofType:@"html"];
		_template = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	}
	return _template;
}
#pragma mark init
-(void)addGesture
{
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    [self.view addGestureRecognizer:pan];
}
-(void)initData
{
    [self.detailGetter cancel];
    self.detailGetter=[NewsDetailGetter getterWithArticleID:self.articleID delegate:self];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view setBackgroundColor:bgColor];
}
-(void)initWebView
{
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:nil baseURL:nil];
}
-(void)initNavigation
{
    self.navigationItem.title=@"新闻内容";
    
    /*左按钮*/
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 70, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"中大新闻" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
    
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
