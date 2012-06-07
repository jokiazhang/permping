//
//  CreateBoard_DataLoader.h
//  Permping
//
//  Created by MAC on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"

@interface CreateBoard_DataLoader : NSObject

- (Taglist_CloudResponse*)createBoardWithInfo:(NSDictionary*)boardInfo;

@end
