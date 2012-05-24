//
//  Taglist_CloudPagingRequest.h
//  EyeconSocial
//
//  Created by PhongLe on 3/23/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudRequest.h"

@interface Taglist_CloudPagingRequest : Taglist_CloudRequest
{
 
}
 
- (void)addRequestCount:(NSUInteger)count;
- (void)addNextItemId:(NSUInteger)nextItemId;
@end
