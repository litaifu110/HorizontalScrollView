//
//  HorizontalScrollView.h
//  HorizontalScrollViewDemo
//
//  Created by Gukw on 3/26/13.
//  Copyright (c) 2013 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalCell;

@protocol HorizontalScrollViewDelegate <NSObject>

@required
-(NSInteger)numbersOfRowsInHorizontalScrollView:(UIScrollView *)horizontalScrollView;
-(UIView *)horizontalScrollView:(UIScrollView *)horizontalScrollView cellForRow:(NSInteger)row;
@optional

@end

@interface HorizontalScrollView : UIScrollView{
    UIView *viewLeft;
    UIView *viewCenter;
    UIView *viewRight;
    UIView *cellLeft;
    UIView *cellCenter;
    UIView *cellRight;
    CGFloat widthCell;
    CGFloat heightCell;
    NSInteger rowForLeft;
    NSInteger rowForCenter;
    NSInteger rowForRight;
    NSMutableDictionary *dCells;
    NSInteger _initIndex; //默认显示的index
    
    CGFloat beginPoint;
    NSInteger rowShow;
    NSString *swipeDirection;
}
@property (nonatomic, weak) id <HorizontalScrollViewDelegate> delegateHorizontal;


//初始化的时候默认读取第几个row
-(id)initWithFrame:(CGRect)frame withRow:(NSInteger)row;
//判断方向用的
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//当容器滚动时调用该方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
//数据发生变化时，更新数据和当前容器的宽度
-(void)reload;
//获取可复用的cell
-(HorizontalCell *)dequeueReusableCellWithIdentifier:(NSString *)CellIdentifier;
-(void)showRow:(NSInteger)row;
-(void)scrollToRow:(NSInteger)row;
@end


@interface HorizontalCell : UIView
@property (nonatomic ,copy) NSString *identifier;
-(id)initWithIndentifier:(NSString *)identifier;
@end
