//
//  CarModel.h
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface PermModel : NSObject
{
    UserModel   *permUser;
    NSString    *permId;
    NSString    *permDesc;
    NSString    *permCategory;
    NSString    *permImage;
    NSString    *permRepinCount;
    NSString    *permLikeCount;
    NSString    *permCommentCount;
    
    NSMutableArray     *permComments;
    
}

@property (nonatomic, retain)   UserModel                   *permUser;
@property (nonatomic, copy)     NSString                    *permId;
@property (nonatomic, copy)     NSString                    *permDesc;
@property (nonatomic, copy)     NSString                    *permCategory;
@property (nonatomic, copy)     NSString                    *permImage; 
@property (nonatomic, copy)     NSString                    *permRepinCount;
@property (nonatomic, copy)     NSString                    *permLikeCount;
@property (nonatomic, copy)     NSString                    *permCommentCount;

@property (nonatomic, assign)   NSMutableArray                    *permComments;
 
@end
