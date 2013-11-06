//
//  HorizontalScrollView.m
//  HorizontalScrollViewDemo
//
//  Created by Gukw on 3/26/13.
//  Copyright (c) 2013 ios. All rights reserved.
//

#import "HorizontalScrollView.h"

@implementation HorizontalScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withRow:(NSInteger)row{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
        [self initProperty];
        _initIndex = row;
        rowShow = -1;
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"dealloc == %@",[self class]);
}


-(void)initProperty{
    widthCell = self.frame.size.width;
    heightCell = self.frame.size.height;
    CGRect frameLeft = viewLeft.frame;
    CGRect frameCenter = viewCenter.frame;
    CGRect frameRight = viewRight.frame;
    frameLeft.size.width = widthCell;
    frameLeft.size.height = heightCell;
    frameCenter.size.width = widthCell;
    frameCenter.size.height = heightCell;
    frameCenter.origin.x = widthCell; //这里不设置的画，会盖住viewLeft
    frameRight.size.width = widthCell;
    frameRight.size.height = heightCell;
    frameRight.origin.x = 2*widthCell;
    viewLeft.frame = frameLeft;
    viewCenter.frame = frameCenter;
    viewRight.frame = frameRight;
    
}

//初始化一些必须的组件
-(void) initUI{
    _initIndex = 0;
    self.pagingEnabled = YES;
    dCells = [NSMutableDictionary dictionary];
    rowForLeft = -1;
    rowForCenter = -1;
    rowForRight = -1;
    viewLeft = [[UIView alloc] init];
    viewCenter = [[UIView alloc] init];
    viewRight = [[UIView alloc] init];
    viewLeft.backgroundColor = [UIColor redColor];
    viewCenter.backgroundColor = [UIColor yellowColor];
    viewRight.backgroundColor = [UIColor greenColor];
//    [viewRight setHidden:YES];
    [self addSubview:viewLeft];
    [self addSubview:viewRight];
    [self addSubview:viewCenter];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"!!!!!!!!HorizontalScrollView drawRect!!!!!!");
    // Drawing code
    [self resetContentSize];
    //    [self initProperty];
    if(_initIndex == -1){
        return;
    }
    if(_initIndex){
        [self scrollToRow:_initIndex];
    }else{
        [self scrollToRow:0];
    }
    _initIndex = -1;
}

-(void)resetContentSize{
    NSInteger num = [_delegateHorizontal numbersOfRowsInHorizontalScrollView:self];
    CGSize size = CGSizeMake(widthCell * num , heightCell);
    self.contentSize = size;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    swipeDirection = @"";
    rowShow = -1;
    beginPoint = scrollView.contentOffset.x;
}
//外部可引用的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger rowLeft = 0,rowCenter = 0,rowRight = 0;
    NSInteger left = fmod(floor(x/widthCell), 3);
    NSLog(@"left ======%d",left);
    if(left < 0){//顶头右滑（所有滑动针对触摸点的移动）
        return;
    }
    
    rowLeft = floor(x/widthCell) - 1;
    rowCenter = floor(x/widthCell);
    rowRight = floor(x/widthCell)+1;
    
    if (x - beginPoint > 0) {//左滑（手势方向）  cellindex越来越大
        swipeDirection = @"left";
        rowLeft = floor(x/widthCell) - 1;
        rowCenter = floor(x/widthCell);
        rowRight = floor(x/widthCell)+1;
    }else{
        swipeDirection = @"right";
        rowLeft = floor(x/widthCell) ;
        rowCenter = floor(x/widthCell) + 1;
        rowRight = floor(x/widthCell)+2;
    }
    NSLog(@"x/widthCell = %f",x/widthCell);
    if(floor(x/widthCell) + 1 >= [_delegateHorizontal numbersOfRowsInHorizontalScrollView:self]){//顶头左滑
        return;
    }

    if ([swipeDirection isEqualToString:@"left"] && rowShow == -1) {
        [self showRow:rowRight];
        rowShow = rowCenter;
    }else if([swipeDirection isEqualToString:@"right"] && rowShow == -1){
        [self showRow:rowLeft];
        rowShow = rowCenter;
    }
    
}
-(void)showRow:(NSInteger)row{
    if(row%3 == 0){
        [self showLeftRow:row];
    }else if(row%3 == 1){
        [self showCenterRow:row];
    }else{
        [self showRightRow:row];
    }
}
-(void)scrollTo:(NSNumber *)row{
    [self scrollToRow:[row integerValue]];
}
-(void)scrollToRow:(NSInteger)row{
    [self showRow:row];
    CGPoint offset = self.contentOffset;
    offset.x = row*widthCell;
//    if(row == 0) {//不知道为什么row=0的时候，不能上下滚动。这样改就可以了。待研究
//        offset.x = 1;
//    }
    self.contentOffset = offset;
}
-(void)showLeftRow:(NSInteger)rowLeft{
    if(rowLeft != rowForLeft){
        rowForLeft = rowLeft;
        if(cellLeft){
            if([cellLeft isKindOfClass:[HorizontalCell class]]){
                cellLeft.accessibilityLanguage = @"0";
                [self pushReusableCell:cellLeft];
            }
        }
        cellLeft = [_delegateHorizontal horizontalScrollView:self cellForRow:rowLeft];
        [viewLeft addSubview:cellLeft];
        CGFloat leftx =  rowLeft*widthCell;
        CGRect frameLeft = viewLeft.frame;
        frameLeft.origin.x = leftx;
        viewLeft.frame = frameLeft;
    }
}

