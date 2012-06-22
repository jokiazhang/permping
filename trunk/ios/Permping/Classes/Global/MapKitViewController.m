//
//  MapKitViewController.m
//  Permping
//
//  Created by MAC on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapKitViewController.h"
#import "Utils.h"

@implementation MapKitViewController
@synthesize selectedPerm;

- (void)dealloc {
    [selectedPerm release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismiss:)];
    
    CGFloat latitude = [selectedPerm.latitude doubleValue];
    CGFloat longitude = [selectedPerm.longitude doubleValue];
    CLLocationCoordinate2D coord = {latitude, longitude};
    MapKitAnnotation *pin = [[MapKitAnnotation alloc] initWithCoordinate:coord];
    [pin setTitle:selectedPerm.permDesc];
    [pin setSubTitle:selectedPerm.permDateMessage];
    [permLocationMapView addAnnotation:pin];
    [permLocationMapView selectAnnotation:pin animated:YES];
    
    MKCoordinateSpan span= {0.005844, 0.012726};
    MKCoordinateRegion region = {coord, span};
    [permLocationMapView setRegion:region animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark - MKMapViewDelegate implementation
#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"com.appo.permping.pin";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil) {
        pinView = [[[MKPinAnnotationView alloc]
                    initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.draggable = YES;
    }
    return pinView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    /*selectedLocation = view.annotation;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Get Direction", nil];
    [alert show];
    [alert release];*/
}

@end
