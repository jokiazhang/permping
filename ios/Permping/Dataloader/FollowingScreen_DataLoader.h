//
//  CarScreen_DataLoader.h
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermListResponse.h"
#import "PermActionResponse.h"

@interface FollowingScreen_DataLoader : NSObject

- (PermListResponse *)getPopularFromNextItemId:(NSInteger)nextItemId requestedCount:(NSUInteger)count;

- (PermListResponse *)getPermWithCategorydId:(NSString*)categorydId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;

- (PermListResponse *)getPermWithBoardId:(NSString*)boardId userId:(NSString*)userId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;

- (PermListResponse*)getPermWithUserId:(NSString*)userId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;

- (PermActionResponse*)likePermWithId:(NSString*)permId userId:(NSString*)userId;

- (PermActionResponse*)commentPermWithId:(NSString*)permId userId:(NSString*)userId content:(NSString*)content;

- (PermActionResponse*)repermWithId:(NSString*)permId userId:(NSString*)userId boardId:(NSString*)boardId description:(NSString*)desc;

@end
