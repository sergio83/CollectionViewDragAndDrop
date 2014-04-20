//
//  CCDropArea.h
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 19/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCDropArea;

@protocol CCDropAreaDelegate <NSObject>
-(void)dropArea:(CCDropArea*) dropArea didRemoveViewWithIndexPath:(NSIndexPath*)indexPath;
-(void)dropArea:(CCDropArea*) dropArea didAddViewWithIndexPath:(NSIndexPath*)indexPath;
@end

@interface CCDropArea : UIView

@property(nonatomic,assign) int numberOfDropAreas;
@property(nonatomic,unsafe_unretained) id<CCDropAreaDelegate> delegate;

- (id)initWithFrame:(CGRect)frame dropAreaSize:(CGSize) size;

-(void)addView:(UIView*) view indexPath:(NSIndexPath*)indexPath  inDropAreaAtIndex:(int)index;
-(void)removeViewInDropAreaAtIndex:(int)index;
-(void)removeViewInDropAreaWithIndexPath:(NSIndexPath*)indexPath;

-(CGPoint)centerOfDropAreaAtIndex:(int)index;
-(NSIndexPath*)indexPathOfItemAtIndex:(int)index;
-(int)indexForViewWithIndexPath:(NSIndexPath*)indexPath;
-(BOOL)isDroppedTheItemWithIndexPath:(NSIndexPath*) indexPath;
-(int)indexOfAreaWhereTheViewIsDropped:(UIGestureRecognizer *)gestureRecognizer;

@end
