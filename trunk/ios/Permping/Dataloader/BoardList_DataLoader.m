//
//  BoardList_DataLoader.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardList_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation BoardList_DataLoader

- (BoardListReponse*)getBoardListWithCategoryId:(NSString*)categoryId {
    return [Taglist_CloudService getBoardListWithCategoryId:categoryId];
}

@end
