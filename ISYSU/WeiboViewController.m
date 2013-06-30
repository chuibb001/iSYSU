//
//  WeiboViewController.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "WeiboViewController.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController

//@synthesize loginButton=_loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initNavigationBar];
    
    [self bindNotification];
    
    [self drawLoginWeiboView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void) initNavigationBar{
    self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title=@"热门微博";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)drawLoginWeiboView{
    
    //if ([[SinaWeiboData shared] isAuthValid]) {
     //   [self toWeiboList];
        
  //  }else{
        [self drawLoginView];

 //   }
}

-(void)drawLoginView{
    
    if(self.view.frame.size.height<=480){
        
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        
        UIImageView *centerView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weibologo.png"]];
        //    [centerView setBounds:CGRectMake(0, 0, 197, 172)];
        //    [centerView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-50)];
        [centerView setFrame:CGRectMake(62, 54, 197, 172)];
        [self.view addSubview:centerView];
        
        //self.view.userInteractionEnabled=YES;
        self.loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        //    self.loginButton.bounds=CGRectMake(0, 0, 300, 44);
        //    self.loginButton.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+70);
        [self.loginButton setFrame:CGRectMake(10, 274, 300, 44)];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"weibosignin.png"] forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginButton];
    }else{
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        
        UIImageView *centerView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weibologo.png"]];
        //    [centerView setBounds:CGRectMake(0, 0, 197, 172)];
        //    [centerView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-50)];
        [centerView setFrame:CGRectMake(62, 80, 197, 172)];
        [self.view addSubview:centerView];
        
        //self.view.userInteractionEnabled=YES;
        self.loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        //    self.loginButton.bounds=CGRectMake(0, 0, 300, 44);
        //    self.loginButton.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+70);
        [self.loginButton setFrame:CGRectMake(10, 317, 300, 44)];
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"weibosignin.png"] forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginButton];
    }

}

-(void)toWeiboList{
    NSLog(@"toWeiboList");
    [self.view removeFromSuperview];
}

-(void)toLogin:(id)sender
{
    NSLog(@"weibologin");
    [[SinaWeiboData shared] ToLogin];
}

-(void)bindNotification{
    //把通知集中在一起，便于管理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginIn) name:@"weibologinsuccess" object:nil];
}

-(void)didLoginIn{
    //[self toWeiboList];
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
