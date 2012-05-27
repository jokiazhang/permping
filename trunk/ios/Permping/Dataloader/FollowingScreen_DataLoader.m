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

- (PermListResponse *)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count {
    return [Taglist_CloudService getPermWithBoardId:boardId nextItemId:nextId requestedCount:count];
}
@end
