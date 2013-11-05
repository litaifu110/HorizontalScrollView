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
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc == %@",[self class]);
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

-(void)initProperty{
    widthCell = self.frame.size.width;
    heightCell = self.frame.size.height;
    CGRect frameLeft = viewLeft.frame;
    CGRect frameRight = viewRight.frame;
    frameLeft.size.width = widthCell;
    frameLeft.size.height = heightCell;
    frameRight.size.width = widthCell;
    frameRight.size.height = heightCell;
    frameRight.origin.x = widthCell; //这里不设置的画，会盖住viewLeft
    viewLeft.frame = frameLeft;
    viewRight.frame = frameRight;
}
-(void)resetContentSize{
    NSInteger num = [_delegateHorizontal numbersOfRowsInHorizontalScrollView:self];
    CGSize size = CGSizeMake(widthCell * num + 0.5, heightCell);
    self.contentSize = size; 
}
//初始化一些必须的组件
-(void) initUI{
    _initIndex = 0;
    self.pagingEnabled = YES;
    dCells = [NSMutableDictionary dictionary];
    rowForLeft = -1;
    rowForRight = -1;
    viewLeft = [[UIView alloc] init];
    viewRight = [[UIView alloc] init];
//    [viewRight setHidden:YES];
    [self addSubview:viewLeft];
    [self addSubview:viewRight];
}

//外部可引用的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger rowLeft,rowRight;
    NSInteger left = fmod(floor(x/widthCell), 2);
    if(left < 0){
        return;
    }
    rowLeft = floor(x/widthCell);
    rowRight = rowLeft + 1;
    if(rowRight >= [_delegateHorizontal numbersOfRowsInHorizontalScrollView:self]){
        return;
    }
    [self showRow:rowLeft];
    [self showRow:rowRight];
}
-(void)showRow:(NSInteger)row{
    if(row%2 == 0){
        [self showLeftRow:row];
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
    offset.x = row*widthCell ;
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
-(void)showRightRow:(NSInteger)rowRight{
    if(rowRight != rowForRight){
        rowForRight = rowRight;
        if(cellRight){
            if([cellRight isKindOfClass:[HorizontalCell class]]){
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
    if(aCells.count > 0){
        horiCell = [aCells anyObject];
        [aCells removeObject:horiCell];
    }
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
