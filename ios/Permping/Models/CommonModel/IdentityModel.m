//
//  IdentityModel.m
//  EyeconSocial
//
//  Created by PhongLe on 14/11/2011.
//  Copyright (c) 2011 Appo CO., LTD. All rights reserved.
//

#import "IdentityModel.h"

@implementation IdentityModel
@synthesize Id, name;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    self.Id = nil;
    self.name = nil;
    
    [super dealloc];
}

@end
