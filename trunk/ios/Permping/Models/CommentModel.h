//
//  CommentModel.h
//  Permping
//
//  Created by Phong Le on 5/24/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface CommentModel : NSObject
{
    UserModel   *commentUser;
    NSString    *content;
}

@property (nonatomic, retain)   UserModel                   *commentUser;
@property (nonatomic, copy)     NSString                    *content;

@end
