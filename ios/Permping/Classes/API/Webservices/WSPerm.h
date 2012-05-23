//
//  WSPerm.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"
@class WSUser;

@interface WSPerm : RemoteObject {
    WSUser      *owner;
    NSString    *permId;
    NSString    *permOwnerComment;
    NSString    *permDesc;
    NSString    *permImage;
    NSString    *permCategory;
    NSString    *permStatus;
    NSString    *permRepinCount;
    NSString    *permLikeCount;
    NSString    *permCommentCount;
    NSArray     *permComments;

}
@property (nonatomic, retain) WSUser   *owner;
@property (nonatomic, retain) NSString *permId;
@property (nonatomic, retain) NSString *permOwnerComment;
@property (nonatomic, retain) NSString *permDesc;
@property (nonatomic, retain) NSString *permStatus;
@property (nonatomic, retain) NSString *permCategory;
@property (nonatomic, retain) NSString *permImage;
@property (nonatomic, retain) NSString *permRepinCount;
@property (nonatomic, retain) NSString *permLikeCount;
@property (nonatomic, retain) NSString *permCommentCount;
@property (nonatomic, retain) NSArray *permComments;
@end
