//
//  OTAUserUniqueID.m
//  Test
//
//  Created by Boyi on 3/12/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAUserUniqueID.h"
#import "ConfigurationHelper.h"

@implementation OTAUserUniqueID

- (NSString *)generateOTAUserUniqueIDXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:UserUniqueID];
    NSLog(@"header = %@", header);
    
    NSString *requestXML = [header stringByAppendingString:[self generateUserRequestXML]];
    
    NSLog(@"request XML = %@", requestXML);
    return requestXML;
}

- (NSString *)generateUserRequestXML
{
    NSString *allianceID     = [NSString stringWithFormat:@"&lt;AllianceID&gt;%d&lt;/AllianceID&gt;", ALLIANCE_ID];
    NSString *stationID      = [NSString stringWithFormat:@"&lt;SID&gt;%d&lt;/SID&gt;", STATION_ID];
    NSString *uidKey         = [NSString stringWithFormat:@"&lt;UidKey&gt;%@&lt;/UidKey&gt;", _uidKey];
    NSString *telphoneNumber = [NSString stringWithFormat:@"&lt;TelphoneNumber&gt;%@&lt;/TelphoneNumber&gt;", _telphoneNumber];

    NSString *userRequest    = [NSString stringWithFormat:
                                @"&lt;UserRequest&gt;\n"
                                "%@\n"
                                "%@\n"
                                "%@\n"
                                "%@\n"
                                "&lt;/UserRequest&gt;\n", allianceID, stationID, uidKey, telphoneNumber];
    
    return userRequest;
}

@end
