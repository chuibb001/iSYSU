//
//  ImageTextView.m
//  Timeline
//
//  Created by simon on 12-12-7.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "ImageTextView.h"
#import <QuartzCore/QuartzCore.h>

#define kWidth 18
#define kHeight 18
#define kStartPoint 1

#define kMar 0

#define kYMar 2


@implementation ImageTextView
@synthesize emojis = _emojis;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(void)parserSendText:(NSString *)text withAry:(NSMutableArray *)mary
{
    NSRange rangeLeft = [text rangeOfString:@"["];
    NSRange rangeRight = [text rangeOfString:@"]"];
    
    if(rangeLeft.length && rangeRight.length) //判断是否为一个完整的表情
        //if (rangeLeft.location != NSNotFound)
    {
        if (rangeLeft.location > 0) // 说明文字在先
        {
            NSString *temStr = [text substringToIndex:rangeLeft.location]; //截取文本
            //NSLog(@"文字 %@",temStr);
            [mary addObject:temStr];//添加文本
            temStr = [text substringWithRange:NSMakeRange(rangeLeft.location, rangeRight.location+1-rangeLeft.location)];// 截取表情
            //NSLog(@"表情 %@",temStr);
            [mary addObject:temStr]; //添加表情
            NSString *newString = [text substringFromIndex:rangeRight.location+1];  // 获得新的字符串
            //NSLog(@"newString %@",newString);
            [self parserSendText:newString withAry:mary];
        }
        else
        {
            NSString *temStr = [text substringWithRange:NSMakeRange(rangeLeft.location, rangeRight.location+1-rangeLeft.location)]; // 截取表情
            if (![temStr isEqualToString:@""])
            {
                [mary addObject:temStr];
                temStr = [text substringFromIndex:rangeRight.location+1]; // 获得新的字符串
                [self parserSendText:temStr withAry:mary];
            }
            else
            {
                return;
            }
        }
        
    }
    else //  在字符串中，没发现有表情符号
    {
        if (text!=nil)
            [mary addObject:text];
    }
    
}

-(void)setText:(NSString *)string
{
    weiboEmotions=[[NSArray alloc] initWithObjects:@"[爱你]",@"[悲伤]",@"[闭嘴]",@"[馋嘴]",@"[吃惊]",@"[哈哈]",@"[害羞]",@"[汗]",@"[呵呵]",@"[黑线]",@"[花心]",@"[挤眼]",@"[可爱]",@"[可怜]",@"[酷]",@"[困]",@"[泪]",@"[生病]",@"[失望]",@"[偷笑]",@"[晕]",@"[挖鼻屎]",@"[阴险]",@"[囧]",@"[怒]",@"[good]",@"[给力]",@"[浮云]",@"[嘻嘻]",@"[鄙视]",@"[亲亲]",@"[太开心]",@"[懒得理你]",@"[右哼哼]",@"[左哼哼]",@"[嘘]",@"[衰]",@"[委屈]",@"[吐]",@"[打哈气]",@"[抱抱]",@"[疑问]",@"[拜拜]",@"[思考]",@"[睡觉]",@"[钱]",@"[哼]",@"[鼓掌]",@"[抓狂]",@"[怒骂]",@"[熊猫]",@"[奥特曼]",@"[猪头]",@"[蜡烛]",@"[蛋糕]",@"[din推撞]",@"[心]",nil];
    
    _text = nil;
    
    if(self.emojis)
        self.emojis = nil;
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:100];
    [self parserSendText:string withAry:mutableArray];
    self.emojis = mutableArray;
    /*可以保证drawRect之前清空一下画板*/
    [self setNeedsDisplay];
    
}

