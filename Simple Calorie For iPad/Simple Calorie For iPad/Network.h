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

-(void)grabInfo: (NSString *) str completionHandler: (void (^)(void)) block;

@end
