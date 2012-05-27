//
//  CreateAccount_DataLoader.h
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateAccountResponse.h"

@interface CreateAccount_DataLoader : NSObject

- (CreateAccountResponse*)createAccountWithUserInfo:(NSDictionary*)userInfo;

@end
