//
//  CreatePermViewController.h
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BoardModel.h"
#import "PermModel.h"
#import "CommonViewController.h"

@interface CreatePermViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate> {
    CLLocationManager   *locationManager;
    CLLocation          *bestEffortAtLocation;
    IBOutlet UITableView *permTableView;
    NSDictionary    *imageInfo;
    BoardModel      *selectedBoard;
    PermModel       *currentPerm;
    NSData          *fileData;
    
    BOOL            geoEnable;
    
    UISwitch        *currentSwitch;
    
    id target;
    SEL action;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (nonatomic, retain) NSDictionary  *imageInfo;
@property (nonatomic, retain) BoardModel    *selectedBoard;
@property (nonatomic, retain) NSData          *fileData;
@property (nonatomic, retain) PermModel     *currentPerm;

- (BOOL)validateInputData;

- (void)setTarget:(id)in_target action:(SEL)in_action;

- (void)setupLocationManager;
@end
