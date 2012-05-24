//
//  YogoFlyModel.h
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
{
    NSString *userId;
    NSString *userName;
    NSString *userAvatar;
    NSString *userStatus;
}

@property (nonatomic, copy)     NSString                    *userId;
@property (nonatomic, copy)     NSString                    *userName; 
@property (nonatomic, copy)     NSString                    *userAvatar;
@property (nonatomic, copy)     NSString                    *userStatus;
@end
