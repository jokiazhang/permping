//
//  WSComment.h
//  Permping
//
//  Created by MAC on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"

@interface WSComment : RemoteObject {
    NSString *userId;
    NSString *userName;
    NSString *userAvatar;
    NSString *content;
}
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userAvatar;
@property (nonatomic, retain) NSString *content;
@end
