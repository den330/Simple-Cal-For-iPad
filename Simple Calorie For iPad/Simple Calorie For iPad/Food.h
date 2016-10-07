//
//  Food.h
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/18.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property (strong, nonatomic) NSString* foodName;
@property (strong, nonatomic) NSString* brandName;
@property (strong, nonatomic) NSString* unit;
@property (strong, nonatomic) NSNumber* calorie;
@property (strong, nonatomic) NSNumber* idNum;

@end
