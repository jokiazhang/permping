//
//  Taglist_FeedListResponse.h
//  EyeconSocial
//
//  Created by Phong Le on 4/10/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudPagingResponse.h"
#import "PermModel.h"
#import "CommentModel.h"
#import "UserModel.h"

typedef enum {
    PermResponseTypePopular = 0,
    PermResponseTypeFromBoard,
    PermResponseTypeFollowing
}PermResponseType;

@interface PermListResponse : Taglist_CloudPagingResponse
{
    NSMutableArray          *permList;
    NSMutableArray          *permCommentList;
    PermModel               *currentPerm;
    CommentModel            *currentComment;
    UserModel               *currentUser;
    
    PermResponseType        responseType;
}
@property (nonatomic, assign) PermResponseType responseType;
- (NSArray *)getResponsePermList;
@end
