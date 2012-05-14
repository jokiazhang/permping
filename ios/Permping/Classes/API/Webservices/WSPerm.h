//
//  WSPerm.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"

@interface WSPerm : RemoteObject {
    NSString    *permId;
    NSString    *permName;
    NSString    *permDesc;
    NSString    *permImage;
    NSArray     *permComments;
}
@property (nonatomic, retain) NSString *permId;
@property (nonatomic, retain) NSString *permName;
@property (nonatomic, retain) NSString *permDesc;
@property (nonatomic, retain) NSString *permImage;
@property (nonatomic, retain) NSArray *permComments;
@end
