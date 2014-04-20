//
//  CCDropArea.m
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 19/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import "CCDropArea.h"
#import "Poof.h"

@interface CCDropArea ()

@property(nonatomic,strong) NSMutableArray *arrayOfAreas;
@property(nonatomic,strong) NSMutableArray *arrayOfDroppedViews;
@property(nonatomic,strong) NSMutableArray *arrayOfRemoveButtons;
@property(nonatomic,strong) NSMutableArray *indexPaths;
@property(nonatomic,assign) CGSize sizeOfDropArea;

@end

@implementation CCDropArea

#pragma mark - init Methods
- (id)initWithFrame:(CGRect)frame dropAreaSize:(CGSize) size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.sizeOfDropArea = size;
        _numberOfDropAreas = 0;
    }
    return self;
}
//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
-(void)initializeArrays
{
    [self.arrayOfRemoveButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.arrayOfDroppedViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.arrayOfAreas makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.arrayOfRemoveButtons = [[NSMutableArray alloc] initWithCapacity:self.numberOfDropAreas];
    self.arrayOfDroppedViews = [[NSMutableArray alloc] initWithCapacity:self.numberOfDropAreas];
    self.arrayOfAreas = [[NSMutableArray alloc] initWithCapacity:self.numberOfDropAreas];
    self.indexPaths = [[NSMutableArray alloc] initWithCapacity:self.numberOfDropAreas];
    
    float margin = round((self.frame.size.width-self.sizeOfDropArea.width*self.numberOfDropAreas)/(self.numberOfDropAreas-1));
    
    for(int i=0; i<self.numberOfDropAreas;i++){
        [self.indexPaths addObject:[NSNull null]];
        [self.arrayOfDroppedViews addObject:[NSNull null]];
        
        UIView *dropArea = [self createDropArea:[NSString stringWithFormat:@"%d",i]];
        dropArea.frame = CGRectMake(margin*i+self.sizeOfDropArea.width*i, round((self.frame.size.height-dropArea.frame.size.height)/2.0), dropArea.frame.size.width, dropArea.frame.size.height);
        [self addSubview:dropArea];
        [self.arrayOfAreas addObject:dropArea];
        
        UIView *removeView = [self createRemoveViewForDropAreaWithIndex:i];
        [self.arrayOfRemoveButtons addObject:removeView];
    }
}
//-------------------------------------------------------------------------------------------
-(UIView*)createRemoveViewForDropAreaWithIndex:(int)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.sizeOfDropArea.width, self.sizeOfDropArea.height);
    btn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:0.2];
    [btn addTarget:self action:@selector(removeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    return btn;
}
//-------------------------------------------------------------------------------------------
-(UIView*)createDropArea:(NSString*)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sizeOfDropArea.width, self.sizeOfDropArea.height)];
    view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.font = [UIFont fontWithName:@"Helvetica" size:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = [UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
}
//-------------------------------------------------------------------------------------------
-(void)removeButtonAction:(UIButton*)button
{
    int index = button.tag;
    [self removeViewAtIndex:index animated:YES];
}
//-------------------------------------------------------------------------------------------
-(void)removeViewAtIndex:(int)index animated:(BOOL)animated
{
    if(![[self.indexPaths objectAtIndex:index] isKindOfClass:NSIndexPath.class])
        return;
    
    UIView *removeBtn =  [self.arrayOfRemoveButtons objectAtIndex:index];
    [removeBtn removeFromSuperview];
    __weak UIView *droppedView = [self.arrayOfDroppedViews objectAtIndex:index];
     [self.arrayOfDroppedViews replaceObjectAtIndex:index withObject:[NSNull null]];
    NSIndexPath *indexPath = [self.indexPaths objectAtIndex:index];
    [self.indexPaths replaceObjectAtIndex:index withObject:[NSNull null]];
    
    if(animated){
            Poof *poof = [[Poof alloc] initWithCenter:droppedView.center];
            [[self.arrayOfAreas objectAtIndex:index] addSubview:poof];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                droppedView.alpha = 0.0;
            } completion:^(BOOL finished){
                [droppedView removeFromSuperview];
                if(self.delegate && [self.delegate respondsToSelector:@selector(dropArea:didRemoveViewWithIndexPath:)])
                    [self.delegate dropArea:self didRemoveViewWithIndexPath:indexPath];
            }];
        
    }else{
        [droppedView removeFromSuperview];
        if(self.delegate && [self.delegate respondsToSelector:@selector(dropArea:didRemoveViewWithIndexPath:)])
            [self.delegate dropArea:self didRemoveViewWithIndexPath:indexPath];
    }
    
}
//-------------------------------------------------------------------------------------------
#pragma mark - Property Methods
-(void)setNumberOfDropAreas:(int)numberOfDropAreas
{
    _numberOfDropAreas = numberOfDropAreas;
    [self initializeArrays];
}
//-------------------------------------------------------------------------------------------
#pragma mark - Public Methods
-(void)addView:(UIView*) view indexPath:(NSIndexPath*)indexPath  inDropAreaAtIndex:(int)index
{
    if([[self.indexPaths objectAtIndex:index] isKindOfClass:NSIndexPath.class]){
        [self removeViewAtIndex:index animated:NO];
    }
    
    [self.indexPaths replaceObjectAtIndex:index withObject:indexPath];
    
    [self.arrayOfDroppedViews replaceObjectAtIndex:index withObject:view];
    UIView *area = [self.arrayOfAreas objectAtIndex:index];
    view.center = [area convertPoint:area.center fromView:self];
    [area addSubview:view];
    view.backgroundColor = [UIColor redColor];
    
    UIView *button = [self.arrayOfRemoveButtons objectAtIndex:index];
   [area addSubview:button];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dropArea:didAddViewWithIndexPath:)])
        [self.delegate dropArea:self didAddViewWithIndexPath:indexPath];
}
//-------------------------------------------------------------------------------------------
-(void)removeViewInDropAreaAtIndex:(int)index
{
    [self removeViewAtIndex:index animated:YES];
}
//-------------------------------------------------------------------------------------------
-(void)removeViewInDropAreaWithIndexPath:(NSIndexPath*)indexPath
{
    int index = [self indexForViewWithIndexPath:indexPath];
    if(index != NSNotFound)
        [self removeViewInDropAreaAtIndex:index];
}
//-------------------------------------------------------------------------------------------
-(int)indexForViewWithIndexPath:(NSIndexPath*)indexPath
{
    for(int i=0; i<self.numberOfDropAreas; i++){
        NSIndexPath *anIndexPath = [self.indexPaths objectAtIndex:i];
        if([anIndexPath isKindOfClass:NSIndexPath.class] && [anIndexPath compare:indexPath]==NSOrderedSame)
            return i;
    }
    return NSNotFound;
}
//-------------------------------------------------------------------------------------------
-(CGPoint)centerOfDropAreaAtIndex:(int)index
{
    UIView *view = [self.arrayOfAreas objectAtIndex:index];
    return view.center;
}
//-------------------------------------------------------------------------------------------
-(NSIndexPath*)indexPathOfItemAtIndex:(int)index
{
    NSIndexPath *indexPath = [self.indexPaths objectAtIndex:index];
    if([indexPath isKindOfClass:NSIndexPath.class])
        return indexPath;
    return nil;
}
//-------------------------------------------------------------------------------------------
-(BOOL)isDroppedTheItemWithIndexPath:(NSIndexPath*) indexPath
{
    for(int i=0; i<self.numberOfDropAreas; i++){
        NSIndexPath *anIndexPath = [self.indexPaths objectAtIndex:i];
        if([anIndexPath isKindOfClass:NSIndexPath.class] && [anIndexPath compare:indexPath]==NSOrderedSame)
            return YES;
    }
    return NO;
}
//-------------------------------------------------------------------------------------------
-(int)indexOfAreaWhereTheViewIsDropped:(UIGestureRecognizer *)gestureRecognizer
{
    for (int i=0 ; i< self.numberOfDropAreas; i++){
        UIView *area = [self.arrayOfAreas objectAtIndex:i];
        if([area pointInside:[gestureRecognizer locationInView:area] withEvent:nil])
            return i;
    }
    
    return NSNotFound;
}
//-------------------------------------------------------------------------------------------
@end
