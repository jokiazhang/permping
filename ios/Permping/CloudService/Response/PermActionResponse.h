//
//  PermActionResponse.h
//  Permping
//
//  Created by MAC on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"
#import "UserModel.h"
#import "CommentModel.h"

@interface PermActionResponse : Taglist_CloudResponse {
    NSString        *status;
    
    // like
    NSString        *totalLikes;
    
    // comment
    NSString        *totalComment;
    NSString        *commentId;
    NSString        *permId;
    UserModel       *currentUser;
    CommentModel    *currentComment;
}
@property (nonatomic, retain, readonly) NSString *totalLikes;
@property (nonatomic, retain, readonly) NSString *status;

@property (nonatomic, retain, readonly) NSString *totalComment;
@property (nonatomic, retain, readonly) NSString *commentId;
@property (nonatomic, retain, readonly) NSString *permId;
@property (nonatomic, retain, readonly) CommentModel *currentComment;
@end
