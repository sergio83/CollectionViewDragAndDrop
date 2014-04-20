//
//  CCDragContentView.m
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 19/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import "CCDragContentView.h"

#define kDropAreaSize CGSizeMake(80, 80)
#define kContentDropAreaHeight 150.0
#define kNumberOfDropAreas 3

@interface CCDragContentView ()
    @property(nonatomic,strong) UICollectionViewCell* draggedCell;
    @property(nonatomic,strong) NSIndexPath *draggedIndexPath;
    @property(nonatomic,assign) CGPoint initCenterOfDraggedCell;
    @property(nonatomic,strong) CCDropArea* dropArea;
@end

@implementation CCDragContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
//----------------------------------------------------------------------------------------
- (void)setup
{
    // set up gestures
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    [self addGestureRecognizer:panGesture];
    
    self.dropArea = [[CCDropArea alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kContentDropAreaHeight) dropAreaSize:kDropAreaSize];
    [self addSubview:self.dropArea];
    self.dropArea.numberOfDropAreas = kNumberOfDropAreas;
    self.dropArea.delegate = self;
}
//----------------------------------------------------------------------------------------
#pragma mark - Property Methods
-(void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;
    _collectionView.frame = CGRectMake(0, self.dropArea.frame.size.height + self.dropArea.frame.origin.y, self.frame.size.width, self.frame.size.height-self.dropArea.frame.size.height + self.dropArea.frame.origin.y);
    [self addSubview:_collectionView];
}
//----------------------------------------------------------------------------------------
#pragma mark - CCDropAreaDelegate
-(void)dropArea:(CCDropArea*) dropArea didRemoveViewWithIndexPath:(NSIndexPath*)indexPath
{
    [self deselectItemAtIndex:indexPath];
}
//----------------------------------------------------------------------------------------
-(void)dropArea:(CCDropArea*) dropArea didAddViewWithIndexPath:(NSIndexPath*)indexPath
{
    [self selectItemAtIndex:indexPath];
}
#pragma mark - UIGestureRecognizer
//----------------------------------------------------------------------------------------
- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self startDragging:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self doDrag:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self stopDragging:gestureRecognizer];
            break;
        default:
            break;
    }
}
#pragma mark Helper methods for dragging
//----------------------------------------------------------------------------------------
-(void)releaseDragAndDrop
{
    [self.draggedCell removeFromSuperview];
    self.draggedCell = nil;
    self.draggedIndexPath = nil;
    self.initCenterOfDraggedCell = CGPointZero;
}
//----------------------------------------------------------------------------------------
- (void)startDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint pointInSrc = [gestureRecognizer locationInView:self.collectionView];
    if([self.collectionView pointInside:pointInSrc withEvent:nil]){
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:pointInSrc];
        
        if(![self.dropArea isDroppedTheItemWithIndexPath:indexPath])
            [self startDraggingItemWithIndexPath:indexPath];
    }
}
//----------------------------------------------------------------------------------------
- (void)startDraggingItemWithIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell =  [self.collectionView cellForItemAtIndexPath:indexPath];
    
    if(cell != nil){
        CGPoint origin = cell.frame.origin;
        origin.x += (self.collectionView.frame.origin.x - self.collectionView.contentOffset.x);
        origin.y += (self.collectionView.frame.origin.y - self.collectionView.contentOffset.y);
        
        self.initCenterOfDraggedCell = CGPointMake(cell.center.x+self.collectionView.frame.origin.x- self.collectionView.contentOffset.x, cell.center.y+self.collectionView.frame.origin.y- self.collectionView.contentOffset.y);
        self.draggedIndexPath = indexPath;
        
        [self selectItemAtIndex:indexPath];
        [self initDraggedCellWithCell:cell atPoint:origin];
    }
}
//----------------------------------------------------------------------------------------
- (void)initDraggedCellWithCell:(UICollectionViewCell*)cell atPoint:(CGPoint)point
{
    if(self.draggedCell != nil){
        [self.draggedCell removeFromSuperview];
        self.draggedCell = nil;
    }
    
    self.draggedCell = [cell copy];
    self.draggedCell.frame = CGRectMake(point.x, point.y, cell.frame.size.width, cell.frame.size.height);;
    [self addSubview:self.draggedCell];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.draggedCell.transform = CGAffineTransformScale(self.draggedCell.transform, 1.2, 1.2);
    } completion:^(BOOL finished){
    }];
}
//----------------------------------------------------------------------------------------
- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(self.draggedCell != nil){
        CGPoint translation = [gestureRecognizer translationInView:[self.draggedCell superview]];
        [self.draggedCell setCenter:CGPointMake([self.draggedCell center].x + translation.x,[self.draggedCell center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[self.draggedCell superview]];
    }
}
//----------------------------------------------------------------------------------------
- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(self.draggedCell != nil){
        
        if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
            int dropIndex = [self.dropArea indexOfAreaWhereTheViewIsDropped:gestureRecognizer];
            
            if(dropIndex==NSNotFound)
                [self returnDraggedCellToOrigin];
            else [self dropCellInAreaWithIndex:dropIndex];
            
        }else{
            [self returnDraggedCellToOrigin];
        }
    }
}
//--------------------------------------------------------------------------------------------------
-(void)dropCellInAreaWithIndex:(int)index
{
    CGPoint center = [self.dropArea centerOfDropAreaAtIndex:index];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.draggedCell.transform = CGAffineTransformIdentity;
        self.draggedCell.center = CGPointMake(center.x+self.dropArea.frame.origin.x, center.y+self.dropArea.frame.origin.y);
    } completion:^(BOOL finished){
        [self.dropArea addView:[self.draggedCell copy] indexPath:self.draggedIndexPath inDropAreaAtIndex:index];
        [self releaseDragAndDrop];
    }];
}
//--------------------------------------------------------------------------------------------------
-(void)returnDraggedCellToOrigin
{
    [self.dropArea removeViewInDropAreaWithIndexPath:self.draggedIndexPath];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.draggedCell.center = self.initCenterOfDraggedCell;
        self.draggedCell.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [self deselectItemAtIndex:self.draggedIndexPath];
        [self releaseDragAndDrop];
    }];
}
//--------------------------------------------------------------------------------------------------
-(void)selectItemAtIndex:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dragContentView:didSelectItemAtIndexPath:)])
        [self.delegate dragContentView:self didSelectItemAtIndexPath:indexPath];
}
//--------------------------------------------------------------------------------------------------
-(void)deselectItemAtIndex:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.collectionView reloadData];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dragContentView:didDeselectItemAtIndexPath:)])
        [self.delegate dragContentView:self didDeselectItemAtIndexPath:indexPath];
}
//--------------------------------------------------------------------------------------------------
#pragma mark - Public Methods
-(BOOL)isSelectItemAtIndexPath:(NSIndexPath*) indexPath
{
    return [self.dropArea isDroppedTheItemWithIndexPath:indexPath];
}
//--------------------------------------------------------------------------------------------------
@end
