//
//  CCDragContentView.h
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 19/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDropArea.h"

@class CCDragContentView;

@protocol CCDragContentViewDelegate <NSObject>
-(void)dragContentView:(CCDragContentView*) content didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
-(void)dragContentView:(CCDragContentView*) content didDeselectItemAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface CCDragContentView : UIView <CCDropAreaDelegate>
{

}

@property(nonatomic,unsafe_unretained) id<CCDragContentViewDelegate> delegate;
@property(nonatomic,strong)UICollectionView *collectionView;

-(BOOL)isSelectItemAtIndexPath:(NSIndexPath*) indexPath;

@end
