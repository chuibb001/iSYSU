//
//  HotelCell.m
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "HotelCell.h"

@implementation HotelCell

@synthesize nameLabel,addressLabel,numberLabel,quotation;

- (void)setQuotation:(HotelItem *)newQuotation {
    if (nameLabel == nil) {
        
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 250, 22)];
    nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f];
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 300, 44)];
        addressLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:14.0f];
    addressLabel.textColor = [UIColor colorWithRed:156.0/255 green:156.0/255 blue:156.0/255 alpha:1];
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 300, 22)];
    numberLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    numberLabel.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
         [addressLabel setBackgroundColor:[UIColor clearColor]];
         [numberLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nameLabel];
    [self addSubview:addressLabel];
    [self addSubview:numberLabel];
    }
    if (quotation != newQuotation) {
        quotation = newQuotation;
        NSLog(@"%@",newQuotation);
        nameLabel.text = quotation.name;
       addressLabel.text = quotation.address;
        numberLabel.text = quotation.number;
        //quotationTextView.text = quotation.quotation;
    }
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
