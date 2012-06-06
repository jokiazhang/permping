//
//  CarScreen_DataLoader.m
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "FollowingScreen_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation FollowingScreen_DataLoader

- (PermListResponse *)getPopularFromNextItemId:(NSInteger)nextItemId requestedCount:(NSUInteger)count
{
    return [Taglist_CloudService getPopularListWithRequestCount:count nextItemId:nextItemId];
}

- (PermListResponse *)getPermWithCategorydId:(NSString*)categorydId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count {
    return [Taglist_CloudService getPermWithCategorydId:categorydId nextItemId:nextId requestedCount:count];
}

- (PermListResponse *)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count {
    return [Taglist_CloudService getPermWithBoardId:boardId nextItemId:nextId requestedCount:count];
}

- (PermListResponse*)getPermWithUserId:(NSString*)userId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count {
    return [Taglist_CloudService getPermWithUserId:userId requestCount:count nextItemId:nextId];
}

- (PermActionResponse*)likePermWithId:(NSString*)permId userId:(NSString*)userId {
    return [Taglist_CloudService likePermWithId:permId userId:userId];
}

- (PermActionResponse*)commentPermWithId:(NSString*)permId userId:(NSString*)userId content:(NSString*)content {
    return [Taglist_CloudService commentPermWithId:permId userId:userId content:content];
}

- (PermActionResponse*)repermWithId:(NSString*)permId userId:(NSString*)userId boardId:(NSString*)boardId description:(NSString*)desc {
    return [Taglist_CloudService repermWithId:permId userId:userId boardId:boardId description:desc];
}

@end
