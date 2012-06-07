//
//  CreateBoard_DataLoader.m
//  Permping
//
//  Created by MAC on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateBoard_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation CreateBoard_DataLoader

- (Taglist_CloudResponse*)createBoardWithInfo:(NSDictionary*)boardInfo {
    return [Taglist_CloudService createBoardWithInfo:boardInfo];
}

@end
