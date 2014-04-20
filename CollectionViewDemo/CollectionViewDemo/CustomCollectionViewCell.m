//
//  CustomCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 07/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell
//--------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleCell = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
        titleCell.font = [UIFont fontWithName:@"Helvetica" size:30];
        titleCell.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleCell];
        
        UIView* backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        self.backgroundView = backgroundView;
        
        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBGView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        self.selectedBackgroundView = selectedBGView;
    }
    return self;
}
//------------------------------------------------------------------------------------------------------------------------
- (id)mutableCopyWithZone:(NSZone *)zone
{
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
	CustomCollectionViewCell *cell = [[CustomCollectionViewCell allocWithZone:zone] init];
	return cell;
}
//------------------------------------------------------------------------------------------------------------------------
-(id) copyWithZone:(NSZone *)zone
{
    CustomCollectionViewCell* theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    theCopy.index = self.index;
    theCopy.frame = self.frame;
    
    return theCopy;
}
//--------------------------------------------------------------------------------------------------
#pragma mark - Setters/Getters
-(void)setIndex:(NSString*) index
{
    titleCell.text = index;
    _index = index;
}
//--------------------------------------------------------------------------------------------------

@end
