//
//  UserProfileResponse.h
//  Permping
//
//  Created by MAC on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"
#import "UserProfileModel.h"
#import "BoardModel.h"

@interface UserProfileResponse : Taglist_CloudResponse {
    NSMutableArray          *boardList;
    BoardModel              *currentBoard;
    UserProfileModel        *currentUser;
    BOOL                    followed;
}
@property (nonatomic, readonly, getter = isFollowed) BOOL followed;
- (UserProfileModel*)getUserProfile;
@end
