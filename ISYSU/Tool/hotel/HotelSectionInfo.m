//
//  HotelSectionInfo.m
//  ISYSU
//
//  Created by yongry on 13-3-18.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "HotelSectionInfo.h"

@implementation HotelSectionInfo

@synthesize open, rowHeights, play, headerView;

- init {
	
	self = [super init];
	if (self) {
		rowHeights = [NSMutableArray array];
	}
	return self;
}


- (NSUInteger)countOfRowHeights {
	return [rowHeights count];
}

- (void)getRowHeights:(id *)buffer range:(NSRange)inRange {
	[rowHeights getObjects:buffer range:inRange];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
//    NSLog(@"%d",idx);
//	return [rowHeights objectAtIndex:idx];
    NSNumber *number = [NSNumber numberWithInt:135];
    NSInteger tem = [number integerValue]; 
    return tem;
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
	[rowHeights insertObject:anObject atIndex:idx];
    NSLog(@"%@  %d",anObject,idx);
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
	[rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
	[rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
	[rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
	[rowHeights replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
	[rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}



@end
