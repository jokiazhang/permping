//
//  Taglist_UpdateSettingRequest.h
//  EyeconSocial
//
//  Created by PhongLe on 4/25/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudRequest.h"

@interface Taglist_UpdateSettingRequest : Taglist_CloudRequest

- (void)addPartName:(NSString *)name contentType:(NSString *)content_Type transferEncode:(NSString *)transferEncode body:(NSData *)body filename:(NSString *)filename;
@end
