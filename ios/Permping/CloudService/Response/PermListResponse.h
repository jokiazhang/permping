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

@interface PermListResponse : Taglist_CloudPagingResponse
{
    NSMutableArray          *permList;
    NSMutableArray          *permCommentList;
    PermModel               *currentPerm;
    CommentModel            *currentComment;
    UserModel               *currentUser;
}

- (NSArray *)getResponsePermList;
@end
