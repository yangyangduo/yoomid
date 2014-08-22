//
//  PartsScrollView.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PartsScrollView.h"

#define TITLE_SCROLL_VIEW_HEIGHT   44
#define TITLE_COUNTS_IN_LINE       4
#define TITLE_ENTRY_WIDTH          self.bounds.size.width / TITLE_COUNTS_IN_LINE
#define CONTENT_ENTRY_WIDTH        self.bounds.size.width

@implementation PartsScrollView {
    UIScrollView *partTitleScrollView;
    UIScrollView *partContentScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initUI];
        [self refreshWithParts:[self mockParts]];
    }
    return self;
}

- (NSArray *)mockParts {
    Part *p1 = [[Part alloc] init];
    p1.title = @"日用品";
    
    Part *p2 = [[Part alloc] init];
    p2.title = @"洗发液";
    
    Part *p3 = [[Part alloc] init];
    p3.title = @"烟酒";
    
    Part *p4 = [[Part alloc] init];
    p4.title = @"零食";
    
    Part *p5 = [[Part alloc] init];
    p5.title = @"交通工具";
    
    Part *p6 = [[Part alloc] init];
    p6.title = @"啦啦啦";
    
    return [NSArray arrayWithObjects:p1, p2, p3, p4, p5, p6, nil];
}

- (void)initUI {
    partTitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TITLE_SCROLL_VIEW_HEIGHT)];
    partTitleScrollView.backgroundColor = [UIColor redColor];
    partTitleScrollView.delegate = self;
    
    partContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, partTitleScrollView.bounds.size.height, self.bounds.size.width, self.bounds.size.height - partTitleScrollView.bounds.size.height)];
    partContentScrollView.backgroundColor = [UIColor yellowColor];
    partContentScrollView.pagingEnabled = YES;
    partContentScrollView.delegate = self;
    
    [self addSubview:partTitleScrollView];
    [self addSubview:partContentScrollView];
}

- (void)refreshWithParts:(NSArray *)parts {
    partTitleScrollView.contentSize = CGSizeMake((parts.count <= TITLE_COUNTS_IN_LINE ? partTitleScrollView.bounds.size.width : parts.count * TITLE_ENTRY_WIDTH), partTitleScrollView.bounds.size.height);
    
    partContentScrollView.contentSize = CGSizeMake(CONTENT_ENTRY_WIDTH * (parts.count == 0 ? 1 : parts.count), partContentScrollView.bounds.size.height);
    
    for(int i=0; i<parts.count; i++) {
        Part *part = [parts objectAtIndex:i];
        
        CGFloat x = i * TITLE_ENTRY_WIDTH;
        UIButton *partTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, TITLE_ENTRY_WIDTH, TITLE_SCROLL_VIEW_HEIGHT)];
        [partTitleButton setTitle:part.title forState:UIControlStateNormal];
        [partTitleScrollView addSubview:partTitleButton];
        
        
    }
}

#pragma mark -
#pragma mark UIScroll view delegate

@end
