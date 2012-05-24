//
//  Taglist_CloudDirectBodyRequest.h
//  EyeconSocial
//
//  Created by PhongLe on 4/10/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudRequest.h"

@interface Taglist_CloudDirectBodyRequest : Taglist_CloudRequest
{
    NSString *requestBody;
}
@property (nonatomic, copy) NSString        *requestBody;
@end
