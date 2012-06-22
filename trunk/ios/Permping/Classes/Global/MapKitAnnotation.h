//
//  MapKitAnnotation.h
//  WMM
//
//  Created by Andrew Duck on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapKitAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
	NSString *subtitletext;
	NSString *titletext;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (readwrite, retain) NSString *titletext;
@property (readwrite, retain) NSString *subtitletext;

- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *) subtitle;
- (NSString *) title;
- (void) setTitle:(NSString*)strTitle;
- (void) setSubTitle:(NSString*)strSubTitle;

@end
