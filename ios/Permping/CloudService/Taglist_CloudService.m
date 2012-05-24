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
@end
