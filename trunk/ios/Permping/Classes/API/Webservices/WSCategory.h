//
//  WSCategory.h
//  Permping
//
//  Created by Andrew Duck on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteObject.h"

@interface WSCategory : RemoteObject {
    NSString    *categoryId;
    NSString    *title;
}
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *title;

@end
