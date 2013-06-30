//
//  UISendViewController.m
//  ISYSU
//
//  Created by 王 瑞 on 13-3-27.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "UISendViewController.h"
#import "SinaWeiboData.h"
#import "SVProgressHUD.h"


@implementation UISendViewController
@synthesize aID;
@synthesize content;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNav];
    [self initView];
	[self initNotifications];
    [self initEmotions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithID:(NSString *)ID{
    self=[super init];
    if (self) {
        self.aID=ID;
    }
    return self;
}
-(void)initEmotions{
    /*----------------------------------------表情栏----------------------------------------*/
    //设置背景
    emotionsBack=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 216)];
    emotionsBack.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"motionbg.png"]];
    //设置表情ScrollView
    emotionsView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    emotionsView.pagingEnabled=YES;  //是否自动滑到边缘的关键
    emotionsView.contentSize=CGSizeMake(320*2, 216);
    emotionsView.showsHorizontalScrollIndicator=NO;
    emotionsView.delegate=self;
    [self.view addSubview:emotionsBack];
    [emotionsBack addSubview:emotionsView];
    
    //表情文本数组
    weiboEmotions=[[NSArray alloc] initWithObjects:@"[爱你]",@"[悲伤]",@"[闭嘴]",@"[馋嘴]",@"[吃惊]",@"[哈哈]",@"[害羞]",@"[汗]",@"[呵呵]",@"[黑线]",@"[花心]",@"[挤眼]",@"[可爱]",@"[可怜]",@"[酷]",@"[困]",@"[泪]",@"[生病]",@"[失望]",@"[偷笑]",@"[晕]",@"[挖鼻屎]",@"[阴险]",@"[囧]",@"[怒]",@"[good]",@"[给力]",@"[浮云]", nil];
    weiboEmotions2=[[NSArray alloc] initWithObjects:@"[嘻嘻]",@"[鄙视]",@"[亲亲]",@"[太开心]",@"[懒得理你]",@"[右哼哼]",@"[左哼哼]",@"[嘘]",@"[衰]",@"[委屈]",@"[吐]",@"[打哈欠]",@"[抱抱]",@"[疑问]",@"[拜拜]",@"[思考]",@"[睡觉]",@"[钱]",@"[哼]",@"[鼓掌]",@"[抓狂]",@"[怒骂]",@"[熊猫]",@"[奥特曼]",@"[猪头]",@"[蜡烛]",@"[蛋糕]",@"[din推撞]", nil];
    
    //把表情添加到scrollview中
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<7;j++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(18+j*43, 20+i*45, 25, 25);
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"w%d.gif",i*7+j]];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=i*7+j;
            [button addTarget:self action:@selector(emotionclicked:) forControlEvents:UIControlEventTouchUpInside];
            [emotionsView addSubview:button];
        }
    }
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<7;j++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(320+18+j*43, 20+i*45, 25, 25);
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"r%d.gif",i*7+j]];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=28+i*7+j;
            [button addTarget:self action:@selector(emotionclicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [emotionsView addSubview:button];
        }
    }
    //设置表情pageControl
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(135, 170, 40, 50)];
    pageControl.numberOfPages=2;
    pageControl.currentPage=0;
    [pageControl addTarget:self action:@selector(showChanges) forControlEvents:UIControlEventValueChanged];
    [emotionsBack insertSubview:pageControl atIndex:2];
    
    
    /************/
    
    //工具栏
    
    /************/
    toolView=[[UIView alloc] initWithFrame:CGRectMake(0, 580, 320, 44)];
    toolView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentRectangle.png"]];
    [self.view addSubview:toolView];
    
    
    tooEmotion=[[UIButton alloc] initWithFrame:CGRectMake(260, 0, 44, 44)];
    [tooEmotion setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    // [tooEmotion setHighlighted:YES];
    [tooEmotion addTarget:self action:@selector(hideEmotions) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tooEmotion];
    [self.view addSubview:emotionsBack];
    
    tooEmotion.hidden=YES;
    emotionsBack.hidden=YES;
    
}

-(void)initNav{
    
    self.navigationItem.title =@"转发";
    self.navigationItem.hidesBackButton=YES;
    
    self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.png"] forBarMetrics:UIBarMetricsDefault];
    
    /*右按钮*/
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 49,30);
    UIImage *backImage=[[UIImage imageNamed:@"navibutton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [rightButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = button1;
    
    /*左按钮*/
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 49, 30);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 1, 0)];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = button2;
    
}

-(void)initView{
    self.content=[[UITextView alloc] initWithFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-280)];
    self.content.delegate=self;
    self.content.editable=YES;
    self.content.font=[UIFont systemFontOfSize:16.0];
    [self.content becomeFirstResponder];
    [self.view addSubview:self.content];
    
}

-(void)initNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendCommentSuccess) name:@"weibo_reSend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendCommentFail) name:@"weibo_reSendFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addButtonForKeyBoard) name:UIKeyboardDidShowNotification object:nil];
}
#pragma mark - My Method

