//
//  IdentityModel.h
//  EyeconSocial
//
//  Created by PhongLe on 14/11/2011.
//  Copyright (c) 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityModel : NSObject
{
    NSString *Id;
	NSString *name;
}

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;

@end
