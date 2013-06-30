//
//  BusCell.h
//  ISYSU
//
//  Created by yongry on 13-3-27.
//  Copyright (c) 2013年 yongry. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BusCell : UITableViewCell {
	UILabel *fromLabel;
	UILabel *toLabel;
    
    
}
@property (nonatomic, retain) IBOutlet UILabel *fromLabel;
@property (nonatomic, retain) IBOutlet UILabel *toLabel;

@end
