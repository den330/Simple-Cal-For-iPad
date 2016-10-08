//
//  ViewController.h
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/8.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Network.h"


@interface SearchResultViewController : UIViewController <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray  *array;

@property (strong, nonatomic) Network *net;

@end

