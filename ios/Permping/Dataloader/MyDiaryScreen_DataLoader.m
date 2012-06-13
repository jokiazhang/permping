//
//  MyDiaryScreen_DataLoader.m
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "MyDiaryScreen_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation MyDiaryScreen_DataLoader

- (PermListResponse *)getPermWithDate:(NSString *)date nextItemId:(NSInteger)nextItemId requestedCount:(NSUInteger)count
{
    return [Taglist_CloudService getPermWithDate:date nextItemId:nextItemId requestCount:count];
}

- (PermListResponse*)getPermWithMonth:(NSString*)month forUserId:(NSString*)userId {
    return [Taglist_CloudService getPermWithMonth:month forUserId:userId];
}
@end
