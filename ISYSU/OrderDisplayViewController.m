//
//  OrderDisplayViewController.m
//  Timeline
//
//  Created by simon on 12-12-21.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "OrderDisplayViewController.h"
#import "WeiboListViewController.h"
@interface OrderDisplayViewController ()<UITableViewDataSource,UITableViewDelegate,DisPlayDataSource,UIAlertViewDelegate>
{
    int page;
    
    /*TableView的数据*/
    CGSize textSize1;  //原文
    CGSize textSize2;  //转发
    CGSize imageSize;  //原图或转发图
    NSMutableDictionary *imageCache; //缩略图缓存
    
    /*Toast*/
    NSString *firstId;
    
    Boolean isRefresh;
    
        WeiboViewController *weibovc;
}

@end

@implementation OrderDisplayViewController
@synthesize tableView,queue;

#pragma mark lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    
     [self initNotification];
     [self initNavigationBar];
     [self initTableView];
     [self initData];
    
    if([[SinaWeiboData shared] isAuthValid])
    {   NSLog(@"valid");
       [self loadData];
    }
    else
    {
         NSLog(@"unvalid");
        [self openLoginView];
    }
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 初始化
-(void)openLoginView
{
    weibovc=[[WeiboViewController alloc] init];
    weibovc.view.frame=CGRectMake(0, 0, 320, weibovc.view.frame.size.height);
    [self.view addSubview:weibovc.view];
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
    //[self.navigationController pushViewController:weibovc animated:YES];
}
-(void)initData
{
    //NSLog(@"type=%@,userId=%@",type,userId);
    self.listData=[[NSMutableArray alloc] init];
    
    self.queue = [[NSOperationQueue alloc] init];
    imageCache=[[NSMutableDictionary alloc] init];
    
    [self.queue setMaxConcurrentOperationCount:5];
}

-(void)loadData
{
    self.navigationItem.rightBarButtonItem.customView.hidden=NO;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.idList=[defaults objectForKey:@"confirmList"];
    if(self.idList==nil)
    {
        self.idList=[[NSMutableArray alloc] init];
        NSArray *temp=[[NSArray alloc] initWithObjects:@"2351180763",@"1994626454",@"1768001547",@"2649316154",@"2651810492",@"2169359560",@"2925564812",@"1899452321",@"1892723783",@"1797174742", nil];
       for(NSString *s in temp)
       {
           [self.idList addObject:s];
       }
           
       [[NSUserDefaults standardUserDefaults] setObject:self.idList forKey:@"confirmList"];
    //self.idList=[[NSArray alloc] initWithObjects:@"1994626454",nil];
    }
    page=1;
    
    
    /*第一次加载数据*/
    //[self enableRefresh:NO];
    [self loadBufferContent];  //先读缓存缓存
    NSLog(@"缓存有%d",[self.listData count]);
    if([self.listData count]==0   )  //没有缓存|点击第二个tab
    { 
        [self.tableView refresh];
    }
}

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IdListChanged:) name:@"IdListChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginIn:) name:@"weibologinsuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginOut:) name:@"weibologoutsuccess" object:nil];
    
}

#pragma mark 通知函数
-(void)IdListChanged:(NSNotification *)note
{
    [self.listData removeAllObjects];
    [self.tableView reloadData];
    
    [self.queue cancelAllOperations];
    [imageCache removeAllObjects];
    firstId=nil;
    
    self.idList=note.object;
    page=1;

    [self.tableView Stop];
    [self.tableView refresh];
}
-(void)didLoginIn:(NSNotification *)note
{
    [weibovc.view removeFromSuperview];
    weibovc=nil;
    [self loadData];
}
-(void)didLoginOut:(NSNotification *) note
{
    /*删除归档文件*/
    NSString *filename=[self dataFilePath];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:filename])
        [defaultManager removeItemAtPath:filename error:nil];
    //NSLog(@"aaaaa%d",success);
    [self.listData removeAllObjects];
    [imageCache removeAllObjects];
    [self.tableView reloadData];
    [self openLoginView];
}

