//
//  ViewController.m
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/8.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import "SearchResultViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Food.h"
#import <UIKit/UIKit.h>
#import "Network.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.net = [[Network alloc] init];
    self.collectionView.backgroundColor = [UIColor yellowColor];
    self.searchBar.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"FoodBox" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"FoodBox"];
    self.collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.net.foodArray count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(320,120);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSString *str = searchBar.text;
    [self.net grabInfo: str completionHandler:^{[self.collectionView reloadData];}];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cellReuse = [self.collectionView dequeueReusableCellWithReuseIdentifier: @"FoodBox" forIndexPath:indexPath];
    UILabel *name = [cellReuse viewWithTag:1];
    UILabel *calories = [cellReuse viewWithTag:3];
    UILabel *brandName = [cellReuse viewWithTag:2];
    Food *fo = [self.net.foodArray objectAtIndex:indexPath.row];
    name.text = fo.foodName;
    brandName.text = fo.brandName;
    double cal = [fo.calorie doubleValue];
    calories.text = [NSString stringWithFormat:@"%.02f Cal", cal];
    return cellReuse;
}




@end
