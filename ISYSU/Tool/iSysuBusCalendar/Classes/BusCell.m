//
//  BusCell.m
//  ISYSU
//
//  Created by yongry on 13-3-27.
//  Copyright (c) 2013年 yongry. All rights reserved.
//

#import "BusCell.h"


@implementation BusCell
@synthesize fromLabel,toLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell.png"]];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
	/*if(selected)
     {
     self.backgroundColor = [UIColor colorWithRed: 253/255 green: 249/255 blue: 220/255 alpha: 1.0];
     }
     else {
     self.backgroundColor = [UIColor clearColor];
     }*/
    
    
    // Configure the view for the selected state.
}




@end

