//
//  Taglist_CloudPagingResponse.h
//  EyeconSocial
//
//  Created by PhongLe on 3/23/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"

@interface Taglist_CloudPagingResponse : Taglist_CloudResponse
{
    NSUInteger          startIndex;
    NSUInteger          totalResult;
    NSInteger           nextItemId;
}

@property (nonatomic, assign) NSUInteger        startIndex;
@property (nonatomic, assign) NSUInteger        totalResult;
@property (nonatomic, assign) NSInteger         nextItemId;

@end
