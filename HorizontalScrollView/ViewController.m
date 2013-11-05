//
//  ViewController.m
//  HorizontalScrollView
//
//  Created by ltf on 13-11-5.
//  Copyright (c) 2013年 ltf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<HorizontalScrollViewDelegate>
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
    HorizontalCell *cell = [(HorizontalScrollView *)horizontalScrollView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[HorizontalCell alloc] initWithIndentifier:identifier];
        cell.frame = CGRectMake(20, 20, CGRectGetWidth(_scrollView.bounds) - 40, CGRectGetHeight(self.view.bounds) - 40);
    }
    if (row%3 == 0) {
        cell.backgroundColor = [UIColor redColor];
    }else if(row%3 == 1){
        cell.backgroundColor = [UIColor yellowColor];
    }else{
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
