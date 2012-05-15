//
//  WSComment.h
//  Permping
//
//  Created by MAC on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"
@class WSUser;

@interface WSComment : RemoteObject {
    WSUser   *user;
    NSString *content;
}

@property (nonatomic, retain) WSUser *user;
@property (nonatomic, retain) NSString *content;

@end