-(int)numberOfRefresh
{
    int i=0;
    NSDate *firstDate=[self fdateFromString:firstId];
    for(NSDictionary *dic in self.listData)
    {
        NSString *dateStr=[dic objectForKey:@"created_at"];
        NSDate *date=[self fdateFromString:dateStr];
        NSComparisonResult result=[date compare:firstDate];
        if(result == NSOrderedDescending)
            i++;
        else
            break;
    }
    return i;
}



#pragma mark UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    WeiboListViewController *commentsVC=[[WeiboListViewController alloc] init];
    commentsVC.weiboId=[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"idstr"];
    commentsVC.dic=[self.listData objectAtIndex:[indexPath row]];
    [commentsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:commentsVC animated:YES];
}

#pragma mark UITableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"aDisplayCell";
    //NSLog(@"cell %d",[indexPath row]);
    
    aDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[aDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:CellIdentifier];
    }

    NSString *content;  // 文本内容
    UIFont *font = [UIFont systemFontOfSize:16];
        
    /*
        储存weiboID给Cell
         
    */
        
    [cell storeWeiboID:[[self.listData objectAtIndex:indexPath.row] objectForKey:@"mid"]];
    
    NSDictionary *dic=[self.listData objectAtIndex:indexPath.row];
    
    /*-----------------------------
                头像
     -----------------------------*/
    NSString *headURL=[[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"user"] objectForKey:@"profile_image_url"];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    /*-----------------------------
                名字
     -----------------------------*/
    cell.nameLabel.text=[[dic objectForKey:@"user"] objectForKey:@"screen_name"];
    
    /*-----------------------------
                按钮
     -----------------------------*/
    NSString *repost_count=[NSString stringWithFormat:@"%@",[dic objectForKey:@"reposts_count"]];
    CGSize repost_size=[repost_count sizeWithFont:[UIFont systemFontOfSize:11.0]];
    cell.repostButton.frame=CGRectMake(cell.commentButton.frame.origin.x-repost_size.width-16, cell.repostButton.frame.origin.y, cell.repostButton.frame.size.width, cell.repostButton.frame.size.height);
    [cell.repostButton setTitle:repost_count forState:UIControlStateNormal];
    [cell.commentButton setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"comments_count"]] forState:UIControlStateNormal];
    
    /*-----------------------------
                原文本
    -----------------------------*/
    content=[dic objectForKey:@"text"];
    textSize1 = [content sizeWithFont:font constrainedToSize:CGSizeMake(260, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    cell.textView.text=content;
    cell.textView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.y, cell.textView.frame.size.width, textSize1.height);

    /*-----------------------------
            判断是否有原图
    -----------------------------*/
    NSURL *url=[NSURL URLWithString:[dic valueForKey:@"thumbnail_pic"]];
    if(url==nil)
    {
        /*-----------------------------
             没有原图-->处理转发部分
        -----------------------------*/
        NSDictionary *retweeted=[dic objectForKey:@"retweeted_status"];
        /*有转发*/
        if(retweeted != nil)
        {
            UIImage *repostBackgroundImage=[[UIImage imageNamed:@"zhuanfakuang.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
                
            /*转发者*/
            NSString *name=[[retweeted objectForKey:@"user"] objectForKey:@"screen_name"];
                
            content=[retweeted objectForKey:@"text"];
            
                
            /*转发文本*/
            NSString *repostText=[NSString stringWithFormat:@"@%@: ",name];
            repostText=[repostText stringByAppendingString:content];
            cell.repostTextView.text=repostText;
            cell.repostTextView.backgroundColor=[UIColor clearColor];
            
            textSize2=[repostText sizeWithFont:font constrainedToSize:CGSizeMake(240, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
            
            cell.repostTextView.frame=CGRectMake(cell.repostTextView.frame.origin.x , cell.repostTextView.frame.origin.y   , cell.repostTextView.frame.size.width   , textSize2.height);

            /*转发图片*/
            url=[NSURL URLWithString:[retweeted valueForKey:@"thumbnail_pic"]];
            if(url==nil)
            {
                imageSize=CGSizeZero;
                cell.aImageView.image=nil;
                cell.aImageView.userInteractionEnabled=NO;
            }
            else
            {
                UIImage *image=[imageCache objectForKey:indexPath];
                //NSLog(@"转发图=%@",image);
                if(image==nil) /*缓存没有，异步加载*/
                {
                    //NSLog(@"没有缓存 %d",[indexPath row]);
                    cell.aImageView.image=[UIImage imageNamed:@"picLoading2.png"];
                    ImageDownloader *downloader = [[ImageDownloader alloc] initWithURLString:[retweeted valueForKey:@"thumbnail_pic"]];
                    downloader.indexPath = indexPath;
                    downloader.displayTable=self.tableView;
                    downloader.imageCache=imageCache;
                    [self.queue addOperation:downloader];
                        
                    imageSize=CGSizeMake(100, 100);
                        
                }
                else { /*从缓存取*/
                    imageSize=CGSizeMake(100, 100);
                    cell.aImageView.image =image;
                }
                
                /*点击事件*/
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
                [cell.aImageView addGestureRecognizer:singleTap];
                cell.aImageView.userInteractionEnabled=YES;
                cell.aImageView.tag=[indexPath row];
            }
            /*设置背景色块的frame*/
            cell.repostBackgroundView.frame=CGRectMake(cell.repostBackgroundView.frame.origin.x, textSize1.height+cell.textView.frame.origin.y+8, cell.repostBackgroundView.frame.size.width, textSize2.height+imageSize.height+24);
            [cell.repostBackgroundView setImage:repostBackgroundImage];
            
            cell.aImageView.frame=CGRectMake(62 , cell.repostBackgroundView.frame.origin.y+textSize2.height+16, imageSize.width, imageSize.height);
            
            /*--------------------
                     时间
             --------------------*/
            cell.timeLabel.frame=CGRectMake(52, cell.repostBackgroundView.frame.origin.y+cell.repostBackgroundView.frame.size.height+13, 200, 20);
            NSDate *date=[self fdateFromString:[dic objectForKey:@"created_at"]];
            cell.timeLabel.text=[[date description] substringToIndex:16];
                
            }
        /*没有转发*/
        else
        {
            cell.repostTextView.text=nil;
            cell.aImageView.image=nil;
            cell.repostBackgroundView.image=nil;
            cell.aImageView.userInteractionEnabled=NO;
            
            /*--------------------
                     时间
             --------------------*/
            cell.timeLabel.frame=CGRectMake(52, cell.textView.frame.origin.y+textSize1.height+13, 200, 20);
            NSDate *date=[self fdateFromString:[dic objectForKey:@"created_at"]];
            cell.timeLabel.text=[[date description] substringToIndex:16];
        }
            
    }
    else
    {
        /*有原图*/
        UIImage *image=[imageCache objectForKey:indexPath];
        //NSLog(@"原图=%@",image);
        if(image==nil)  /*缓存没有，异步加载*/
        {
            cell.aImageView.image=[UIImage imageNamed:@"picLoading2.png"];
            ImageDownloader *downloader = [[ImageDownloader alloc] initWithURLString:[dic valueForKey:@"thumbnail_pic"]];
            downloader.indexPath = indexPath;
            downloader.displayTable=self.tableView;
            downloader.imageCache=imageCache;
            [self.queue addOperation:downloader];
                
            imageSize=CGSizeMake(100, 100);
        }
        else
        {   /*从缓存取*/
            imageSize=CGSizeMake(100, 100);
            cell.aImageView.image=image;
        }
        cell.aImageView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.y+textSize1.height+8, imageSize.width, imageSize.height);
        
        /*点击事件*/
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
        [cell.aImageView addGestureRecognizer:singleTap];
        cell.aImageView.userInteractionEnabled=YES;
        cell.aImageView.tag=[indexPath row];
            
        /*没有转发，清空转发的cell*/
        cell.repostTextView.text=nil;
        cell.repostBackgroundView.image=nil;
        
        /*--------------------
                 时间
         --------------------*/
        cell.timeLabel.frame=CGRectMake(52, cell.aImageView.frame.origin.y+imageSize.height+13, 200, 20);
        NSDate *date=[self fdateFromString:[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"created_at"]];
        cell.timeLabel.text=[[date description] substringToIndex:16];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    return cell;
}

/*-----------------------------
 高度
 -----------------------------*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"heightForRow %d",[indexPath row]);
    CGFloat returnHeight=35.0;
    //NSLog(@"heightForRowAtIndexPath%d",[indexPath row]);
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:16];
    // 該行要顯示的內容
    NSString *content1;  //原文文本
    NSString *content2;  //转发的文本
    
        /*-----------------------------
         原文本
         -----------------------------*/
        content1 = [[self.listData objectAtIndex:indexPath.row] objectForKey:@"text"];
        textSize1 = [content1 sizeWithFont:font constrainedToSize:CGSizeMake(260, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        returnHeight=returnHeight+textSize1.height+10;
        
        /*-----------------------------
         原图
         -----------------------------*/
        NSString *url=[[self.listData objectAtIndex:[indexPath row]] valueForKey:@"thumbnail_pic"];
        if(url!=nil)
        {
            imageSize=CGSizeMake(100, 100);
            
            returnHeight=returnHeight+imageSize.height+13;
        }
        
        else {
            
            /*-----------------------------
             转发文本（转发状态没有原图）
             -----------------------------*/
            NSDictionary *retweeted=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"];
            if(retweeted != nil)
            {
                
                /*转发文本*/
                content2=[retweeted objectForKey:@"text"];
                NSString *name=[[retweeted objectForKey:@"user"] objectForKey:@"screen_name"];
                NSString *repostText=[NSString stringWithFormat:@"@%@: ",name];
                repostText=[repostText stringByAppendingString:content2];
                
                
                textSize2=[repostText sizeWithFont:font constrainedToSize:CGSizeMake(240, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                
                returnHeight=returnHeight+textSize2.height+34;
                
                /*-----------------------------
                 转图
                 -----------------------------*/
                url=[retweeted valueForKey:@"thumbnail_pic"];
                if(url!=nil)
                {
                    
                    imageSize=CGSizeMake(100, 100);
                    
                    returnHeight=returnHeight+imageSize.height+8;
                }
            }
            
        }

    return  returnHeight+30;
}
    
#pragma mark TapGesture
-(void)UesrClicked:(UIGestureRecognizer *)sender
{
        self.currentBigImageIndex=sender.view.tag;
        NSLog(@"pass %d",self.currentBigImageIndex);
        NSString *urlString=[[self.listData objectAtIndex:self.currentBigImageIndex] objectForKey:@"original_pic"];
        if(urlString==nil)
            urlString=[[[self.listData objectAtIndex:self.currentBigImageIndex] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"];
        NSLog(@"%@",urlString);
        
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:self.currentBigImageIndex inSection:0];
        UIImage *image=[self.bigImageCache objectForKey:indexpath];
        
        self.bigImageView=[[BigImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIApplication sharedApplication] keyWindow].frame.size.height)];
        
        self.bigImageView.delegate=self;
        
        if(image!=nil)
        {
            /*直接从缓存取*/
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.bigImageView];
            [self.bigImageView startWithImage:image];
            [self.bigImageView stopAndHide];
        }
        else
        {
            NSLog(@"aaa");
            /*先获取缩略图显示*/
            image=[imageCache objectForKey:indexpath];
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
        /*把大图缓存*/
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:self.currentBigImageIndex inSection:0];
        [self.bigImageCache setObject:bigImage forKey:indexpath];
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
    
#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView beginScroll];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView Scrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView endScroll:scrollView];
}


#pragma mark 导航栏方法
-(void)rightButtonClick
{
    WeiboSettingViewController *userlist_vc=[[WeiboSettingViewController alloc] init];
    [userlist_vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:userlist_vc animated:YES];
}
-(void)leftButtonClick
{

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"确定要退出登陆?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        /*删除归档文件*/
        NSString *filename=[self dataFilePath];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filename]) 
            [defaultManager removeItemAtPath:filename error:nil];
        
        [[SinaWeiboData shared] ToLogout];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 取消全部线程
-(void)cancleOperations
{
    NSArray *operations= [self.queue operations];
    for(NSOperation *op in operations)
    {
        [op cancel];
    }
}


-(void)initTableView
{
    self.tableView=[[DisplayTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-50)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.disPlayDataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.backgroundColor=[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.8];
    self.tableView.separatorColor=[UIColor colorWithRed:229.0/255.0 green:238.0/255.0 blue:243.0/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
}
-(void)initNavigationBar
{
    self.navigationItem.title =@"热门微博";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton=YES;
    
    self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    
    /*右按钮*/
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 49,30);
    UIImage *backImage=[[UIImage imageNamed:@"navibutton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [rightButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [rightButton setTitle:@"设置" forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = button1;
    
    /*左按钮*/
    /*
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 49, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"登出" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
   */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Display DataSource
-(void)refreshData
{
    NSLog(@"refreshData");

    /*置位*/
    page=1;


    [self.weiboLoader cancelRequest];
    //self.weiboLoader=nil;
    NSLog(@"before %@" ,self.weiboLoader);
    self.weiboLoader=[[WeiboLoader alloc] init];
    self.weiboLoader.delegate=self;
    [self.weiboLoader requestWeiboWithIds:self.idList Page:page];
    NSLog(@"after %@" ,self.weiboLoader);
    isRefresh=YES;
    

}
-(void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    isRefresh=NO;
    page++;
   
    [self.weiboLoader cancelRequest];
    //self.weiboLoader=nil;

    self.weiboLoader=[[WeiboLoader alloc] init];
    self.weiboLoader.delegate=self;
    [self.weiboLoader requestWeiboWithIds:self.idList Page:page];
}

#pragma mark WeiboLoaderDelegate
-(void)requestDidSuccessWithData:(NSMutableArray *)result
{
    
    if(isRefresh==YES)
    {
        /*清空数组和缓存*/
        [self.listData removeAllObjects];
        [imageCache removeAllObjects];
       // firstId=nil;
        [self.bigImageCache removeAllObjects];
        
    }
    
    for(NSDictionary *dic in result)
    {
        [self.listData addObject:dic];
    }
    NSLog(@"requestDidSuccessWithData %d",[self.listData count]);
    if(isRefresh==YES)
    {
        if(firstId!=nil)
        {
            int refresh_count=[self numberOfRefresh];
            NSString *toast=[NSString stringWithFormat:@"%d条刷新",refresh_count];
            [self.view makeToast:toast duration:1.0 position:@"top"];
        }
        else
        {
            int count=[result count];
            NSString *toast=[NSString stringWithFormat:@"%d条刷新",count];
            [self.view makeToast:toast duration:1.0 position:@"top"];
        }
        if([self.listData count] !=0)
            firstId=[[self.listData objectAtIndex:0] objectForKey:@"created_at"];
    }
    
    //[self.tableView beginUpdates];
    [self.tableView reloadData];
    //[self.tableView endUpdates];
    
    [self.tableView Stop];
    //NSLog(@"stopcomplete");
}
-(void)requestDidFailWithError
{
    [SVProgressHUD showErrorWithStatus:@"刷新失败" duration:1.0];
    
    [self.tableView Stop];
}
#pragma mark - 处理微博日期
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
/*-------------------------------
 归档
 -------------------------------*/
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.listData forKey:@"default_weibo"];
    
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.listData = [decoder decodeObjectForKey:@"default_weibo"];
        
    }
    return self;
}
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    self.listData = [[[self class] allocWithZone: zone] init];
    return self.listData;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count]!=0)
    {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingPathComponent:@"archive_weibo"];
    }
    return nil;
}

-(void)loadBufferContent
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        NSMutableArray *result = [unarchiver decodeObjectForKey:@"default_weibo"];
        
        for(NSDictionary * dic in result)
        {
            [self.listData addObject:dic];
        }
        
        [unarchiver finishDecoding];
        
        if([self.listData count]!=0)
            firstId=[[self.listData objectAtIndex:0] objectForKey:@"created_at"];
        
        [self.tableView reloadData];
        NSLog(@"默认微博数%d",[self.listData count]);
    }
}





#pragma mark - my method
-(void)LoginIn{
    
}

@end
