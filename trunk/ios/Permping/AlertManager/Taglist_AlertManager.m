//
//  Taglist_AlertManager.m
//  EyeconSocial
//
//  Created by PhongLe on 3/19/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_AlertManager.h"

@interface Taglist_AlertTransistData : NSObject
{
    NSInteger               alertId;
    NSString                *alertTitle;
    NSString                *alertBody;
    NSString                *cancelButtonTitle;
    NSString                *otherButtonTitle;
    id<UIAlertViewDelegate> delegate;
}
@property (nonatomic, assign) NSInteger alertId;
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertBody;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;
@property (nonatomic, assign) id<UIAlertViewDelegate> delegate;
@end

@interface Taglist_AlertManager()
 
@end

@implementation Taglist_AlertTransistData
@synthesize alertId, alertTitle, alertBody, cancelButtonTitle, otherButtonTitle;
@synthesize delegate;
-(void)dealloc
{
    self.alertTitle = nil;
    self.alertBody = nil;
    self.cancelButtonTitle = nil;
    self.otherButtonTitle =nil;
    self.delegate = nil;
    [super dealloc];
}
@end

@implementation Taglist_AlertManager

 

static Taglist_AlertManager	*instance = nil; 

+ (Taglist_AlertManager *)getInstance
{
	if (instance)
	{
		return instance;
	}
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[Taglist_AlertManager alloc] init];           
		}
	}
	return instance;
}

- (id)init
{
    if(self = [super init])
    { 
        alertShowingDict = [[NSMutableDictionary alloc] init];
        dummyDelegate = [[NSObject alloc] init];
    }
    return self;
}

- (BOOL)notShowingAlertId:(NSInteger)alertId
{
    id obj = [alertShowingDict objectForKey:[NSNumber numberWithInt:alertId]];
    if(obj == nil)
        return YES;
    
    return NO;
}

- (void)showAlertWithId:(NSInteger)alertId title:(NSString *)title body:(NSString *)bodyString delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle
{
    if([self notShowingAlertId:alertId])
    {        
        if (delegate) {
            [alertShowingDict setObject:delegate forKey:[NSNumber numberWithInt:alertId]];
        }
        else {
            [alertShowingDict setObject:dummyDelegate forKey:[NSNumber numberWithInt:alertId]];
        }        
        
        if([NSThread isMainThread])
        {
            UIAlertView *alertView;
            if (otherButtonTitle) {
                alertView = [[UIAlertView alloc] initWithTitle:title message:bodyString delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
            }
            else {
                alertView = [[UIAlertView alloc] initWithTitle:title message:bodyString delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
            }
            alertView.tag = alertId;
            [alertView show];
            [alertView release];

            
        }
        else {
            Taglist_AlertTransistData *data = [[Taglist_AlertTransistData alloc] init];
            data.alertTitle = title;
            data.alertBody = bodyString;
            data.alertId = alertId;
            data.cancelButtonTitle = cancelButtonTitle;
            data.otherButtonTitle = otherButtonTitle;
            data.delegate = delegate;
            [self performSelectorOnMainThread:@selector(showAlertInMainThread:) withObject:data waitUntilDone:NO];
            [data release];
        }
    }

}

- (void)showAlertInMainThread:(Taglist_AlertTransistData *)data
{
    UIAlertView *alertView;
    if (data.otherButtonTitle) {
        alertView = [[UIAlertView alloc] initWithTitle:data.alertTitle message:data.alertBody delegate:self cancelButtonTitle:data.cancelButtonTitle otherButtonTitles:data.otherButtonTitle, nil];
    }
    else {
        alertView = [[UIAlertView alloc] initWithTitle:data.alertTitle message:data.alertBody delegate:self cancelButtonTitle:data.cancelButtonTitle otherButtonTitles: nil];
    }
    alertView.tag = data.alertId;
    [alertView show];
    [alertView release]; 
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSNumber *dismissId = [NSNumber numberWithInt:alertView.tag];
    id       delegate = [alertShowingDict objectForKey:dismissId];
    [alertShowingDict removeObjectForKey:dismissId];
    if (delegate != dummyDelegate)
        [delegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
}
@end
