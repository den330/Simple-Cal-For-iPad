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

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor yellowColor];
    self.searchBar.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.array = [[NSMutableArray alloc] init];
    [self grabInfo];
}

-(void)grabInfo{
    NSDictionary *dict = [self getDict];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"https://api.nutritionix.com/v1_1/search/" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *) responseObject;
        NSArray *hits = dic[@"hits"];
        for (NSDictionary *food in hits){
            NSDictionary *field = food[@"fields"];
            Food *fo = [[Food alloc] init];
            fo.brandName = field[@"brand-name"];
            fo.calorie = field[@"nf_calories"];
            fo.foodName = field[@"item_name"];
            fo.idNum = field[@"item_id"];
            NSString *qty = field[@"nf_serving_size_qty"];
            NSString *unit = field[@"nf_serving_size_unit"];
            NSString *str = [[NSString alloc] initWithFormat:@"%@ %@", qty, unit];
            if([str containsString:@"<null>"]){
                fo.unit = @"Unit Not Available";
            }else{
                fo.unit = str;
            }
            [self.array addObject:fo];
        }
        
        
        
        

        
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
