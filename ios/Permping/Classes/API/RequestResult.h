//
//  RequestResult.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject {
	id object;
	NSError *error;
}

@property(nonatomic, retain) id object;
@property(nonatomic, retain) NSError *error;

+(id)resultWithObject:(id)in_object;
+(id)resultWithError:(id)in_error;

-(id)initWithObject:(id)in_object;
-(id)initWithError:(id)in_error;
-(BOOL)hasError;

@end

