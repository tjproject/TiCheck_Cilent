//
//  OTAResponse.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"
#import "GDataXMLNode.h"

@implementation OTAResponse

- (id)initHeaderWithResponse:(NSString *)xml
{
    if (self = [super init]) {
        [self parseHeader:xml];
    }
    return self;
}

- (BOOL)isResponseSuccess
{
    if ([[_header valueForKey:@"ResultCode"] isEqualToString:@"Success"]) return true;
    else return false;
}

#pragma mark - Helper Methods

- (void)parseHeader:(NSString *)xml
{
    NSLog(@"%@", xml);
    GDataXMLElement *root = [self getRootElement:xml];
    
    _namespacesDic = [NSDictionary dictionaryWithObject:[root.namespaces[0] stringValue] forKey:@"ctrip"];
    
    // Parsing header
    GDataXMLElement *header = [[root nodesForXPath:@"//ctrip:Header" namespaces:_namespacesDic error:nil] objectAtIndex:0];
    NSArray *attr = [header attributes];
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    for (GDataXMLElement *elem in attr) {
        [headerDic setObject:[elem stringValue] forKey:[elem name]];
    }
    _header = headerDic;
}

- (GDataXMLElement *)getRootElement:(NSString *)xml
{
    xml = [xml stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    xml = [xml stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    xml = [xml stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\"?>" withString:@""];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xml encoding:NSUTF8StringEncoding error:&error];
    GDataXMLElement *root = [[doc nodesForXPath:@"/soap:Envelope/soap:Body/*" error:&error] objectAtIndex:0];
    
    return [root copy];
}

@end
