//
//  Network.m
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import "Network.h"
#import <AFNetworking/AFNetworking.h>
#import "Food.h"




@implementation Network

-(void)grabInfo: (NSString *) str completionHandler: (void (^)(void)) block{
    NSDictionary *dict = [self getDict: str];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"https://api.nutritionix.com/v1_1/search/" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *) responseObject;
        NSArray *hits = dic[@"hits"];
        self.foodArray = [[NSMutableArray alloc] init];
        for (NSDictionary *food in hits){
            NSDictionary *field = food[@"fields"];
            Food *fo = [[Food alloc] init];
            fo.brandName = field[@"brand_name"];
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
            [self.foodArray addObject:fo];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block();
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail");
    }];
}

-(NSDictionary *)getDict: (NSString *) str{
    NSArray *array = @[@"nf_calories",@"item_name",@"brand_name",@"nf_serving_size_unit",@"nf_serving_size_qty",@"item_id"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: @{@"appId" : @"8b36dac9", @"appKey": @"c79b530ed299ec9f53d64be135311b09", @"query": str, @"offset": @0, @"limit": @50}];
    dic[@"fields"] = array;
    return dic;
}

@end
