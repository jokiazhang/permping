//
//  Taglist_AlertManager.h
//  EyeconSocial
//
//  Created by PhongLe on 3/19/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Taglist_AlertManager : NSObject <UIAlertViewDelegate>
{
    NSInteger               lastAlertId;
    NSMutableDictionary     *alertShowingDict;
    NSObject                *dummyDelegate;
}
+ (Taglist_AlertManager *)getInstance;
- (void)showAlertWithId:(NSInteger)alertId title:(NSString *)title body:(NSString *)bodyString delegate:(id<UIAlertViewDelegate>)delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle;
@end
