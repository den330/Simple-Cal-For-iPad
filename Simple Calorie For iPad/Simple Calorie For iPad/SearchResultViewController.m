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
    self.optionalField.delegate = self;
    UINib *foodNib = [UINib nibWithNibName:@"FoodBox" bundle:nil];
    UINib *noResultNib = [UINib nibWithNibName:@"NoResultBox" bundle:nil];
    UINib *loadingNib = [UINib nibWithNibName:@"LoadingBox" bundle:nil];
    UINib *failNib = [UINib nibWithNibName:@"FailBox" bundle:nil];
    UINib *initialNib = [UINib nibWithNibName:@"InitialBox" bundle:nil];
    [self.collectionView registerNib:foodNib forCellWithReuseIdentifier:@"FoodBox"];
    [self.collectionView registerNib:noResultNib forCellWithReuseIdentifier:@"NoResultBox"];
    [self.collectionView registerNib:loadingNib forCellWithReuseIdentifier:@"LoadingBox"];
    [self.collectionView registerNib:failNib forCellWithReuseIdentifier:@"FailBox"];
    [self.collectionView registerNib:initialNib forCellWithReuseIdentifier:@"InitialBox"];
    self.collectionView.contentInset = UIEdgeInsetsMake(30, 0, 100, 0);
    [self adBannerSet];
}

-(void)adBannerSet{
    self.bannerView.adSize = kGADAdSizeSmartBannerPortrait;
    self.bannerView.adUnitID = @"ca-app-pub-9661807512900472/4585702343";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch(self.net.state){
        case Searching:
        case NoResult:
        case searchFail:
        case notYetBegun: return 1;
        case searchSuccess: return [self.net.foodArray count];
    }
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
    NSString *filterStr = self.optionalField.text;
    if (![str  isEqual: @""]){
        [self.net grabInfo: str filterText: filterStr completionHandler:^{[self.collectionView reloadData];}];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cellReuse;
    switch(self.net.state){
        case searchSuccess:
        {
            cellReuse = [self.collectionView dequeueReusableCellWithReuseIdentifier: @"FoodBox" forIndexPath:indexPath];
            UILabel *name = [cellReuse viewWithTag:1];
            UILabel *calories = [cellReuse viewWithTag:3];
            UILabel *brandName = [cellReuse viewWithTag:2];
            Food *fo = [self.net.foodArray objectAtIndex:indexPath.row];
            name.text = fo.foodName;
            brandName.text = fo.brandName;
            double cal = [fo.calorie doubleValue];
            calories.text = [NSString stringWithFormat:@"%.02f Cal", cal];
            break;
        }
        case searchFail:
            
            cellReuse = [self getCell:@"FailBox" index:indexPath];
            break;
        
        case Searching:
            
        {
            cellReuse = [self getCell:@"LoadingBox" index:indexPath];
            UIActivityIndicatorView *spinner = [cellReuse viewWithTag:1000];
            [spinner startAnimating];
            break;
        }
        
        case notYetBegun:
            
            cellReuse = [self getCell:@"InitialBox" index:indexPath];
            break;
        case NoResult:
            
            cellReuse = [self getCell:@"NoResultBox" index:indexPath];
            break;
    }
    return cellReuse;
}

-(UICollectionViewCell *)getCell: (NSString *) str index: (NSIndexPath *) indexPath{
    UICollectionViewCell *cellReuse = [self.collectionView dequeueReusableCellWithReuseIdentifier: str forIndexPath:indexPath];
    return cellReuse;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBarSearchButtonClicked:self.searchBar];
    [self.optionalField resignFirstResponder];
    return NO;
}



@end
