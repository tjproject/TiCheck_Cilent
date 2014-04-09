//
//  DeliverInfo.m
//  Test
//
//  Created by Boyi on 3/12/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "DeliverInfo.h"
#import "NSDate-Utilities.h"

@implementation DeliverInfo

- (id)init
{
    if (self = [super init]) {
        _deliveryTypeName = _deliverTimeStr = _sendTicketCityID = _orderRemark = _receiverName = _province = _city = _canton = _address = _postCode = _deliverFeeStr = _prePayType = _prepayTypeName = _contactName = _contactName = _contactPhone = _contactMobile = _contactEmail = @"";
    }
    
    return self;
}

+ (DeliverInfo *)deliverInfoWithoutTicketSend
{
    DeliverInfo *deliverInfo = [[DeliverInfo alloc] init];
    
    deliverInfo.deliveryType = PJN;
    deliverInfo.sendTicketCityID = @"0";
    
    return deliverInfo;
}

@end
