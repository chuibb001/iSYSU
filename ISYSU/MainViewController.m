//
//  MainViewController.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tabs;
@synthesize currentIndex;

#pragma mark LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*[self HideRealTabBar];
    [self CustomTabBar];*/
    
    [self configureTabBar];
}






-(void)configureTabBar
{
    NSArray *titles=[[NSArray alloc] initWithObjects:@"新闻",@"微博",@"工具",@"更多", nil];
    self.image_selected=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"news_selected.png"],[UIImage imageNamed:@"weibo_selected.png"],[UIImage imageNamed:@"tool_selected.png"],[UIImage imageNamed:@"more_selected.png"], nil];
    self.image_unselected=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"news_unselected.png"],[UIImage imageNamed:@"weibo_unselected.png"],[UIImage imageNamed:@"tool_unselected.png"],[UIImage imageNamed:@"more_unselected.png"], nil];
    
    for(int i=0;i<4;i++)
    {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[titles objectAtIndex:i]  image:[self.image_selected objectAtIndex:i]  tag:i];
        [item setFinishedSelectedImage:[self.image_selected objectAtIndex:i] withFinishedUnselectedImage:[self.image_unselected objectAtIndex:i]];
        [self setTabBarItem:item];
    }
}





-(void)CustomTabBar
{
    /*背景*/
    double TabBarHeight=50;
    self.TabBarBackground=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-TabBarHeight, self.view.frame.size.width, TabBarHeight)];
    //self.TabBarBackground.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar.png"]];
    self.TabBarBackground.image=[UIImage imageNamed:@"tabbar.png"];
    self.TabBarBackground.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.TabBarBackground];
    self.view.userInteractionEnabled=YES;
    self.TabBarBackground.userInteractionEnabled=YES;
    
    /*滚动背景*/
    self.slideBg=[[UIImageView alloc] initWithFrame:CGRectMake(self.TabBarBackground.frame.origin.x+15, 1, 49, 49)];
    [self.slideBg setImage:[UIImage imageNamed:@"tabbar_selected.png"]];
    self.slideBg.userInteractionEnabled=YES;
    [self.TabBarBackground addSubview:self.slideBg];
    
    /*选项卡*/
    self.tabs=[NSMutableArray arrayWithCapacity:4];
    double width=self.view.frame.size.width/4;
    
    NSArray *titles=[[NSArray alloc] initWithObjects:@"新闻",@"微博",@"工具",@"更多", nil];
    self.image_selected=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"news_selected.png"],[UIImage imageNamed:@"weibo_selected.png"],[UIImage imageNamed:@"tool_selected.png"],[UIImage imageNamed:@"more_selected.png"], nil];
    self.image_unselected=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"news_unselected.png"],[UIImage imageNamed:@"weibo_unselected.png"],[UIImage imageNamed:@"tool_unselected.png"],[UIImage imageNamed:@"more_unselected.png"], nil];
    
    for(int i=0;i<4;i++)
    {
        
        UIButton *tab=[UIButton buttonWithType:UIButtonTypeCustom];
        tab.frame=CGRectMake(i*(width+1),0 , width, TabBarHeight);
        [tab setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        tab.userInteractionEnabled=YES;
        tab.titleLabel.font=[UIFont fontWithName:@"Arial" size:10.0];
        [tab setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8] forState:UIControlStateNormal];
        tab.tag=i;
        [tab addTarget:self action:@selector(TabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tab setImage:[self.image_unselected objectAtIndex:i] forState:UIControlStateNormal];
        [tab setImage:[self.image_selected objectAtIndex:i] forState:UIControlStateHighlighted];
        [tab setImageEdgeInsets:UIEdgeInsetsMake(0, 22, 10, 0)];
        [self.TabBarBackground addSubview:tab];
        [self.tabs addObject:tab];
        
        switch (i) {
            case 0:
                [tab setTitleEdgeInsets:UIEdgeInsetsMake(32, -14.5, 0, 0)];
                break;
            case 1:
                [tab setTitleEdgeInsets:UIEdgeInsetsMake(32, -25, 0, 0)];
                break;
            case 2:
                [tab setTitleEdgeInsets:UIEdgeInsetsMake(32, -20, 0, 0)];
                break;
            case 3:
                [tab setTitleEdgeInsets:UIEdgeInsetsMake(32, -25, 0, 0)];
                break;
            default:
                break;
        }
    }
    /*默认选择0*/
    [self TabClicked:[self.tabs objectAtIndex:0]];
    
    UIButton *defaultBtn=[self.tabs objectAtIndex:0];
    self.slideBg.frame=CGRectMake(defaultBtn.frame.origin.x+5, defaultBtn.frame.origin.y, defaultBtn.frame.size.width-10, defaultBtn.frame.size.height);
    
}
-(void)TabClicked:(UIButton *)sender
{
    self.currentIndex=sender.tag;
    self.selectedIndex=currentIndex;  //设置selectedIndex即可完成切换
    
    UIButton *button=[self.tabs objectAtIndex:self.currentIndex];
    [self performSelector:@selector(slideTabBg:) withObject:button];
    
    
}

- (void)slideTabBg:(UIButton *)btn{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.20];
    [UIView setAnimationDelegate:self];
    self.slideBg.frame = CGRectMake(btn.frame.origin.x+5, btn.frame.origin.y, self.slideBg.frame.size.width, self.slideBg.frame.size.height);
    [UIView commitAnimations];
    
    /*改变按钮图片颜色*/
    [[self.tabs objectAtIndex:self.currentIndex] setImage:[self.image_selected objectAtIndex:self.currentIndex] forState:UIControlStateNormal];
    for(int i=0;i<4;i++)
    {
        if (i!=self.currentIndex) {
            [[self.tabs objectAtIndex:i] setImage:[self.image_unselected objectAtIndex:i] forState:UIControlStateNormal];
        }
    }
}

-(void)HideRealTabBar
{
    self.tabBar.hidden=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
