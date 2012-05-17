//
//  RequestResult.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestResult.h"
#import "WSError.h"

@implementation RequestResult

@synthesize object, error;

+(id)resultWithObject:(id)in_object{
	return [[[RequestResult alloc] initWithObject:in_object] autorelease];
}

+(id)resultWithError:(id)in_error{
	return [[[RequestResult alloc] initWithError:in_error] autorelease];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.object = nil;
		self.error = nil;
	}
	return self;
}

-(id)initWithObject:(id)in_object{
	self = [self init];
	if (self != nil) {
		self.object = in_object;
	}
	return self;
}

-(id)initWithError:(id)in_error{
	self = [self init];
	if (self != nil) {
		self.error = in_error;
		
		NSString *message = nil;
        if ([self.error isKindOfClass:[NSError class]]) {
            WSError *lcError = [[(NSError*)in_error userInfo] objectForKey:@"wserror"];
            if (lcError.code != 200) {
                message = lcError.message;
            }
        }
        
        if (!message) message = NSLocalizedString(@"RequestResult.error_occured", @"An error occured" );
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle: nil
														  message: message
														 delegate:self cancelButtonTitle:NSLocalizedString(@"RequestResult.ok_button", @"Ok button") otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	return self;
}

- (void) dealloc
{
	[object release];
	[error release];
	[super dealloc];
}

-(BOOL)hasError{
	return error != nil;
}




@end
