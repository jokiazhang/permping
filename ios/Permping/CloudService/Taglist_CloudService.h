//
//  Taglist_CloudService.h
//  EyeconSocial
//
//  Created by PhongLe on 7/14/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermListResponse.h"
#import "CategoryListResponse.h"
#import "BoardListReponse.h"
#import "CreateAccountResponse.h"
#import "UserProfileResponse.h"

extern NSString *const kUserServiceTypeNormal;
extern NSString *const kUserServiceTypeTwitter;
extern NSString *const kUserServiceTypeFacebook;

extern NSString *const kUserServiceTypeKey;
extern NSString *const kUserServiceOauthTokenKey;
extern NSString *const kUserServiceNameKey;
extern NSString *const kUserServiceUserNameKey;
extern NSString *const kUserServiceEmailKey;
extern NSString *const kUserServicePasswordKey;
extern NSString *const kUserServiceCPasswordKey;

@interface Taglist_CloudService : NSObject 
{
    
} 

+ (NSString *)getTaglistHTTPURLBase;
+ (PermListResponse *)getPopularListWithRequestCount:(NSUInteger)count nextItemId:(NSInteger)nextId;
+ (CategoryListResponse*)getCategoryList;
+ (BoardListReponse*)getBoardListWithCategoryId:(NSString*)categoryId;
+ (PermListResponse *)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;

// User service
+ (CreateAccountResponse*)createAccountWithUserInfo:(NSDictionary*)userInfo;
+ (UserProfileResponse*)getUserProfileWithId:(NSString*)userId;
@end
