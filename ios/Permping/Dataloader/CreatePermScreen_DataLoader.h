//
//  CreatePermScreen_DataLoader.h
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadPermResponse.h"
#import "PermModel.h"
#import "BoardModel.h"
@interface CreatePermScreen_DataLoader : NSObject

- (UploadPermResponse *)uploadPerm:(NSDictionary *)permInfo;
@end
