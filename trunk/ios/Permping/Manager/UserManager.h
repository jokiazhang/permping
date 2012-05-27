//
//  UserManager.h
//  Permping
//
//  Created by Phong Le on 5/24/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserManager : NSObject {
    UserModel   *currentUser;
}
+ (UserManager *)getInstance;

@end
