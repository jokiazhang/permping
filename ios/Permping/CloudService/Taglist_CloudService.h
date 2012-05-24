//
//  Taglist_CloudService.h
//  EyeconSocial
//
//  Created by PhongLe on 7/14/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PermListResponse.h"

@interface Taglist_CloudService : NSObject 
{
    
} 

+ (NSString *)getTaglistHTTPURLBase;
+ (PermListResponse *)getPopularListWithRequestCount:(NSUInteger)count nextItemId:(NSInteger)nextId;
@end
