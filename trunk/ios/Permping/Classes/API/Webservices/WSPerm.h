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
    NSString    *permName;
    NSString    *permDesc;
    NSString    *permImage;
    NSString    *permCategory;
    NSArray     *permComments;
}
@property (nonatomic, retain) WSUser   *owner;
@property (nonatomic, retain) NSString *permId;
@property (nonatomic, retain) NSString *permName;
@property (nonatomic, retain) NSString *permDesc;
@property (nonatomic, retain) NSString *permCategory;
@property (nonatomic, retain) NSString *permImage;
@property (nonatomic, retain) NSArray *permComments;
@end
