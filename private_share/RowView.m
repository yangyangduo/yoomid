//
//  RowView.m
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "RowView.h"

@implementation RowView

@synthesize columnViews = _columnViews;
@synthesize sizes = _sizes;
@synthesize name = _name;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        NSMutableArray *columnArray = [NSMutableArray array];
        NSArray *_columnArray_ = [json arrayForKey:@"cv"];
        
        if (_columnArray_ != nil) {
            for (int i = 0; i<_columnArray_.count; i++) {
                NSDictionary *tempD = [_columnArray_ objectAtIndex:i];
                ColumnView *column = [[ColumnView alloc] initWithJson:tempD];
                [columnArray addObject:column];
            }
        }
        
        self.columnViews = columnArray;
        self.sizes = [json numberForKey:@"size"].integerValue;
        self.name = [json noNilStringForKey:@"name"];
    }
    return self;
}

@end
