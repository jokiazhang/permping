//
//  MapKitAnnotation.m
//  WMM
//
//  Created by Andrew Duck on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapKitAnnotation.h"

@implementation MapKitAnnotation
@synthesize coordinate, titletext, subtitletext;

- (NSString *)subtitle{
	return subtitletext;
}

- (NSString *)title{
	return titletext;
}

- (void)setTitle:(NSString*)strTitle {
	self.titletext = strTitle;
}

- (void)setSubTitle:(NSString*)strSubTitle {
	self.subtitletext = strSubTitle;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) c {
	coordinate = c;
	return self;
}

- (void)dealloc {
    [titletext release];
    [subtitletext release];
    [super dealloc];
}
@end
