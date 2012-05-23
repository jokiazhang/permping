//
//  NSURLConnectionFake.m
//  Permping
//
//  Created by MAC on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSURLConnectionFake.h"
#import "Constants.h"

@implementation NSURLConnectionFake

- (void)dealloc {
	[super dealloc];
}

- (void)launchFakeResponse: (id)in_delegate {
	[in_delegate connection:self didReceiveResponse:nil];
	[in_delegate connection:self didReceiveData:fakeData];
	[in_delegate connectionDidFinishLoading:self];
	[fakeData release];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
	if (self = [super init]) {
		NSString *lc_fileName = nil;
        NSString *urlString = [[request URL] absoluteString];
		if ([urlString hasSuffix:@"/permservice/getpupolarperm"]) {
            lc_fileName = @"popularPerms";
        } else if ([urlString hasSuffix:@"/permservice/getcategories"]) {
            lc_fileName = @"categories";
        } else if ([urlString rangeOfString:@"/permservice/getboardswithcategoryid/"].location != NSNotFound) {
            lc_fileName = @"category_22";
        }
		fakeData = [[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:lc_fileName ofType:@"xml"]] retain];
		[self performSelector:@selector(launchFakeResponse:) withObject:delegate afterDelay:0.3];
	}
	return self;
}


@end
