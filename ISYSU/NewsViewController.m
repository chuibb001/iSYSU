//
//  NewsViewController.m
//  ISYSU
//
//  Created by simon on 13-3-12.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()
{
    Boolean isRefresh;
}

@end

@implementation NewsViewController
@synthesize articleTableView;
@synthesize articles;
@synthesize page;
@synthesize TableHeader;
@synthesize newsGetter;
@synthesize readList;

#pragma mark LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initData];
    [self initTable];
    
    [self loadBufferContent];  //先读缓存
    if([self.articles count]==0)  //没有缓存
        [self.articleTableView refresh];
    
}

#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DisplayCell";
    
    DisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DisplayCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *news = [self.articles objectAtIndex:[indexPath row]];
    /*标题*/
    NSString *title=[news objectForKey:@"articleTitle"];
    /*去除空格*/
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    title = [title  stringByTrimmingCharactersInSet:whitespace];
    
    CGSize size=[title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    cell.articleTitle.frame=CGRectMake(20, 10, 290, size.height);
    cell.articleTitle.text=title;
    //cell.articleTitle.backgroundColor=[UIColor redColor];
    //NSLog(@"%@",title);
    //[cell.articleTitle sizeToFit];
    /*时间*/
    cell.articleDate.frame=CGRectMake(10, 15+size.height, 290, 15);
    cell.articleDate.text=[news objectForKey:@"articleDate"];
    /*已读标签*/
    Boolean isRead=[self.readList containsObject:title];
    NSLog(@"已读%@ %d",title,isRead);
    if(isRead == YES)
    {
        cell.readTag.image=nil;
        cell.readTag.frame=CGRectMake(0, (size.height+35)/2-24, 5, 30);
    }
    else
    {
        //NSLog(@"cell%f",cell.frame.size.height);
        cell.readTag.image=[UIImage imageNamed:@"unread.png"];
        cell.readTag.frame=CGRectMake(0, (size.height+35)/2-24, 5, 30);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *news = [self.articles objectAtIndex:[indexPath row]];
    NSString *text=[news objectForKey:@"articleTitle"];
    UIFont *font=[UIFont fontWithName:@"Arial-BoldMT" size:16];
    CGSize size=[text sizeWithFont:font constrainedToSize:CGSizeMake(300, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    //NSLog(@"height%f",size.height+35);
    return size.height+20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.articleTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *articleId=[[self.articles objectAtIndex:[indexPath row]] objectForKey:@"articleID"];
    NewsDetailViewController *detailVC=[[NewsDetailViewController alloc] init];
    [detailVC setValue:articleId forKey:@"articleID"];
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    /*把其添加到已读*/
    /*标题*/
    NSString *title=[[self.articles objectAtIndex:[indexPath row]] objectForKey:@"articleTitle"];
    /*去除空格*/
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    title = [title  stringByTrimmingCharactersInSet:whitespace];
    if(![self.readList containsObject:title])
    {
        [self.readList addObject:title];
        NSLog(@"read%@",self.readList);
        [[NSUserDefaults standardUserDefaults] setValue:self.readList forKey:@"readList"];
    }
    
    DisplayCell *dcell=(DisplayCell *)[self.articleTableView cellForRowAtIndexPath:indexPath];
    dcell.readTag.image=NULL;
    [dcell setNeedsDisplay];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark DisplayDataSource
-(void)refreshData
{
    NSLog(@"~refreshData");
    self.first=YES;
    //    self.page=1;
    isRefresh=YES;
    //    [NewsListGetter getterWithDelegate:self andPage:self.page];
    self.page=1;
    [NewsListGetter getterWithDelegate:self andPage:self.page];
}
-(void)loadMoreData
{
    self.first=YES;
    NSLog(@"~loadMoreData");
    isRefresh=NO;
    
    self.page++;
    [NewsListGetter getterWithDelegate:self andPage:self.page];
}

#pragma mark ISYSUGetterDelegate
//更新失败时候的提示
- (void) getterFailed:(id)getter{
    if(self.first==YES)
    {
        self.first=NO;
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"StopRefresh" object:nil];
        [self.articleTableView Stop];
        self.newsGetter = nil;
        
        [SVProgressHUD showErrorWithStatus:@"加载新闻失败" duration:1.0];
    }
}

//新闻获取成功
- (void) getterSucceeded:(id)getter withInfo:(NSDictionary *)info{
    if(self.first==YES)
    {
        self.first=NO;
        //NSLog(@"新闻加载成功");
        self.newsGetter = nil;
        NSArray *list = [info objectForKey:@"list"];
        
        if(isRefresh==YES)
        {
            [self.articles removeAllObjects];
        }
        
        for(NSDictionary *dic in list)
        {
            [self.articles addObject:dic];
        }
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"StopRefresh" object:nil];
        [self.articleTableView reloadData];
        [self.articleTableView Stop];
        
        /*------------------
                归档
         ------------------*/
        if(self.page==1)
        {
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:self.articles forKey:@"default_news"];
            [archiver finishEncoding];
            [data writeToFile:[self dataFilePath] atomically:YES];
            
            /*记录第一条的ID*/
            if(firstId!=nil)
            {
                int refresh_count=[self numberOfRefresh];
                NSString *toast=[NSString stringWithFormat:@"本次刷新%d条.",refresh_count];
                [self.view makeToast:toast duration:1.0                              position:@"top"  title:nil];
                
            }
            else
            {
                [self.view makeToast:@"本次刷新20条."  duration:1.0                          position:@"top"
                               title:nil];
            }
            firstId=[[self.articles objectAtIndex:0] objectForKey:@"articleTitle"];
        }
    }
    
	
}

-(int)numberOfRefresh
{
    int i=0;
    for(NSDictionary *dic in self.articles)
    {
        if(![[dic objectForKey:@"articleTitle"] isEqual:firstId])
            i++;
        else
            break;
    }
    return i;
}

/*-------------------------------
 归档
 -------------------------------*/
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.articles forKey:@"default_news"];
    
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.articles = [decoder decodeObjectForKey:@"default_news"];
        
    }
    return self;
}
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    self.articles = [[[self class] allocWithZone: zone] init];
    return self.articles;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"archive_news"];
}

