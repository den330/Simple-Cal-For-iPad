//
//  ViewController.m
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/8.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import "SearchResultViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor yellowColor];
    self.searchBar.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    NSDictionary *dict = [self getDict];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"https://api.nutritionix.com/v1_1/search/" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success");
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail");
    }];
    

}

                    
                                      
                                      
                                      
                                      
    
-(NSDictionary *)getDict{
    NSArray *array = @[@"nf_calories",@"item_name",@"brand_name",@"nf_serving_size_unit",@"nf_serving_size_qty",@"item_id"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: @{@"appId" : @"8b36dac9", @"appKey": @"c79b530ed299ec9f53d64be135311b09", @"query": @"Ham", @"offset": @0, @"limit": @50}];
    dic[@"fields"] = array;
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cellReuse = [self.collectionView dequeueReusableCellWithReuseIdentifier: @"cellReuse" forIndexPath:indexPath];
    return cellReuse;
}




@end
