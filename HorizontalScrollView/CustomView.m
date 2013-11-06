//
//  CustomView.m
//  HorizontalScrollView
//
//  Created by ltf on 13-11-6.
//  Copyright (c) 2013年 ltf. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setStr:(NSString *)str
{
    NSLog(@"======hasgo = %@",str);
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    label.text = str;
}

@end
