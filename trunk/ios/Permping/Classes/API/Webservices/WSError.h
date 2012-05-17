//
//  WSError.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"

@interface WSError : RemoteObject {
	NSInteger     code;
	NSString *message;
}

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, retain) NSString *message;

- (NSError*)error;



@end
