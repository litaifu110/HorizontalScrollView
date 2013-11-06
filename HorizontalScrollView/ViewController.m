//
//  ViewController.m
//  HorizontalScrollView
//
//  Created by ltf on 13-11-5.
//  Copyright (c) 2013年 ltf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<HorizontalScrollViewDelegate,UIScrollViewDelegate>
{
    HorizontalScrollView *_scrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake(0, 0, 320, CGRectGetHeight(self.view.bounds));
    _scrollView = [[HorizontalScrollView alloc] initWithFrame:frame withRow:0];
    _scrollView.delegate = (id)self;
    _scrollView.delegateHorizontal = self;
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor purpleColor];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[HorizontalScrollView class]]) {
        [(HorizontalScrollView *)scrollView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isMemberOfClass:[HorizontalScrollView class]]) {
        [(HorizontalScrollView *)scrollView scrollViewDidScroll:scrollView];
    }
}

#pragma mark - HorizontalScrollViewDelegate
- (NSInteger)numbersOfRowsInHorizontalScrollView:(UIScrollView *)horizontalScrollView{
    return 10;
}

- (UIView *)horizontalScrollView:(UIScrollView *)horizontalScrollView cellForRow:(NSInteger)row{
    static NSString *identifier = @"cell";
    CustomView *view;
    HorizontalCell *cell = [(HorizontalScrollView *)horizontalScrollView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[HorizontalCell alloc] initWithIndentifier:identifier];
        cell.frame = CGRectMake(20, 20, CGRectGetWidth(_scrollView.bounds) - 40, CGRectGetHeight(self.view.bounds) - 40);
        cell.backgroundColor = [UIColor whiteColor];
        
        view = [[CustomView alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(cell.bounds) - 40, CGRectGetHeight(cell.bounds) - 40)];
        view.tag = 1;
        view.backgroundColor = [UIColor blackColor];
        [cell addSubview:view];
        
        
    }
    view = (CustomView *)[cell viewWithTag:1];
    view.str = [NSString stringWithFormat:@"%d",row];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
