//
//  Utils.h
//  Permping
//
//  Created by MAC on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject {
    
}

+ (void)displayAlert:(NSString*)message delegate:(id)delegate;

+ (UIBarButtonItem*)barButtonnItemWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;

@end
