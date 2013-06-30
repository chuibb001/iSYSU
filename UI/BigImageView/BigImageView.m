//
//  BigImageView.m
//  TimePill
//
//  Created by simon on 13-3-22.
//
//

#import "BigImageView.h"

@implementation BigImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.scrollv=[[UIScrollView alloc] initWithFrame:self.frame];
        
        [self addSubview:self.scrollv];
        
        self.imagev=[[UIImageView alloc] initWithFrame:self.frame];
        self.imagev.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollv addSubview:self.imagev];
        self.scrollv.scrollEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserClicked:)];
        [self addGestureRecognizer:tap];
        
        self.progress=[[DACircularProgressView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-15, 30, 30)];
        [self addSubview:self.progress];
        
        self.total_Bytes=0;
        self.current_Bytes=0;
        
    }
    return self;
}

/*加载缩略图或大图*/
-(void)startWithImage:(UIImage *)image
{
    self.imagev.image=image;
    [self.imagev setNeedsDisplay];
    self.imagev.alpha=0.0;
    self.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
        self.imagev.alpha=1.0;}];
    
    double width=image.size.width;
    double height=image.size.height;
    
    double bi=self.frame.size.height/self.frame.size.width;
    
    /*如果图很长，则以scrollview来显示*/
    if(height/width<bi)
    {
        self.imagev.frame=CGRectMake(self.imagev.frame.origin.x, self.imagev.frame.origin.y, self.imagev.frame.size.width, self.frame.size.height);
    }
    else
    {
        self.imagev.frame=CGRectMake(self.imagev.frame.origin.x, self.imagev.frame.origin.y, self.imagev.frame.size.width, height*320/width);
        self.scrollv.contentSize=CGSizeMake(320, height*320/width);
    }
    
    self.progress.hidden=NO;
}

/*大图下载完后，重置ImageView*/
-(void)ResetImage:(UIImage *)image
{
    self.imagev.image=image;
    [self.imagev setNeedsDisplay];
    
    self.progress.hidden=YES;
}

/*用户点击，退出*/
-(void)UserClicked:(UIGestureRecognizer *)sender
{
    //NSLog(@"pass");
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0.0;
    ;}];
    
    [self.delegate DidTapToCancle];
    
}

-(void)downloadFail
{
    self.progress.hidden=YES;
}
-(void)stopAndHide
{
    self.progress.hidden=YES;
}
/*增加progress*/
-(void)AddProgress
{
    double percent=(double)self.current_Bytes/(double)self.total_Bytes;
    //NSLog(@"%d,%d,%f",self.current_Bytes,self.total_Bytes,percent);
    self.progress.progress+=percent;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
