//
//  ImageViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommonViewController.h"

@interface ImageViewController : CommonViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIButton   *takePhotoButton;
    IBOutlet UIButton   *galleryButton;
    IBOutlet UIButton   *createBoardButton;
}

- (IBAction)takePhotoButtonDidTouch:(id)sender;

- (IBAction)galleryButtonDidTouch:(id)sender;

- (IBAction)createBoardButtonDidTouch:(id)sender;

@end
