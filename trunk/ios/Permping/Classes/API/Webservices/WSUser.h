//
//  WSUser.h
//  Permping
//
//  Created by Andrew Duck on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"

@interface WSUser : RemoteObject {
    NSString *userId;
    NSString *userName;
    NSString *userAvatar;
    NSString *userStatus;
}
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userAvatar;
@property (nonatomic, retain) NSString *userStatus;
@end
