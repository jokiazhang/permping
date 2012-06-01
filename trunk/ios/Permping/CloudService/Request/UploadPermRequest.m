//
//  UploadPermRequest.m
//  EyeconSocial
//
//  Created by PhongLe on 4/25/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "UploadPermRequest.h"
#import "Constants.h"

@interface EntityModel : NSObject {
}
@property (nonatomic, copy)     NSString        *name;
@property (nonatomic, copy)     NSString        *contentType;
@property (nonatomic, copy)     NSString        *transferEncode;
@property (nonatomic, copy)     NSString        *filename;
@property (nonatomic, retain)   NSData          *body;
@end

@implementation EntityModel

@synthesize name;
@synthesize contentType;
@synthesize transferEncode;
@synthesize filename;
@synthesize body;

- (void)dealloc
{
    self.name = nil;
    self.contentType = nil;
    self.transferEncode = nil;
    self.filename = nil;
    self.body = nil;
    [super dealloc];
}
@end

@interface UploadPermRequest()

@property (nonatomic, retain)   NSMutableArray          *params;
@end

@implementation UploadPermRequest

@synthesize params;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.params = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    self.params = nil;
    [super dealloc];
}

- (void)addPartName:(NSString *)name contentType:(NSString *)content_Type transferEncode:(NSString *)transferEncode body:(NSData *)body filename:(NSString *)filename
{
    EntityModel *entity = [[EntityModel alloc] init];
    entity.name = name;
    entity.contentType = content_Type;
    entity.transferEncode = transferEncode;
    entity.body = body;
    entity.filename = filename;
    [self.params addObject:entity];
    [entity release];
}

- (NSData *)requestToXMLBody
{
    NSMutableData *mutabledata = [NSMutableData data];
    
    NSData *data = [[self parameterListForGetMethod] dataUsingEncoding:NSUTF8StringEncoding];
    [mutabledata appendData:data];
    
    //open boundary
    for (EntityModel *entity in self.params) {
        [mutabledata appendData:[[NSString stringWithFormat:@"--%@\n", UPLOAD_MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableString *mstr = [NSMutableString string];
        if (entity.filename != nil) {
            [mstr appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", entity.name, entity.filename];
        }
        else {
            [mstr appendFormat:@"Content-Disposition: form-data; name=\"%@\"\n", entity.name];
        }
        
        [mstr appendFormat:@"Content-Type: %@\n", entity.contentType];
        [mstr appendFormat:@"Content-Transfer-Encoding: %@\n\n", entity.transferEncode];
        
        [mutabledata appendData:[mstr dataUsingEncoding:NSUTF8StringEncoding]];
        [mutabledata appendData:entity.body];
    }
    //close boundary
    [mutabledata appendData:[[NSString stringWithFormat:@"\n--%@--\n", UPLOAD_MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [NSData dataWithData:mutabledata];
}

/*
 http://stackoverflow.com/questions/7738704/sending-multipart-post-from-ios-and-reading-parameters-in-php-post
 [6/1/12 7:02:24 PM] Phong Le:   NSData *body = [[request parameterListForGetMethod] dataUsingEncoding:NSUTF8StringEncoding];
 [6/1/12 7:09:31 PM] Phong Le: [request addPartName:@"xml" contentType:@"application/xml; charset=UTF-8" transferEncode:@"8bit" body:[mstr dataUsingEncoding:NSUTF8StringEncoding] filename:nil];
 
 if (userSetting.avatar != nil) {
 NSString *extType = [Utility getExtImageType:userSetting.avatar];
 if (extType != nil) {
 [request addPartName:@"image" contentType:[NSString stringWithFormat:@"image/%@", extType] transferEncode:@"binary" body:userSetting.avatar filename:[NSString stringWithFormat:@"avatar.%@", extType]];
 }
 }
 [6/1/12 7:09:58 PM] Phong Le: //create first part
    NSMutableString *mstr = [NSMutableString string];
    [mstr appendString:@"<Request>\n"];
    [mstr appendString:@"\t<Entry>\n"];
    [mstr appendString:@"\t\t<Person>\n"];
    
    if (userSetting.statement != nil && ([user.profileModel.statement caseInsensitiveCompare:userSetting.statement] != NSOrderedSame)) {
        [mstr appendFormat:@"\t\t\t<Statement>%@</Statement>\n", [Utility predefineStringInXML:userSetting.statement]];
    }
    
    if (userSetting.email != nil && ([user.profileModel.email caseInsensitiveCompare:userSetting.email] != NSOrderedSame)) {
        [mstr appendFormat:@"\t\t\t<Email>%@</Email>\n", [Utility predefineStringInXML:userSetting.email]];
    }
    
    if ([userSetting.password length] > 0) {
        [mstr appendFormat:@"\t\t\t<Password>%@</Password>\n", [Utility predefineStringInXML:user.password]];
        [mstr appendFormat:@"\t\t\t<NewPassword>%@</NewPassword>\n", [Utility predefineStringInXML:userSetting.password]];
    }
    
    if (userSetting.avatar != nil) {
        [mstr appendFormat:@"\t\t\t<Thumbnail>%@</Thumbnail>\n", @"avatar.png"];
        [mstr appendFormat:@"\t\t\t<ThumbSize>%d</ThumbSize>\n", [userSetting.avatar length]];        
    }
    [mstr appendString:@"\t\t</Person>\n"];
    [mstr appendString:@"\t</Entry>\n"];
    [mstr appendString:@"</Request>\n"];
    
    [request addPartName:@"xml" contentType:@"application/xml; charset=UTF-8" transferEncode:@"8bit" body:[mstr dataUsingEncoding:NSUTF8StringEncoding] filename:nil];
    
    if (userSetting.avatar != nil) {
        NSString *extType = [Utility getExtImageType:userSetting.avatar];
        if (extType != nil) {
            [request addPartName:@"image" contentType:[NSString stringWithFormat:@"image/%@", extType] transferEncode:@"binary" body:userSetting.avatar filename:[NSString stringWithFormat:@"avatar.%@", extType]];
        }
    }
    
    Taglist_UpdateSettingResponse *response = [[Taglist_UpdateSettingResponse alloc] init]; 
    [[Taglist_CloudRequestDispatcher getInstance] dispatchRequest:request response:response];
    [request release];
*/
@end
