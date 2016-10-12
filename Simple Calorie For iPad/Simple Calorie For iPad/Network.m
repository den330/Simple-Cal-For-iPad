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

-(instancetype)init{
    self.oddTimes = true;
    self.idKey1 = [[NSDictionary alloc] init];
    self.idKey1 = @{@"id": @"0a714183", @"key": @"67d0f5774ec4e02095a3cc1b36a5ccc8"};
    self.idKey2 = [[NSDictionary alloc] init];
    self.idKey2 = @{@"id": @"8b36dac9", @"key": @"c79b530ed299ec9f53d64be135311b09"};
    self.state = notYetBegun;
    return self;
}

-(void)grabInfo: (NSString *) str filterText: (NSString *) filterStr completionHandler: (void (^)(void)) block{
    self.state = Searching;
    block();
    NSDictionary *dict = [self getDict:str filterText:filterStr];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"https://api.nutritionix.com/v1_1/search/" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *) responseObject;
        NSArray *hits = dic[@"hits"];
        if((int)[hits count] == 0){
            self.state = NoResult;
            block();
            return;
        }
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
        self.state = searchSuccess;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block();
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.state = searchFail;
        NSLog(@"Fail");
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block();
        });
    }];
}

-(NSDictionary *)getDict: (NSString *) str filterText: (NSString *) filterStr{
    [self pickID];
    NSArray *array = @[@"nf_calories",@"item_name",@"brand_name",@"nf_serving_size_unit",@"nf_serving_size_qty",@"item_id"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: @{@"appId" : self.appID, @"appKey": self.appKey, @"offset": @0, @"limit": @50}];
    if ([filterStr  isEqual: @""]){
        dic[@"query"] = str;
    }else{
        dic[@"queries"] = @{@"item_name":str, @"brand_name": filterStr};
    }
    dic[@"fields"] = array;
    return dic;
}

-(void) pickID{
    if(self.oddTimes){
        self.appID = self.idKey1[@"id"];
        self.appKey = self.idKey1[@"key"];
    }else{
        self.appID = self.idKey2[@"id"];
        self.appKey = self.idKey2[@"key"];
    }
}

@end