-(void)showCenterRow:(NSInteger)rowCenter{
    if(rowCenter != rowForCenter){
        rowForCenter = rowCenter;
        if(cellCenter){
            if([cellCenter isKindOfClass:[HorizontalCell class]]){
                cellCenter.accessibilityLanguage = @"1";
                [self pushReusableCell:cellCenter];
            }
        }
        cellCenter = [_delegateHorizontal horizontalScrollView:self cellForRow:rowCenter];
        [viewCenter addSubview:cellCenter];
        CGFloat centerx = rowCenter*widthCell;
        CGRect frameCenter = viewCenter.frame;
        frameCenter.origin.x = centerx;
        viewCenter.frame = frameCenter;
    }

}
-(void)showRightRow:(NSInteger)rowRight{
    if(rowRight != rowForRight){
        rowForRight = rowRight;
        if(cellRight){
            if([cellRight isKindOfClass:[HorizontalCell class]]){
                cellRight.accessibilityLanguage = @"2";
                [self pushReusableCell:cellRight];
            }
        }
        cellRight = [_delegateHorizontal horizontalScrollView:self cellForRow:rowRight];
        [viewRight addSubview:cellRight];
        CGFloat rightx = rowRight*widthCell;
        CGRect frameRight = viewRight.frame;
        frameRight.origin.x = rightx;
        viewRight.frame = frameRight;
    }
}

-(void)reload{
    [self resetContentSize];
    [self scrollViewDidScroll:self];
}
-(HorizontalCell *)dequeueReusableCellWithIdentifier:(NSString *)CellIdentifier{
    HorizontalCell *horiCell;
    NSMutableSet *aCells = [self dCellsWithIndentifier:CellIdentifier];
//    NSLog(@"===================================");
    if(aCells.count > 0){
        horiCell = [aCells anyObject];
//         NSLog(@"acells = %@,index = %@",aCells,horiCell.accessibilityLanguage);
        [aCells removeObject:horiCell];
    }
//    NSLog(@"acells = %@",aCells);
    return horiCell;
}
-(void)pushReusableCell:(UIView *)cell{
    HorizontalCell *horiCell = (HorizontalCell *)cell;
    NSString *indentifier = horiCell.identifier;
    NSMutableSet *aCells = [self dCellsWithIndentifier:indentifier];
    [aCells addObject:horiCell];
}
-(NSMutableSet *)dCellsWithIndentifier:(NSString *)indentifier{
    NSMutableSet *aCells = dCells[indentifier];
    if(aCells == nil){
        aCells = [NSMutableSet set];
        dCells[indentifier] = aCells;
    }
    return aCells;
}

@end

@implementation HorizontalCell

-(id)initWithIndentifier:(NSString *)identifier{
    self = [super init];
    if (self){
        _identifier = identifier;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc == %@",[self class]);
}

@end
