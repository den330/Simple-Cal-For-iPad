//
//  Network.h
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

@property NSMutableArray *foodArray;

@property bool oddTimes;

@property NSString *appID;

@property NSString *appKey;

@property NSDictionary *idKey1;

@property NSDictionary *idKey2;

typedef enum{
    notYetBegun,
    Searching,
    NoResult,
    searchFail,
    searchSuccess
}searchState;

@property (nonatomic) searchState state;

-(void)grabInfo: (NSString *) str filterText: (NSString *) filterStr completionHandler: (void (^)(void)) block;

@end
