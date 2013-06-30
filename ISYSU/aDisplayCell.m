//
//  aDisplayCell.m
//  Timeline
//
//  Created by simon on 12-12-13.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "aDisplayCell.h"

@implementation aDisplayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        /*头像*/
        self.headImageView=[[UIImageView alloc] init];
        self.headImageView.frame=CGRectMake(8, 5, 34, 34);
        [self addSubview:self.headImageView];
        
        /*名字*/
        self.nameLabel=[[UILabel alloc] init];
        self.nameLabel.frame=CGRectMake(52, 8, 200, 14);
        self.nameLabel.backgroundColor=[UIColor clearColor];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:self.nameLabel];
        
        /*转发按钮*/
        self.repostButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.repostButton.frame=CGRectMake(212, 10, 50, 11);
        [self.repostButton setImage:[UIImage imageNamed:@"repost.png"] forState:UIControlStateNormal];
        self.repostButton.userInteractionEnabled=NO;
        [self.repostButton setTitleColor:[UIColor colorWithRed:81.0/255.0 green:108.0/255.0 blue:151.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.repostButton.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        //[self.repostButton setTitle:@"11111" forState:UIControlStateNormal];
        [self.repostButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [self addSubview:self.repostButton];
        
        /*评论按钮*/
        self.commentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton.frame=CGRectMake(262, 10, 50, 11);
        [self.commentButton setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        self.commentButton.userInteractionEnabled=NO;
        [self.commentButton setTitleColor:[UIColor colorWithRed:81.0/255.0 green:108.0/255.0 blue:151.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.commentButton.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        //[self.commentButton setTitle:@"11111" forState:UIControlStateNormal];
        [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [self addSubview:self.commentButton];
        
        /*文本*/
        self.textView=[[ImageTextView alloc] initWithFrame:CGRectMake(52, 35, 260, 20)];
        self.textView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.textView];
        
        /*转发背景色块*/
        self.repostBackgroundView=[[UIImageView alloc] initWithFrame:CGRectMake(52, 1, 260, 1)];
        self.repostBackgroundView.userInteractionEnabled=NO;
        [self addSubview:self.repostBackgroundView];
        
        /*转发文本*/
        self.repostTextView=[[ImageTextView alloc] initWithFrame:CGRectMake(10, 12, 240, 1)];
        self.repostTextView.backgroundColor=[UIColor clearColor];
        [self.repostBackgroundView addSubview:self.repostTextView];
        
        /*原图或转发图*/
        self.aImageView=[[UIImageView alloc] init];
        self.aImageView.frame=CGRectMake(1, 1, 1, 1);
        self.aImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.aImageView];
        
        /*时间*/
        self.timeLabel=[[UILabel alloc] init];
        self.timeLabel.font=[UIFont systemFontOfSize:10.0];
        self.timeLabel.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.timeLabel.textAlignment=UITextAlignmentLeft;
        self.timeLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.timeLabel];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    aDisplayCell *copy = [[[self class] allocWithZone: zone]
                          init];
    copy.nameLabel=self.nameLabel;
    return copy;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)storeWeiboID:(NSString *)aWeiboID{
    weiboID=[[NSString alloc] initWithFormat:@"%@",aWeiboID];
}
-(NSString *)getWeiboID{
    return weiboID;
}
@end
