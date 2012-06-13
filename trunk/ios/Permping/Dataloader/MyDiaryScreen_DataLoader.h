//
//  MyDiaryScreen_DataLoader.h
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermListResponse.h"
@interface MyDiaryScreen_DataLoader : NSObject

- (PermListResponse *)getPermWithDate:(NSString *)date nextItemId:(NSInteger)nextItemId requestedCount:(NSUInteger)count;

- (PermListResponse*)getPermWithMonth:(NSString*)month forUserId:(NSString*)userId;

@end
