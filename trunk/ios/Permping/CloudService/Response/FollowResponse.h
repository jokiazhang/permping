//
//  FollowResponse.h
//  Permping
//
//  Created by MAC on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"

@interface FollowResponse : Taglist_CloudResponse {
    NSString        *status;
    NSString        *totalFollows;
}
@property (nonatomic, retain, readonly) NSString *totalFollows;
@property (nonatomic, retain, readonly) NSString *status;
@end