-(NSString *)text
{
    return _text;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIFont *emojiFont = [UIFont systemFontOfSize:16.0f];
    
    
    //kmar=3
    CGFloat x = kMar;
    CGFloat y = 0;
    CGSize size;
    
    font = [UIFont systemFontOfSize:16.0f];
    UIColor *light_black=[UIColor blackColor];
    UIColor *light_blue=[UIColor colorWithRed:81.0/255.0 green:108.0/255.0 blue:151.0/255.0 alpha:1.0];
    
    if (self.emojis)
    {
        for (int i = 0; i < [self.emojis count]; i++)
        {
            NSString *emoji = [self.emojis objectAtIndex:i];
            if ([emoji hasPrefix:@"["] && [emoji hasSuffix:@"]"])
            {
                NSString *imageName = [emoji substringWithRange:NSMakeRange(0, emoji.length)]; // 截取图片名字
                //NSLog(@"%@",imageName);
                size = [imageName sizeWithFont:emojiFont constrainedToSize:CGSizeMake(self.frame.size.width, 2000)];
                //NSLog(@"size.width %f size.height %f",size.width,size.height);
                if (x >= self.frame.size.width-size.height)
                {
                    x = kMar;
                    y += size.height;
                }
                
                /*该表情在数组中的索引*/
                int index=[weiboEmotions indexOfObject:imageName];
                if(index !=NSNotFound)
                {
                    if(index>27)
                    {
                        index=index-28;
                        imageName=[NSString stringWithFormat:@"r%d.gif",index];
                    }
                    else {
                        imageName=[NSString stringWithFormat:@"w%d.gif",index];
                    }
                    //NSLog(@"%@",imageName);
                    UIImage *image = [UIImage imageNamed:imageName];
                    [image drawInRect:CGRectMake(x, y, kWidth, kHeight)];
                
                    x += kWidth;
                }
                else  //找不到表情就绘文字咯
                {
                    nomalColor=light_black;
                    [nomalColor set];
                    CGPoint point=[self drawSingleWord:emoji andX:x andY:y];
                    x=point.x;
                    y=point.y;

                }
            }
            else//要显示的文本段
            {
                NSString *newString;
                newString =[self htmlToText:emoji];
                
                
                // 正则表达式 to catch @mention #hashtag and link http(s)://
                NSError *error;
                //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((@|#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]+))|(@|#)([\u4e00-\u9fa5]+)|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:&error];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((@)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]|[\u4e00-\u9fa5]|(_|-))+)|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)|((#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)]|[\u4e00-\u9fa5]|(_|-))+(#))" options:NSRegularExpressionCaseInsensitive error:&error];
                
                //NSLog(@"%@",newString);
                
                
                while (![newString isEqualToString:@""]) {
                    
                    //下一个匹配的串
                    NSTextCheckingResult *next_match = [regex firstMatchInString:newString options:0 range:NSMakeRange(0, [newString length])];
                    if(next_match!=nil)
                    {
                        //NSLog(@"存在");
                        NSRange range=[next_match range];
                        NSString *pre_string=[newString substringToIndex:range.location];
                        //NSLog(@"pre_string%@",pre_string);
                        NSString *match_string=[newString substringWithRange:range];
                        //NSLog(@"match_string%@",match_string);
                        newString=[newString substringFromIndex:range.location+range.length];
                        //NSLog(@"newString%@",newString);
                        /*先画pre_string*/
                        nomalColor=light_black;
                        [nomalColor set];
                        CGPoint point=[self drawSingleWord:pre_string andX:x andY:y];
                        x=point.x;
                        y=point.y;
                        /*再画match_string*/
                        nomalColor=light_blue;
                        [nomalColor set];
                        point=[self drawSingleWord:match_string andX:x andY:y];
                        x=point.x;
                        y=point.y;
                    }
                    else
                    {
                        //NSLog(@"不存在");
                        nomalColor=light_black;
                        [nomalColor set];
                        //对每个字,逐个字绘制
                        CGPoint point=[self drawSingleWord:newString andX:x andY:y];
                        x=point.x;
                        y=point.y;
                        newString=@"";
                    }
                }
            }
            
        }
    }
}

-(CGPoint)drawSingleWord:(NSString *)text andX:(CGFloat)current_x andY:(CGFloat)current_y
{
    [nomalColor set];
    for (int i = 0; i < [text length]; i++)
    {
        
        NSString *tem = [text substringWithRange:NSMakeRange(i, kStartPoint)];
        // NSLog(@"draw%@",tem);
        CGSize size = [tem sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width, 2000)];
        //NSLog(@"%f %f",size.width,size.height);
        // 16 * 19，即系system15.0的字体是16*19，当然字体和字符不同
        if (current_x > self.frame.size.width-size.width)
        {
            current_x = kMar;
            current_y += size.height;
            
        }
        [tem drawInRect:CGRectMake(current_x, current_y, size.width, size.height) withFont:font];
        current_x=current_x+size.width;
    }
    return  CGPointMake(current_x, current_y);
}

- (NSString *)htmlToText:(NSString *)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    // Newline character (if you have a better idea...)
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n"  withString:@">newLine"];
    
    // Extras
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<3" withString:@"♥"];
    
    //NSLog(@"%@",htmlString);
    return htmlString;
}
@end
