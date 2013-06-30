//
//  DisplayCell.m
//  Timeline
//
//  Created by simon on 12-12-13.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "DisplayCell.h"

@implementation DisplayCell
@synthesize articleDate;
@synthesize articleTitle;
@synthesize readTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*文章标题*/
        self.articleTitle=[[UILabel alloc] init];
        [self.articleTitle setFont:[UIFont systemFontOfSize:16.0]];
		[self.articleTitle setTextColor:[UIColor colorWithRed:41.f/256 green:41.f/256 blue:41.f/256 alpha:1]];
		[self.articleTitle setBackgroundColor:[UIColor clearColor]];
		[self.articleTitle setTextAlignment:UITextAlignmentLeft];
        self.articleTitle.lineBreakMode=UILineBreakModeWordWrap;
        self.articleTitle.numberOfLines=0;
        [self addSubview:self.articleTitle];
        
        /*文章时间*/
        self.articleDate=[[UILabel alloc] init];
        self.articleDate.font=[UIFont systemFontOfSize:13.0];
        self.articleDate.textColor=[UIColor colorWithRed:25.0/255.0 green:123.0/255.0 blue:48.0/255.0 alpha:1.0];
        self.articleDate.textAlignment=UITextAlignmentRight;
        self.articleDate.backgroundColor=[UIColor clearColor];
        [self addSubview:self.articleDate];
        
        /*已读标记5*30*/
        self.readTag=[[UIImageView alloc] init];
        self.readTag.image=[UIImage imageNamed:@"unread.png"];
        [self addSubview:self.readTag];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