-(void)cancel{
    [SVProgressHUD dismiss];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)send{
    if ([self.content.text isEqualToString:@""]) {
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"亲～" message:@"内容不能为空哦～好桑心～" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        [alert show];
        self.view.userInteractionEnabled=NO;
        [SVProgressHUD showWithStatus:@"转发中..."];
        [[SinaWeiboData shared] reSend:self.aID content:@""];
    }else {
        int length=[self textLength:self.content.text];
        if (length>140) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"亲～" message:@"内容不能为超过140字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            self.view.userInteractionEnabled=NO;
            [SVProgressHUD showWithStatus:@"转发中..."];
            [[SinaWeiboData shared] reSend:self.aID content:self.content.text];
        }
    }
    
    
}

-(int)textLength:(NSString *)dataString
{
    float sum = 0.0;
    for(int i=0;i<[dataString length];i++)
    {
        NSString *character = [dataString substringWithRange:NSMakeRange(i, 1)];
        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            sum++;
        }
        else
            sum += 0.5;
    }
    
    return ceil(sum);
}

-(void)didSendCommentSuccess{
    //   [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)didSendCommentFail{
    self.view.userInteractionEnabled=YES;
}



#pragma mark 分页控制
-(void)showChanges
{
    int page=pageControl.currentPage;
    emotionsView.contentOffset=CGPointMake(320*(page), 0);
}



#pragma mark 表情栏
//点击某一个表情后调用
-(void)emotionclicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    int tag=button.tag;
    NSLog(@"%d",button.tag);
    //该表情的文本
    NSString *emotionStr;
    if(tag>=28)
    {
        int index=tag-28;
        emotionStr=[weiboEmotions2 objectAtIndex:index];
        //NSLog(@"%@",emotionStr);
    }
    else {
        emotionStr=[weiboEmotions objectAtIndex:tag];
    }
    self.content.text=[self.content.text stringByAppendingFormat:emotionStr];
}

-(void)hideEmotions{
    [self.content becomeFirstResponder];
}

#pragma mark 滚动视图delegate

/*----------------------滑动的时候设置对应的分页-----------------------*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat pageWidth = scrollView_.frame.size.width;
    
    int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[pageControl setCurrentPage:page];
}

#pragma mark - 工具栏功能
-(void)getEmotions{
    
    
    if([self.content isFirstResponder])
    {
        
        [self.content  resignFirstResponder];
        UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
        
        emotionsBack.hidden=NO;
        tooEmotion.hidden=NO;
        toEmotion.hidden=YES;
        tooEmotion.frame=CGRectMake(260, self.view.bounds.size.height-keyboards.size.height-44+4, 44, 44);
        emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height-keyboards.size.height, keyboards.size.width, keyboards.size.height);
        toolView.frame=CGRectMake(0, self.view.bounds.size.height-keyboards.size.height-44+4, 320, 44);
    }
    else {
        [self.content  becomeFirstResponder];
        
        emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
        UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
        
        
        emotionsBack.hidden=YES;
    }
    
    
    
}

#pragma mark -Keyboard Notification
- (void) keyboardWillAppear:(NSNotification*)notification{
    animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
}

-(void)keyboardWillDisappear:(NSNotification *)notification{
    //  NSLog(@"-----%f  %f---",keyboards.size.height,keyboards.origin.y);
    
    // CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //  NSLog(@"++++%f  %f++++++",endRect.size.height,endRect.origin.y);
    keyboards.origin.y=264;
    keyboards.size.height=216;
    
    // CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // NSLog(@"****%f  %f*****",beginRect.size.height,beginRect.origin.y);
}

-(void)addButtonForKeyBoard{
    emotionsBack.hidden=YES;
    tooEmotion.hidden=YES;
    toEmotion.hidden=YES;
    UIWindow *temWindow;
    //  UIView *keyboard_father;
    UIView *keyboard;
    
    //  NSLog(@"共有这么多的window: %d",[[[UIApplication sharedApplication] windows] count]);
    for (int c=0; c<[[[UIApplication sharedApplication] windows] count]; c++) {
        
        temWindow=[[[UIApplication sharedApplication] windows] objectAtIndex:c];
        for (int i=0; i<[temWindow.subviews count]; i++) {
            keyboard=[temWindow.subviews objectAtIndex:i];
            
            // for (int j=0; j<[keyboard_father.subviews count]; j++) {
            
            //   keyboard=[keyboard_father.subviews objectAtIndex:j];
            //   NSLog(@"%@",[keyboard description]);
            if ([[keyboard description] hasPrefix:@"<UIPeri"]==YES) {
                
                toEmotion=[[UIButton alloc] initWithFrame:CGRectMake(260, 0, 44, 44)];
                [toEmotion setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
                
                [toEmotion addTarget:self action:@selector(getEmotions) forControlEvents:UIControlEventTouchUpInside];
                
                keyboards=keyboard.frame;
                
                //设计工具栏的背景
                toolView.frame=CGRectMake(0, self.view.bounds.size.height-keyboards.size.height-44+4, 320, 44);
                
                // [keyboard addSubview:toEmotion];
                [toolView addSubview:toEmotion];
                return;
            }
            // }
        }
        
    }
}
@end
