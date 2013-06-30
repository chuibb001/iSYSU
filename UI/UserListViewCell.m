//
//  UserListViewCell.m
//  ISYSU
//
//  Created by Cho-Yeung Lam on 25/3/13.
//  Copyright (c) 2013 simon. All rights reserved.
//

#import "UserListViewCell.h"

@implementation UserListViewCell

//@synthesize avatar;
@synthesize weiboNameLabel;
@synthesize weiboDescriptionLabel;
@synthesize radioButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
////weibo头像        
//        self.avatar = [[UIImageView alloc] init];
//        self.avatar.frame = CGRectMake(5, 10, 20, 20);
//        [self addSubview:self.avatar];
        
//weibo名字        
        self.weiboNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 270, 30)];
        self.weiboNameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
        self.weiboNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.weiboNameLabel];
        
//weibo描述
        self.weiboDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 270, 30)];
        self.weiboDescriptionLabel.textColor = [UIColor grayColor];
        self.weiboDescriptionLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0f];
        self.weiboDescriptionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.weiboDescriptionLabel];
        
//选择按钮
        self.radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.radioButton.frame=CGRectMake(280, 20, 20, 20);
        self.radioButton.imageView.image = [UIImage imageNamed:@"navibutton.png"];
        self.radioButton.userInteractionEnabled=NO;
        [self addSubview:self.radioButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
