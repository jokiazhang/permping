//
//  BoardList_DataLoader.h
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardListReponse.h"

@interface BoardList_DataLoader : NSObject

- (BoardListReponse*)getBoardListWithCategoryId:(NSString*)categoryId;

@end
