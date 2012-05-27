//
//  CreateAccount_DataLoader.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateAccount_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation CreateAccount_DataLoader

- (CreateAccountResponse*)createAccountWithUserInfo:(NSDictionary*)userInfo {
    return [Taglist_CloudService createAccountWithUserInfo:userInfo];
}
@end