-(void)loadBufferContent
{
    
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        NSMutableArray *result = [unarchiver decodeObjectForKey:@"default_news"];
        
        for(NSDictionary * dic in result)
        {
            [self.articles addObject:dic];
        }
        
        [unarchiver finishDecoding];
        
        if([self.articles count]!=0)
            firstId=[[self.articles objectAtIndex:0] objectForKey:@"articleTitle"];
        
        [self.articleTableView reloadData];
        NSLog(@"默认文章数%d",[self.articles count]);
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.articleTableView beginScroll];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.articleTableView Scrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.articleTableView endScroll:scrollView];
}

#pragma mark init
-(void) initData
{
    self.page=1;
    //[NewsListGetter getterWithDelegate:self andPage:self.page];
    /*初始化真值表*/
    self.readList=[[NSUserDefaults standardUserDefaults] valueForKey:@"readList"];
    NSLog(@"truelist%@",self.readList);
    if(self.readList==nil)
        self.readList=[[NSMutableArray alloc] init];
}
-(void) initTable
{
    self.articles=[[NSMutableArray alloc] init];
    
    self.articleTableView=[[DisplayTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50-44)];
    self.articleTableView.dataSource=self;
    self.articleTableView.delegate=self;
    self.articleTableView.disPlayDataSource=self;
    self.articleTableView.backgroundColor=[UIColor clearColor];
    self.articleTableView.separatorColor=[UIColor colorWithRed:229.0/255.0 green:238.0/255.0 blue:243.0/255.0 alpha:1.0];
    [self.articleTableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:self.articleTableView];
    
    /*头图*/
    UIImage *toutu=[UIImage imageNamed:@"newspicture.png"];
    self.TableHeader=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 162)];
    self.TableHeader.image=toutu;
    self.articleTableView.tableHeaderView=self.TableHeader;
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view setBackgroundColor:bgColor];
}
-(void) initNavigationBar
{
    self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title=@"中大新闻";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
