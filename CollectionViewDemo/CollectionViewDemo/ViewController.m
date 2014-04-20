//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by Sergio Cirasa on 07/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import "ViewController.h"


static NSString *MyCellID = @"CustomCollectionViewCell";

@interface ViewController ()
{
    NSArray *datasource;
}

@property(nonatomic,strong)  UICollectionView *collectionView;
@property(nonatomic,strong)  CCDragContentView *contentView;

@end
//--------------------------------------------------------------------------------------------------

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumInteritemSpacing = 10; // Distancia entre items
    flow.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0); //Margenes de la seccion
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:MyCellID];
    [self.collectionView setAllowsMultipleSelection:YES];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.contentView = [[CCDragContentView alloc] initWithFrame:self.view.bounds];
    self.contentView.delegate = self;
    self.contentView.collectionView = self.collectionView;
    [self.view addSubview:self.contentView ];

    datasource = [self createDataSource];
}
//--------------------------------------------------------------------------------------------------
-(NSArray*)createDataSource{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:12];
    
    for(int section=0;section<50;section++){
            [sections addObject:[NSString stringWithFormat:@"%d",section]];
    }

    return sections;
}
//--------------------------------------------------------------------------------------------------
#pragma mark - CCDragContentViewDelegate
-(void)dragContentView:(CCDragContentView*) content didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

}
//--------------------------------------------------------------------------------------------------
-(void)dragContentView:(CCDragContentView*) content didDeselectItemAtIndexPath:(NSIndexPath*)indexPath
{

}
//--------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell* newCell = (CustomCollectionViewCell*) [self.collectionView dequeueReusableCellWithReuseIdentifier:MyCellID
                                                                           forIndexPath:indexPath];
    
    newCell.index = [datasource objectAtIndex:indexPath.row];
    newCell.selected = [self.contentView isSelectItemAtIndexPath:indexPath];
    return newCell;
}
//--------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [datasource count];
}
//--------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//--------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
//--------------------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
//--------------------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
//--------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth, kCellHeight);
}

@end

