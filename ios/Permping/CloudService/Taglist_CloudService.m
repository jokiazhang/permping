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
#import "UploadPermRequest.h"
#import "UploadPermResponse.h"
#import "Utility.h"
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
    response.responseType = PermResponseTypePopular;
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

+ (PermListResponse*)getPermWithCategorydId:(NSString*)categorydId nextItemId:(NSInteger)nextId requestedCount:(NSUInteger)count {
    Taglist_CloudPagingRequest *request = [[Taglist_CloudPagingRequest alloc] init];
    NSLog(@"categorydId: %@", categorydId);
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/getpermwithcategoryid/%@", categorydId];
    [request addRequestCount:count];
    if (nextId != -1) {
        [request addNextItemId:nextId];
    }
    PermListResponse *response = [[PermListResponse alloc] init];
    response.responseType = PermResponseTypeFromBoard;
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
    response.responseType = PermResponseTypeFromBoard;
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
    return [response autorelease];
}

+ (PermListResponse*)getPermWithUserId:(NSString*)userId requestCount:(NSUInteger)count nextItemId:(NSInteger)nextId {
    Taglist_CloudPagingRequest *request = [[Taglist_CloudPagingRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/getfollowingperm/%@", userId];
    request.method = @"POST";
    [request addRequestCount:count];    
    if (nextId != -1) {
        [request addNextItemId:nextId];
    }
    
    PermListResponse *response = [[PermListResponse alloc] init];    
    response.responseType = PermResponseTypeFollowing;
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

+ (PermListResponse*)getPermWithDate:(NSString*)date nextItemId:(NSInteger)nextId requestCount:(NSUInteger)count{
    Taglist_CloudPagingRequest *request = [[Taglist_CloudPagingRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/getpermwithdate/%@", date];
    [request addRequestCount:count];    
    if (nextId != -1) {
        [request addNextItemId:nextId];
    }
    
    PermListResponse *response = [[PermListResponse alloc] init];    
    response.responseType = PermResponseTypeFollowing;
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

- (void)buildMultipartFormDataPostBody
{
#if DEBUG_FORM_DATA_REQUEST
	[self addToDebugBody:@"\r\n==== Building a multipart/form-data body ====\r\n"];
#endif
	
	
	
#if DEBUG_FORM_DATA_REQUEST
	[self addToDebugBody:@"==== End of multipart/form-data body ====\r\n"];
#endif
}

+ (UploadPermResponse*)uploadPermWithInfo:(PermModel*)permInfo {
    UploadPermRequest *request = [[UploadPermRequest alloc] init];
    request.method = @"POST";
    request.contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", UPLOAD_MULTIPART_BOUNDARY];
    
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/permservice/uploadperm"];
    
//    PermModel *perm = [permInfo objectForKey:@"perm"];
//    BoardModel *board = [permInfo objectForKey:@"board"];
//    NSData *fileData = [permInfo objectForKey:@"fileData"];
    
    [request addPartName:@"uid" contentType:@"text/html; charset=UTF-8" transferEncode:@"8bit" body:[[AppData getInstance].user.userId dataUsingEncoding:NSUTF8StringEncoding] filename:nil];
    [request addPartName:@"board" contentType:@"text/html; charset=UTF-8" transferEncode:@"8bit" body:[permInfo.permCategoryId dataUsingEncoding:NSUTF8StringEncoding] filename:nil];
    [request addPartName:@"board_desc" contentType:@"text/html; charset=UTF-8" transferEncode:@"8bit" body:[permInfo.permDesc dataUsingEncoding:NSUTF8StringEncoding] filename:nil];

    NSString *extType = [Utility getExtImageType:permInfo.fileData];
    if (extType != nil) {
        // get the current date
        NSDate *date = [NSDate date];
        
        // format it
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"HH:mm:ss zzz"];
        
        // convert it to a string
        NSString *dateString = [dateFormat stringFromDate:date];
        
        // free up memory
        [dateFormat release];
        
        [request addPartName:@"img" contentType:[NSString stringWithFormat:@"image/%@", extType] transferEncode:@"binary" body:permInfo.fileData filename:[NSString stringWithFormat:@"perm-%@.%@",dateString, extType]];
    }
    
    UploadPermResponse *response = [[UploadPermResponse alloc] init]; 
    [[Taglist_CloudRequestDispatcher getInstance] dispatchSimpleMultipartRequest:request response:response];
    [request release];
    
    return [response autorelease];
}

+ (PermActionResponse*)likePermWithId:(NSString*)permId userId:(NSString*)userId {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/permservice/like"];
    request.method = @"POST";
    [request addParameter:@"pid" value:permId];
    [request addParameter:@"uid" value:userId];
    
    PermActionResponse *response = [[PermActionResponse alloc] init];
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
    return [response autorelease];
}

+ (PermActionResponse*)commentPermWithId:(NSString *)permId userId:(NSString *)userId content:(NSString *)content {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/permservice/comment"];
    request.method = @"POST";
    [request addParameter:@"cmnt" value:content];
    [request addParameter:@"pid" value:permId];
    [request addParameter:@"uid" value:userId];
    
    PermActionResponse *response = [[PermActionResponse alloc] init];
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
    return [response autorelease];
}

+ (PermActionResponse*)repermWithId:(NSString*)permId userId:(NSString*)userId boardId:(NSString*)boardId description:(NSString*)desc {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/permservice/reperm"];
    request.method = @"POST";
    [request addParameter:@"pid" value:permId];
    [request addParameter:@"uid" value:userId];
    [request addParameter:@"board" value:boardId];
    [request addParameter:@"board_desc" value:desc];
    
    PermActionResponse *response = [[PermActionResponse alloc] init];
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
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

+ (UserProfileResponse*)loginWithUserInfo:(NSDictionary *)userInfo {
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingString:@"/userservice/login"];
    request.method = @"POST";
    [request addParameter:@"type" value:[userInfo valueForKey:kUserServiceTypeKey]];
    [request addParameter:@"oauth_token" value:[userInfo valueForKey:kUserServiceOauthTokenKey]];
    [request addParameter:@"email" value:[userInfo valueForKey:kUserServiceEmailKey]];
    [request addParameter:@"password" value:[userInfo valueForKey:kUserServicePasswordKey]];
    
    UserProfileResponse *response = [[UserProfileResponse alloc] init];    
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

+ (Taglist_CloudResponse*)logoutWithUserId:(NSString*)userId {
    ///userservice/logout/
    
    Taglist_CloudRequest *request = [[Taglist_CloudRequest alloc] init];
    request.requestURL = [SERVER_API stringByAppendingFormat:@"/userservice/logout/%@", userId];
    
    Taglist_CloudResponse *response = [[Taglist_CloudResponse alloc] init];    
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest: request response:response];
    [request release];
    
    return [response autorelease];
}

@end
