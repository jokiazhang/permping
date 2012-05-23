//
//  NSURLConnectionFake.h
//  Permping
//
//  Created by MAC on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnectionFake : NSURLConnection {
	NSData *fakeData;
}

@end
