//
//  Taglist_UpdateSettingRequest.m
//  EyeconSocial
//
//  Created by PhongLe on 4/25/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_UpdateSettingRequest.h"
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

@interface Taglist_UpdateSettingRequest()

@property (nonatomic, retain)   NSMutableArray          *params;
@end

@implementation Taglist_UpdateSettingRequest

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
@end
