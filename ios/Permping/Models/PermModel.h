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
    NSString    *permCategoryId;
    NSString    *permImage;
    NSString    *permRepinCount;
    NSString    *permLikeCount;
    NSString    *permCommentCount;
    NSString    *permUserlikeCount;
    NSMutableArray     *permComments;
    NSData          *fileData;
    
    NSString    *latitude;
    NSString    *longitude;
    NSString    *permDate;
    NSString    *permDateMessage;
}

@property (nonatomic, retain)   UserModel                   *permUser;
@property (nonatomic, copy)     NSString                    *permId;
@property (nonatomic, copy)     NSString                    *permDesc;
@property (nonatomic, copy)     NSString                    *permCategory;
@property (nonatomic, copy)     NSString                    *permCategoryId;
@property (nonatomic, copy)     NSString                    *permImage; 
@property (nonatomic, copy)     NSString                    *permRepinCount;
@property (nonatomic, copy)     NSString                    *permLikeCount;
@property (nonatomic, copy)     NSString                    *permCommentCount;
@property (nonatomic, copy)     NSString                    *permUserlikeCount;
@property (nonatomic, retain)   NSMutableArray              *permComments;
@property (nonatomic, retain)   NSData                      *fileData;
@property (nonatomic, copy)     NSString                    *latitude;
@property (nonatomic, copy)     NSString                    *longitude;
@property (nonatomic, copy)     NSString                    *permDate;
@property (nonatomic, copy)     NSString                    *permDateMessage;
 
@end
