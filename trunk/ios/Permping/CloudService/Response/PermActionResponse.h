//
//  PermActionResponse.h
//  Permping
//
//  Created by MAC on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"

@interface PermActionResponse : Taglist_CloudResponse {
    NSString        *totalLikes;
    NSString        *status;
}
@property (nonatomic, retain, readonly) NSString *totalLikes;
@property (nonatomic, retain, readonly) NSString *status;
@end
