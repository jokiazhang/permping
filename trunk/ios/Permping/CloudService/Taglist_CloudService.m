//
//  Taglist_CloudService.m
//  EyeconSocial
//
//  Created by PhongLe on 7/14/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudService.h" 
#import "Taglist_CloudDirectBodyRequest.h"
#import "Taglist_CloudResponse.h"
#import "Taglist_CloudRequestDispatcher.h"
#import "Taglist_CloudPagingRequest.h"
#import "Taglist_CloudPagingResponse.h"
#import "Configuration.h"
#import "Constants.h"
#import "AppData.h"

NSString *const kUserServiceTypeNormal = @"perm";
NSString *const kUserServiceTypeTwitter = @"twitter";
NSString *const kUserServiceTypeFacebook = @"Facebook";

NSString *const kUserServiceTypeKey = @"UserServiceTypeKey";
NSString *const kUserServiceOauthTokenKey = @"UserServiceOauthTokenKey";
NSString *const kUserServiceNameKey = @"UserServiceNameKey";
NSString *const kUserServiceUserNameKey = @"UserServiceUserNameKey";
NSString *const kUserServiceEmailKey = @"UserServiceEmailKey";
NSString *const kUserServicePasswordKey = @"UserServicePasswordKey";
NSString *const kUserServiceCPasswordKey = @"UserServiceCPasswordKey";

@implementation Taglist_CloudService

+ (NSString *)getTaglistHTTPURLBase
{
     return [Configuration getValueForKey:@"taglist.api.url.base"];
}

+ (PermListResponse *)getPopularListWithRequestCount:(NSUInteger)count nextItemId:(NSInteger)nextId
{
    Taglist_CloudPagingRequest *request = [[Taglist_CloudPagingRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/permservice/getpupolarperm"];
    
//    [NSString stringWithFormat:@"%@/api/social/activities/@me/@all", [Taglist_CloudService getTaglistHTTPURLBase]];
    
    [request addRequestCount:count];    
    
    if (nextId != -1) {
        [request addNextItemId:nextId];
    }
    
    PermListResponse *response = [[PermListResponse alloc] init];    
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

+ (CategoryListResponse*)getCategoryList {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/permservice/getcategories"];
    CategoryListResponse *response = [[CategoryListResponse alloc] init];
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
    return [response autorelease];
}

+ (BoardListReponse*)getBoardListWithCategoryId:(NSString *)categoryId {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/getboardswithcategoryid/%@", categoryId];
    BoardListReponse *response = [[BoardListReponse alloc] init];
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
    return [response autorelease];
}

+ (PermListResponse *)getPermWithBoardId:(NSString*)boardId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count { 
    Taglist_CloudPagingRequest *request = [[Taglist_CloudPagingRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/getpermwithboardid/%@", boardId];
    [request addRequestCount:count];
    if (nextId != -1) {
        [request addNextItemId:nextId];
    }
    PermListResponse *response = [[PermListResponse alloc] init];
    response.permFromBoard = YES;
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
    return [response autorelease];
}

+ (PermListResponse*)getPermWithUserId:(NSString*)userId requestCount:(NSUInteger)count nextItemId:(NSInteger)nextId {
    Taglist_CloudPagingRequest *request = [[Taglist_CloudPagingRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/getfollowingperm/%@", userId];
    [request addRequestCount:count];    
    if (nextId != -1) {
        [request addNextItemId:nextId];
    }
    
    PermListResponse *response = [[PermListResponse alloc] init];    
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

#pragma mark	-
#pragma mark		user services
#pragma mark	-

+ (CreateAccountResponse*)createAccountWithUserInfo:(NSDictionary *)userInfo {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/userservice/createaccount"];
    request.method = @"POST";
    [request addParameter:@"type" value:[userInfo valueForKey:kUserServiceTypeKey]];
    [request addParameter:@"oauth_token" value:[userInfo valueForKey:kUserServiceOauthTokenKey]];
    [request addParameter:@"name" value:[userInfo valueForKey:kUserServiceNameKey]];
    [request addParameter:@"username" value:[userInfo valueForKey:kUserServiceUserNameKey]];
    [request addParameter:@"email" value:[userInfo valueForKey:kUserServiceEmailKey]];
    [request addParameter:@"password" value:[userInfo valueForKey:kUserServicePasswordKey]];
    [request addParameter:@"cpassword" value:[userInfo valueForKey:kUserServiceCPasswordKey]];
    
    CreateAccountResponse *response = [[CreateAccountResponse alloc] init];    
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

+ (UserProfileResponse*)getUserProfileWithId:(NSString*)userId {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/userservice/getprofile/%@", userId];
    
    UserProfileResponse *response = [[UserProfileResponse alloc] init];    
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

@end
