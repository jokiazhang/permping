//
//  CreatePermScreen_DataLoader.m
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "CreatePermScreen_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation CreatePermScreen_DataLoader

- (UploadPermResponse *)uploadPerm:(PermModel *)permInfo
{
    return [Taglist_CloudService uploadPermWithInfo:permInfo];
}

@end
