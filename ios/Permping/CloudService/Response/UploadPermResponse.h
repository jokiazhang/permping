//
//  UploadPermResponse.h
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"

@interface UploadPermResponse : Taglist_CloudResponse {
    NSString *permId;
}
@property (nonatomic, copy) NSString *permId;

@end
