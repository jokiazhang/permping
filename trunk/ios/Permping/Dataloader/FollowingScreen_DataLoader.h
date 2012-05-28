//
//  CarScreen_DataLoader.h
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermListResponse.h"

@interface FollowingScreen_DataLoader : NSObject
{

}

- (PermListResponse *)getPopularFromNextItemId:(NSInteger)nextItemId requestedCount:(NSUInteger)count;

- (PermListResponse *)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;

- (PermListResponse*)getPermWithUserId:(NSString*)userId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;

@end
