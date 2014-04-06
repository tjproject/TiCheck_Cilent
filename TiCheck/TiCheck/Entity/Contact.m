//
//  Contact.m
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (id)init
{
    if (self = [super init]) {
        _contactName = _mobilePhone = _contactTel = _foreignMobile = _mobileCountryFix = _contactEmail = _contactFax = @"";
    }
    
    return self;
}

+ (Contact *)contactWithContactName:(NSString *)contactName
                      confirmOption:(ConfirmOption)confirmOption
                        mobilePhone:(NSString *)phoneNumber
                       contactEmail:(NSString *)emailAddress
{
    Contact *contact = [[Contact alloc] init];
    
    contact.contactName = contactName;
    contact.confirmOption = confirmOption;
    contact.mobilePhone = phoneNumber;
    contact.contactEmail = emailAddress;
    
    return contact;
}

@end
