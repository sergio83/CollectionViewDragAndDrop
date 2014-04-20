//
//  CustomCollectionViewCell.h
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 07/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellWidth 50.0
#define kCellHeight 50.0

@interface CustomCollectionViewCell : UICollectionViewCell<NSCopying,NSMutableCopying>
{
    UILabel *titleCell;
}

@property(nonatomic, strong) NSString *index;

@end
