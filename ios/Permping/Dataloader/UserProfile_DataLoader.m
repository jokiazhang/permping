//
//  UserProfile_DataLoader.m
//  Permping
//
//  Created by MAC on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfile_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation UserProfile_DataLoader

- (UserProfileResponse*)getUserProfileWithId:(NSString*)userId {
    return [Taglist_CloudService getUserProfileWithId:userId];
}

@end
