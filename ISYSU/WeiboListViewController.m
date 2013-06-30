//
//  WeiboListViewController.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "WeiboListViewController.h"
#import "CommentCell.h"
#import "WeiboDetailViewController.h"
#import "SVProgressHUD.h"
#import "SinaWeiboData.h"
#import "UISendViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface WeiboListViewController ()

@end

@implementation WeiboListViewController
@synthesize commentTableView,aID;

-(void)initNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentsDidGet:) name:@"weibo_comments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repostsDidGet:) name:@"weibo_reposts" object:nil];

}
#pragma mark lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
    [self initNav];
    [self initHeaderCell];
    [self initNotifications];
    [self configueToolBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self loadComments];
    [super viewWillAppear:animated];
   
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self recoverTabBar];
}
#pragma mark draw UI
-(void) initData
{
    self.aID=[self.dic objectForKey:@"idstr"];
}
-(void)configueToolBar
{
    double TabBarHeight=50;
    float y;
    if(iPhone5)
        y=548;
    else
        y=460;
    
    self.ToolBarBackground=[[UIImageView alloc] initWithFrame:CGRectMake(0, y-TabBarHeight-44, self.view.frame.size.width, TabBarHeight)];
    //NSLog(@"AFAFWEFW%f",self.view.frame.size.height);
    //TabBarBackground.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar.png"]];
    self.ToolBarBackground.image=[UIImage imageNamed:@"toolbar.png"];
    self.ToolBarBackground.backgroundColor=[UIColor clearColor];
    self.ToolBarBackground.userInteractionEnabled=YES;
    [self.view addSubview:self.ToolBarBackground];
    
    NSArray *titles=[[NSArray alloc] initWithObjects:@"转发",@"评论", nil];
    NSArray *images=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"toolbarrepost.png"],[UIImage imageNamed:@"toolbarcomment.png"], nil];
    
    for(int i=0;i<2;i++)
    {
        
        UIButton *tab=[UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0)
            tab.frame=CGRectMake(55,1 , TabBarHeight, TabBarHeight);
        else
            tab.frame=CGRectMake(190,1 , TabBarHeight, TabBarHeight);
        [tab setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        
        tab.titleLabel.font=[UIFont fontWithName:@"Arial" size:10.0];
        [tab setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8] forState:UIControlStateNormal];
        tab.tag=i;
        [tab addTarget:self action:@selector(TabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tab setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
        [tab setImageEdgeInsets:UIEdgeInsetsMake(0, 22, 10, 0)];
        [tab setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.ToolBarBackground addSubview:tab];
        
        switch (i) {
            case 0:
                [tab setTitleEdgeInsets:UIEdgeInsetsMake(32, 2, 0, 0)];
                break;
            case 1:
                [tab setTitleEdgeInsets:UIEdgeInsetsMake(32, 3, 0, 0)];
                break;
            default:
                break;
        }
    }
    
    //[self setTabBarHidden:YES];

}
-(void)setTabBarHidden:(Boolean)isHidden
{
    AppDelegate *app=[[UIApplication sharedApplication] delegate];
    MainViewController *mainvc=(MainViewController *)app.window.rootViewController;
    mainvc.TabBarBackground.hidden=isHidden;
}

-(void)recoverTabBar
{
    [self.ToolBarBackground removeFromSuperview];
    self.ToolBarBackground=nil;
}
-(void)TabClicked:(UIButton *)sender
{
    int index=sender.tag;
    switch (index) {
        case 0:
            [self reSend];
            break;
        case 1:
            [self sendComment];
            break;
        default:
            break;
    }
}
-(void)initHeaderCell
{
    self.headerCell=[[aDisplayCell alloc] init];
    
    UIFont *font=[UIFont systemFontOfSize:16.0];
    CGSize textSize1,textSize2,imageSize;
    NSString *repostText;
    /*-----------------------------
     头像
     -----------------------------*/
    NSString *headURL=[[self.dic objectForKey:@"user"] objectForKey:@"profile_image_url"];
    [self.headerCell.headImageView setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.headerCell.headImageView.frame=CGRectMake(10, 10, 50, 50);
    
    /*-----------------------------
     名字
     -----------------------------*/
    self.headerCell.nameLabel.text=[[self.dic objectForKey:@"user"] objectForKey:@"screen_name"];
    self.headerCell.nameLabel.frame=CGRectMake(75, 29, 150, 20);
    self.headerCell.nameLabel.font=[UIFont boldSystemFontOfSize:18.0];
    /*-----------------------------
     按钮
     -----------------------------*/
    /*NSString *repost_count=[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"reposts_count"]];
    CGSize repost_size=[repost_count sizeWithFont:[UIFont systemFontOfSize:11.0]];
    cell.repostButton.frame=CGRectMake(cell.commentButton.frame.origin.x-repost_size.width-16, cell.repostButton.frame.origin.y, cell.repostButton.frame.size.width, cell.repostButton.frame.size.height);
    [cell.repostButton setTitle:repost_count forState:UIControlStateNormal];
    [cell.commentButton setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"comments_count"]] forState:UIControlStateNormal];*/
    [self.headerCell.repostButton removeFromSuperview];
    [self.headerCell.commentButton removeFromSuperview];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(10, 70, 300, 1)];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.3;
    [self.headerCell addSubview:line];
    
    /*-----------------------------
     原文本
     -----------------------------*/
    NSString* content=[self.dic objectForKey:@"text"];
    textSize1 = [content sizeWithFont:font constrainedToSize:CGSizeMake(290, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    self.headerCell.textView.text=content;
    self.headerCell.textView.frame=CGRectMake(15, 85, 290, textSize1.height);
    
    /*-----------------------------
     判断是否有原图
     -----------------------------*/
    NSURL *url=[NSURL URLWithString:[self.dic valueForKey:@"bmiddle_pic"]];
    NSURL *rurl;
    if(url==nil)
    {
        /*-----------------------------
         没有原图-->处理转发部分
         -----------------------------*/
        NSDictionary *retweeted=[self.dic objectForKey:@"retweeted_status"];
        /*有转发*/
        if(retweeted != nil)
        {
            UIImage *repostBackgroundImage=[[UIImage imageNamed:@"zhuanfakuang.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
            
            /*转发者*/
            NSString *name=[[retweeted objectForKey:@"user"] objectForKey:@"screen_name"];
            
            content=[retweeted objectForKey:@"text"];
            
            
            /*转发文本*/
            repostText=[NSString stringWithFormat:@"@%@: ",name];
            repostText=[repostText stringByAppendingString:content];
            self.headerCell.repostTextView.text=repostText;
            self.headerCell.repostTextView.backgroundColor=[UIColor clearColor];
            
            textSize2=[repostText sizeWithFont:font constrainedToSize:CGSizeMake(260, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
            
            self.headerCell.repostTextView.frame=CGRectMake(15 , 15   , 260   , textSize2.height);
            
            /*转发图片*/
            rurl=[NSURL URLWithString:[retweeted valueForKey:@"bmiddle_pic"]];
            if(rurl==nil)
            {
                imageSize=CGSizeZero;
                self.headerCell.aImageView.image=nil;
            }
            else
            {

                [self.headerCell.aImageView setImageWithURL:rurl placeholderImage:[UIImage imageNamed:@"picLoading2.png"]];
                
                imageSize=CGSizeMake(200, 200);
            
            }
            
            /*点击事件*/
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
            [self.headerCell.aImageView addGestureRecognizer:singleTap];
            self.headerCell.aImageView.userInteractionEnabled=YES;
            
            /*设置背景色块的frame*/
            self.headerCell.repostBackgroundView.frame=CGRectMake(15, textSize1.height+self.headerCell.textView.frame.origin.y+16, 290, textSize2.height+imageSize.height+45);
            [self.headerCell.repostBackgroundView setImage:repostBackgroundImage];
            
            self.headerCell.aImageView.frame=CGRectMake(30 , self.headerCell.repostBackgroundView.frame.origin.y+textSize2.height+30, imageSize.width, imageSize.height);
            
            /*--------------------
             时间
             --------------------*/
            self.headerCell.timeLabel.frame=CGRectMake(15, self.headerCell.repostBackgroundView.frame.origin.y+self.headerCell.repostBackgroundView.frame.size.height+13, 200, 20);
            NSDate *date=[self fdateFromString:[self.dic objectForKey:@"created_at"]];
            self.headerCell.timeLabel.text=[[date description] substringToIndex:16];
            
        }
        /*没有转发*/
        else
        {
            self.headerCell.repostTextView.text=nil;
            self.headerCell.aImageView.image=nil;
            self.headerCell.repostBackgroundView.image=nil;
            
            /*--------------------
             时间
             --------------------*/
            self.headerCell.timeLabel.frame=CGRectMake(15, self.headerCell.textView.frame.origin.y+textSize1.height+13, 200, 20);
            NSDate *date=[self fdateFromString:[self.dic objectForKey:@"created_at"]];
            self.headerCell.timeLabel.text=[[date description] substringToIndex:16];
        }
        
    }
    else
    {
        /*有原图*/
        [self.headerCell.aImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"picLoading2.png"]];

        imageSize=CGSizeMake(200, 200);
        
        self.headerCell.aImageView.frame=CGRectMake(30, self.headerCell.textView.frame.origin.y+textSize1.height+15, imageSize.width, imageSize.height);
        
        
        /*点击事件*/
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
        [self.headerCell.aImageView addGestureRecognizer:singleTap];
        self.headerCell.aImageView.userInteractionEnabled=YES;
        
        /*没有转发，清空转发的cell*/
        self.headerCell.repostTextView.text=nil;
        self.headerCell.repostBackgroundView.image=nil;
        
        /*--------------------
         时间
         --------------------*/
        self.headerCell.timeLabel.frame=CGRectMake(15, self.headerCell.aImageView.frame.origin.y+imageSize.height+13, 200, 20);
        NSDate *date=[self fdateFromString:[self.dic objectForKey:@"created_at"]];
        self.headerCell.timeLabel.text=[[date description] substringToIndex:16];
    }
    
    

    
    /*转发*/
    repostBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *reposts_count=[NSString stringWithFormat:@"转发:%@",[self.dic objectForKey:@"reposts_count"]];
    CGSize size2=[reposts_count sizeWithFont:[UIFont boldSystemFontOfSize:16.0]];
    repostBtn.frame=CGRectMake(10, self.headerCell.timeLabel.frame.origin.y+40, size2.width, 30);
    [repostBtn setTitleColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    repostBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    
    [repostBtn setTitle:reposts_count forState:UIControlStateNormal];
    // [self.repostButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [repostBtn addTarget:self action:@selector(repostBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerCell addSubview:repostBtn];
    
    /*评论*/
    commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *comments_count=[NSString stringWithFormat:@"评论:%@",[self.dic objectForKey:@"comments_count"]];
    CGSize size=[comments_count sizeWithFont:[UIFont boldSystemFontOfSize:16.0]];
    commentBtn.frame=CGRectMake(15+size2.width, self.headerCell.timeLabel.frame.origin.y+40, size.width, 30);
    [commentBtn setTitleColor:[UIColor colorWithRed:78.0/255.0 green:87.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    commentBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    
    [commentBtn setTitle:comments_count forState:UIControlStateNormal];
    // [self.repostButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerCell addSubview:commentBtn];
    
    
    /*调整高度*/
    
    CGFloat returnHeight=85.0;

    
    /*-----------------------------
     原文本
     -----------------------------*/
    returnHeight=returnHeight+textSize1.height+16.0;
    
    /*-----------------------------
     原图
     -----------------------------*/
    if(url!=nil)
    {
        imageSize=CGSizeMake(200, 200);
        
        returnHeight=returnHeight+imageSize.height+15;
    }
    
    else {
        
        /*-----------------------------
         转发文本（转发状态没有原图）
         -----------------------------*/
        NSDictionary *retweeted=[self.dic objectForKey:@"retweeted_status"];
        if(retweeted != nil)
        {
            
            /*转发文本*/

            returnHeight=returnHeight+textSize2.height+34;
            
            /*-----------------------------
             转图
             -----------------------------*/
            if(rurl!=nil)
            {
                
                imageSize=CGSizeMake(200, 200);
                
                returnHeight=returnHeight+imageSize.height+15;
            }
        }
        
    }
    
    returnHeight=returnHeight+100;
    
    self.headerCell.frame=CGRectMake(0, 0, 320, returnHeight);
    
    UIView *line3=[[UIView alloc] initWithFrame:CGRectMake(10, commentBtn.frame.origin.y+commentBtn.frame.size.height, 300, 1)];
    line3.backgroundColor=[UIColor clearColor];
    line3.alpha=0.3;
    [self.headerCell addSubview:line3];
    
    [self.commentTableView setTableHeaderView:self.headerCell];
    
    
}

-(void)commentBtnClicked:(id)sender
{
    [commentBtn setTitleColor:[UIColor colorWithRed:78.0/255.0 green:87.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [repostBtn setTitleColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self loadComments];
}
-(void)repostBtnClicked:(id)sender
{
    [commentBtn setTitleColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0] forState:UIControlStateNormal];
     [repostBtn setTitleColor:[UIColor colorWithRed:78.0/255.0 green:87.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self loadReposts];
}


#pragma mark TapGesture
-(void)UesrClicked:(UIGestureRecognizer *)sender
{
    NSString *urlString=[self.dic objectForKey:@"original_pic"];
    if(urlString==nil)
        urlString=[[self.dic objectForKey:@"retweeted_status"] objectForKey:@"original_pic"];

    
    self.bigImageView=[[BigImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIApplication sharedApplication] keyWindow].frame.size.height)];
    
    self.bigImageView.delegate=self;
    
    /*先获取缩略图显示*/
    UIImage *image=self.headerCell.aImageView.image;
    if(image==nil)
        image=[UIImage imageNamed:@"picLoading2.png"];
    /*从网上download*/
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bigImageView];
    [self.bigImageView startWithImage:image];
        
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        
    self.connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        //self.connection=[NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection start];
    
}

#pragma mark NSURLConnection Delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"didReceiveResponse");
    if(self.bigImageData==nil)
        self.bigImageData=[[NSMutableData alloc] init];
    
    /*得到下载图片的总字节数*/
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        long total_ = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        
        //NSLog(@"%ld", total_);
        self.bigImageView.total_Bytes=total_;
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData%d",[data length]);
    [self.bigImageData appendData:data];
    self.bigImageView.current_Bytes=[data length];
    [self.bigImageView AddProgress];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connectionDidFinishLoading");
    
    UIImage *bigImage=[UIImage imageWithData:self.bigImageData];

    /*重绘清晰图*/
    [self.bigImageView ResetImage:bigImage];
    self.bigImageData=nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.bigImageView downloadFail];
}

#pragma mark BigImageDelegate
-(void)DidTapToCancle
{
    [self.connection cancel];
    self.connection=nil;
    self.bigImageView=nil;
    self.bigImageData=nil;
}

-(void)loadComments
{
    [SVProgressHUD show];
    [[SinaWeiboData shared] getComments:self.weiboId];
    //[[SinaWeiboData shared] getReposts:self.weiboId];
}

-(void)loadReposts
{
    [SVProgressHUD show];
    [[SinaWeiboData shared] getReposts:self.weiboId];
}
#pragma mark 通知

-(void)commentsDidGet:(NSNotification *)note
{
    [SVProgressHUD dismiss];
    comments=note.object;
    NSLog(@"listdata%d",[comments count]);
    [self.commentTableView reloadData];
    
}

-(void)repostsDidGet:(NSNotification *)note
{
    [SVProgressHUD dismiss];
    comments=note.object;
    NSLog(@"pass%d",[comments count]);
    [self.commentTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)initNav{
    
    self.navigationItem.title=@"微博正文";

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 70, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"热门微博" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
}
-(void)leftButtonClick
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)returnToMaterialKit{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initTableView{
    comments=[[NSMutableArray alloc] init];
    self.commentTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-50)];
    self.commentTableView.dataSource=self;
    self.commentTableView.delegate=self;
    
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    footer.backgroundColor=[UIColor clearColor];
    [self.commentTableView setTableFooterView:footer];
    
    [self.view addSubview:self.commentTableView];
}

#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [comments count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"aaaaa");
    static NSString *identifier=@"comments";
    
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *aDict=[comments objectAtIndex:indexPath.row];
    [cell.avart  setImageWithURL:[NSURL URLWithString:[[aDict objectForKey:@"user"] objectForKey:@"avatar_large"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    /*姓名*/
    NSString *name=[[aDict objectForKey:@"user"] objectForKey:@"screen_name"];
    cell.nameLabel.text=name;
    
    /*评论内容*/
    NSString *content1=[aDict objectForKey:@"text"];
    CGSize textSize1;
    UIFont *font = [UIFont systemFontOfSize:16];
    
    textSize1 = [content1 sizeWithFont:font constrainedToSize:CGSizeMake(230, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    cell.content.text=content1;
    cell.content.frame=CGRectMake(cell.content.frame.origin.x   , cell.content.frame.origin.y, 230, textSize1.height);
    
    /*时间*/
    NSString *dateString=[aDict objectForKey:@"created_at"];
    NSDate *date=[self fdateFromString:dateString];

    cell.date.text=[[date description] substringWithRange:NSMakeRange(5,11)];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat returnHeight=0.0;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:16];
    // 該行要顯示的內容
    NSString *content1;  //原文文本
    CGSize textSize1;
    NSDictionary *aDict=[comments objectAtIndex:indexPath.row];
    content1 = [aDict objectForKey:@"text"];
    textSize1 = [content1 sizeWithFont:font constrainedToSize:CGSizeMake(230, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    returnHeight=textSize1.height+10;

    returnHeight += 35;
    return returnHeight;
}

#pragma mark - deal with date
- (NSDate *)fdateFromString:(NSString *)string {
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
    NSDate* date = [formater dateFromString:string];
    /*调整8小时时差*/
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
    
    
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self aciontList];
}

#pragma mark - Action sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 //   NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self sendComment];
            break;
        case 1:
            [self reSend];
            break;
        default:
            break;
    }
}

#pragma mark - my method
-(void)sendComment{
    WeiboDetailViewController *aCommentViewController=[[WeiboDetailViewController alloc] initWithID:self.aID];
   // [self.navigationController pushViewController:aCommentViewController animated:YES];
    
    UINavigationController *aNav=[[UINavigationController alloc] initWithRootViewController:aCommentViewController];
    [self presentModalViewController:aNav animated:YES];
}
-(void)reSend{
    UISendViewController *aSendViewController=[[UISendViewController alloc] initWithID:self.aID];
    UINavigationController *aNav=[[UINavigationController alloc] initWithRootViewController:aSendViewController ];
    [self presentModalViewController:aNav animated:YES];
}

-(void)aciontList{
    UIActionSheet *aSheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"评论",@"转发",nil];
    
    [aSheet showInView:[UIApplication sharedApplication].keyWindow];
}


//-(void)didReSendSuccess{
//    
//}
//
//-(void)didReSendFail{
//    
//}
@end
