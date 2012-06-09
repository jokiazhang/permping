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
#import "UploadPermResponse.h"
#import "PermActionResponse.h"

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
extern NSString *const kUserServiceOauthTokenSecretKey;
extern NSString *const kUserServiceOauthVerifierKey;

@interface Taglist_CloudService : NSObject 
{
    
} 

+ (NSString *)getTaglistHTTPURLBase;
+ (PermListResponse*)getPopularListWithRequestCount:(NSUInteger)count nextItemId:(NSInteger)nextId;
+ (CategoryListResponse*)getCategoryList;
+ (BoardListReponse*)getBoardListWithCategoryId:(NSString*)categoryId;
+ (PermListResponse*)getPermWithCategorydId:(NSString*)categorydId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;
+ (PermListResponse*)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count;
+ (PermListResponse*)getPermWithUserId:(NSString*)userId requestCount:(NSUInteger)count nextItemId:(NSInteger)nextId;
+ (PermListResponse*)getPermWithDate:(NSString*)date nextItemId:(NSInteger)nextId requestCount:(NSUInteger)count;
+ (UploadPermResponse*)uploadPermWithInfo:(PermModel*)permInfo;
+ (PermActionResponse*)likePermWithId:(NSString*)permId userId:(NSString*)userId;
+ (PermActionResponse*)commentPermWithId:(NSString*)permId userId:(NSString*)userId content:(NSString*)content;
+ (PermActionResponse*)repermWithId:(NSString*)permId userId:(NSString*)userId boardId:(NSString*)boardId description:(NSString*)desc;
+ (Taglist_CloudResponse*)createBoardWithInfo:(NSDictionary*)boardInfo;

// User service
+ (CreateAccountResponse*)createAccountWithUserInfo:(NSDictionary*)userInfo;
+ (UserProfileResponse*)loginWithUserInfo:(NSDictionary*)userInfo;
+ (UserProfileResponse*)getUserProfileWithId:(NSString*)userId;
+ (Taglist_CloudResponse*)logoutWithUserId:(NSString*)userId;
@end
