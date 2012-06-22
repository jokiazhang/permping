//
//  MapKitViewController.h
//  Permping
//
//  Created by MAC on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CommonViewController.h"
#import "MapKitAnnotation.h"
#import "PermModel.h"

@interface MapKitViewController : CommonViewController<MKMapViewDelegate> {
    IBOutlet MKMapView      *permLocationMapView;
    PermModel               *selectedPerm;
}
@property (nonatomic, retain) PermModel *selectedPerm;
@end
