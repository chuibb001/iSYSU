//
//  CommentCell.m
//  ISYSU
//
//  Created by 王 瑞 on 13-3-21.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize date,avart,content;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /*名字*/
        self.nameLabel=[[UILabel alloc] init];
        self.nameLabel.frame=CGRectMake(52, 9, 180, 15);
        self.nameLabel.backgroundColor=[UIColor clearColor];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:self.nameLabel];
        
        /*头像*/
        self.avart=[[UIImageView alloc] init];
        self.avart.frame=CGRectMake(8, 5, 34, 34);
        [self addSubview:self.avart];
        
        /*文本*/
        self.content=[[ImageTextView alloc] initWithFrame:CGRectMake(52, 37, 240, 30)];
        self.content.backgroundColor=[UIColor clearColor];
        [self addSubview:self.content];
        
        /*日期*/
        self.date=[[UILabel alloc] init];
        self.date.frame=CGRectMake(320-70, 8, 60, 14);
        self.date.backgroundColor=[UIColor clearColor];
        self.date.font=[UIFont systemFontOfSize:11.0];
        self.date.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.date.textAlignment=UITextAlignmentLeft;
        [self addSubview:date];
        
        UIImageView *qq=[[UIImageView alloc] initWithFrame:CGRectMake(320-34, 25, 22, 22)];
        qq.image=[UIImage imageNamed:@"replycomment.png"];
        [self addSubview:qq];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end
