//
//  ImageViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "CreatePermViewController.h"
#import "CreateBoardViewController.h"
#import "AppData.h"
#import "LoginViewController.h"

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ImageTabTitle", @"Image");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-image"];
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
    [takePhotoButton setTitle:NSLocalizedString(@"TakePhoto", nil) forState:UIControlStateNormal];
    [galleryButton setTitle:NSLocalizedString(@"Gallery", nil) forState:UIControlStateNormal];
    [createBoardButton setTitle:NSLocalizedString(@"CreateBoard", nil) forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)takePhotoButtonDidTouch:(id)sender {
     if ([[AppData getInstance] didLogin]) {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *media = [UIImagePickerController
                          availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        
        if ([media containsObject:(NSString*)kUTTypeImage] == YES) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
            
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsupported!"
                                                            message:@"Camera does not support photo capturing."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable!"
                                                        message:@"This device does not have a camera."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
     }
     else {
         LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
         [self.navigationController pushViewController:controller animated:YES];
         [controller release];
     }
}

- (IBAction)galleryButtonDidTouch:(id)sender {
    if ([[AppData getInstance] didLogin]) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSArray *media = [UIImagePickerController
                              availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
            
            if ([media containsObject:(NSString*)kUTTypeImage] == YES) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
                
                picker.delegate = self;
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable!"
                                                            message:@"This device does not have a gallery."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    } else {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (IBAction)createBoardButtonDidTouch:(id)sender {
    if ([[AppData getInstance] didLogin]) {
    CreateBoardViewController *controller = [[CreateBoardViewController alloc] initWithNibName:@"CreateBoardViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    } else {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    
    //assign the mediatype to a string 
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *webData = nil;
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]){
        UIImage *photoTaken = [info objectForKey:UIImagePickerControllerOriginalImage];
        webData = UIImageJPEGRepresentation(photoTaken, 0);
        if (webData) {
            CreatePermViewController *controller = [[CreatePermViewController alloc] initWithNibName:@"CreatePermViewController" bundle:nil];
            controller.fileData = webData;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
//        
//        
//        NSData* jpegData = UIImageJPEGRepresentation (photoTaken,0.5);
//        EXFJpeg* jpegScanner = [[EXFJpeg alloc] init];
//        [jpegScanner scanImageData: jpegData];
//        EXFMetaData* exifData = jpegScanner.exifMetaData;
//        EXFTag* latitudeDef = [exifData tagDefinition: [NSNumber numberWithInt:EXIF_GPSLatitude]];
//        EXFTag* longitudeDef = [exifData tagDefinition: [NSNumber numberWithInt:EXIF_GPSLongitude]];
    } else {
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    //NSLog(@"Image:%@", image);
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}


@end
