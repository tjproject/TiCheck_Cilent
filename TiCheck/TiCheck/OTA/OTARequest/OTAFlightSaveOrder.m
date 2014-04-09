//
//  OTAFlightSaveOrder.m
//  Test
//
//  Created by Boyi on 3/5/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightSaveOrder.h"
#import "ConfigurationHelper.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

#import "Flight.h"
#import "Passenger.h"
#import "Contact.h"
#import "DeliverInfo.h"
#import "CreditCardInfo.h"

@implementation OTAFlightSaveOrder

- (id)initWithUserUniqueUID:(NSString *)uniqueID
                    AgeType:(AgeType)ageType
                 flightList:(NSArray *)flights
              passengerList:(NSArray *)passengers
                    contact:(Contact *)contact
{
    if (self = [super init]) {
        // !!!: 初始化未进行检查
        _uniqueUID = uniqueID;
        _ageType = ageType;
        _processDescription = @"";
        _flightInfoList = flights;
        _passengerList = passengers;
        _contact = contact;
        _deliverInfo = [DeliverInfo deliverInfoWithoutTicketSend];
    }
    
    return self;
}

- (NSString *)generateOTAFlightSaveOrderXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightSaveOrderRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"&lt;Request&gt;\n"
                            "%@"
                            "&lt;/Request&gt;", [header stringByAppendingString:[self generateSaveOrderRequestXML]]];
        
    return requestXML;
}

#pragma mark - XML生成函数

- (NSString *)generateSaveOrderRequestXML
{
    NSString *userID           = _uniqueUID;

    NSString *ageType          = [NSString stringWithFormat:@"&lt;OrderType&gt;%@&lt;/OrderType&gt;", [NSString ageTypeToString:_ageType]];
    NSString *processDesc      = [NSString stringWithFormat:@"&lt;ProcessDesc&gt;%@&lt;/ProcessDesc&gt;", _processDescription];
    NSString *flightInfoList   = [self generateFlightInfoListXML];
    NSString *passengerList    = [self generatePassengerListXML];
    NSString *contact          = [self generateContactXML];
    NSString *deliverInfo      = [self generateDeliverInfoXML];
//    NSString *creditCardInfo   = [self generateCreditCardInfoXML]; // ???: 考虑在任何情况下都把支付和下临时订单分开做
    
    NSString *amount           = [NSString stringWithFormat:@"&lt;Amount&gt;%f&lt;/Amount&gt;", _amount];

    NSString *saveOrderRequest = [NSString stringWithFormat:
                                  @"&lt;FltSaveOrderRequest&gt;\n"
                                  "&lt;UID&gt;%@&lt;/UID&gt;\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "&lt;/FltSaveOrderRequest&gt;\n", userID, ageType, amount, processDesc, flightInfoList, passengerList, contact, deliverInfo];
    
    return saveOrderRequest;
}

- (NSString *)generateFlightInfoListXML
{
    NSString *flights = @"&lt;FlightInfoList&gt;\n";
    
    for (Flight *flight in _flightInfoList) {
        // !!!: 城市ID和城市三字码的区别
        NSString *departCity  = [NSString stringWithFormat:@"&lt;DepartCityID&gt;%@&lt;/DepartCityID&gt;", flight.departCityCode];
        NSString *arriveCity  = [NSString stringWithFormat:@"&lt;ArriveCityID&gt;%@&lt;/ArriveCityID&gt;", flight.arriveCityCode];
        NSString *departPort  = [NSString stringWithFormat:@"&lt;DPortCode&gt;%@&lt;/DPortCode&gt;", flight.departPortCode];
        NSString *arrivePort  = [NSString stringWithFormat:@"&lt;APortCode&gt;%@&lt;/APortCode&gt;", flight.arrivePortCode];
        NSString *airline     = [NSString stringWithFormat:@"&lt;AirlineCode&gt;%@&lt;/AirlineCode&gt;", flight.airlineCode];
        NSString *flightNo    = [NSString stringWithFormat:@"&lt;Flight&gt;%@&lt;/Flight&gt;", flight.flightNumber];
        NSString *classGrade  = [NSString stringWithFormat:@"&lt;Class&gt;%@&lt;/Class&gt;", [NSString classGradeToString:flight.classGrade]];
        NSString *subClass    = [NSString stringWithFormat:@"&lt;SubClass&gt;%@&lt;/SubClass&gt;", flight.subClass];
        NSString *takeOffTime = [NSString stringWithFormat:@"&lt;TakeOffTime&gt;%@&lt;/TakeOffTime&gt;", [NSString stringFormatWithTime:flight.takeOffTime]];
        NSString *arrivalTime = [NSString stringWithFormat:@"&lt;ArrivalTime&gt;%@&lt;/ArrivalTime&gt;", [NSString stringFormatWithTime:flight.arrivalTime]];
        NSString *rate        = [NSString stringWithFormat:@"&lt;Rate&gt;%f&lt;/Rate&gt;", flight.rate];
        NSString *price       = @"";
        NSString *tax         = @"";
        NSString *oilFee      = @"";
        
        // !!! 此处计算amount值
        switch (_ageType) {
            case ADU:
                price   = [NSString stringWithFormat:@"&lt;Price&gt;%ld&lt;/Price&gt;", flight.standardPrice];
                tax     = [NSString stringWithFormat:@"&lt;Tax&gt;%ld&lt;/Tax&gt;", flight.adultTax];
                oilFee  = [NSString stringWithFormat:@"&lt;OilFee&gt;%f&lt;/OilFee&gt;", flight.adultOilFee];
                _amount = flight.standardPrice + flight.adultTax + flight.adultOilFee;
                break;
            case CHI:
                price   = [NSString stringWithFormat:@"&lt;Price&gt;%ld&lt;/Price&gt;", flight.childStandardPrice];
                tax     = [NSString stringWithFormat:@"&lt;Tax&gt;%ld&lt;/Tax&gt;", flight.childTax];
                oilFee  = [NSString stringWithFormat:@"&lt;OilFee&gt;%f&lt;/OilFee&gt;", flight.childOilFee];
                _amount = flight.childStandardPrice + flight.childTax + flight.childOilFee;
                break;
            case BAB:
                price   = [NSString stringWithFormat:@"&lt;Price&gt;%ld&lt;/Price&gt;", flight.babyStandardPrice];
                tax     = [NSString stringWithFormat:@"&lt;Tax&gt;%ld&lt;/Tax&gt;", flight.babyTax];
                oilFee  = [NSString stringWithFormat:@"&lt;OilFee&gt;%f&lt;/OilFee&gt;", flight.babyOilFee];
                _amount = flight.babyStandardPrice + flight.babyTax + flight.babyOilFee;
                break;
        }
        NSString *nonRer             = [NSString stringWithFormat:@"&lt;NonRer&gt;%@&lt;/NonRer&gt;", flight.nonRer];
        NSString *nonRef             = [NSString stringWithFormat:@"&lt;NonRef&gt;%@&lt;/NonRef&gt;", flight.nonRef];
        NSString *nonEnd             = [NSString stringWithFormat:@"&lt;NonEnd&gt;%@&lt;/NonEnd&gt;", flight.nonEnd];
        NSString *rerNote            = [NSString stringWithFormat:@"&lt;RerNote&gt;%@&lt;/RerNote&gt;", flight.rerNote];
        NSString *refNote            = [NSString stringWithFormat:@"&lt;RefNote&gt;%@&lt;/RefNote&gt;", flight.refNote];
        NSString *endNote            = [NSString stringWithFormat:@"&lt;EndNote&gt;%@&lt;/EndNote&gt;", flight.endNote];
        NSString *remark             = [NSString stringWithFormat:@"&lt;Remark&gt;%@&lt;/Remark&gt;", flight.remarks];
        NSString *needAppl           = [NSString stringWithFormat:@"&lt;NeedAppl&gt;%@&lt;/NeedAppl&gt;", (flight.needApplyString ? @"T" : @"F")];
        NSString *recommend          = [NSString stringWithFormat:@"&lt;Recommend&gt;%ld&lt;/Recommend&gt;", flight.recommend];
        NSString *canPost            = [NSString stringWithFormat:@"&lt;Canpost&gt;%@&lt;/Canpost&gt;", (flight.canPost ? @"T": @"F")];
        NSString *craftType          = [NSString stringWithFormat:@"&lt;CraftType&gt;%@&lt;/CraftType&gt;", flight.craftType];
        NSString *quantity           = [NSString stringWithFormat:@"&lt;Quantity&gt;%ld&lt;/Quantity&gt;", flight.quantity];
        NSString *refundFeeFormulaID = [NSString stringWithFormat:@"&lt;RefundFeeFormulaID&gt;%ld&lt;/RefundFeeFormulaID&gt;", flight.refundFeeFormulaID];
        NSString *upGrade            = [NSString stringWithFormat:@"&lt;UpGrade&gt;%@&lt;/UpGrade&gt;", (flight.canUpGrade ? @"T" : @"F")];
        NSString *ticketType         = [NSString stringWithFormat:@"&lt;TicketType&gt;%@&lt;/TicketType&gt;", flight.ticketType];
        NSString *allowCPType        = [NSString stringWithFormat:@"&lt;AllowCPType&gt;%@&lt;/AllowCPType&gt;", flight.allowCPType];
        NSString *productType        = [NSString stringWithFormat:@"&lt;ProductType&gt;%@&lt;/ProductType&gt;", [NSString productTypeToString:flight.productType]];
        NSString *productSource      = [NSString stringWithFormat:@"&lt;ProductSource&gt;%ld&lt;/ProductSource&gt;", flight.productSource];
        NSString *inventoryType      = [NSString stringWithFormat:@"&lt;InventoryType&gt;%@&lt;/InventoryType&gt;", [NSString inventoryTypeToString:flight.inventoryType]];
        NSString *priceType          = [NSString stringWithFormat:@"&lt;PriceType&gt;%@&lt;/PriceType&gt;", [NSString priceTypeToString:flight.priceType]];
        NSString *onlyOwnCity        = [NSString stringWithFormat:@"&lt;Onlyowncity&gt;%@&lt;/Onlyowncity&gt;", (flight.onlyOwnCity ? @"true" : @"false")];
        NSString *canSeparateSale    = [NSString stringWithFormat:@"&lt;CanSeparateSale /&gt;"];
        NSString *routeIndex         = [NSString stringWithFormat:@"&lt;RouteIndex&gt;%ld&lt;/RouteIndex&gt;", flight.routeIndex];
        
        NSString *flightInfoRequest  = [NSString stringWithFormat:
                                        @"&lt;FlightInfoRequest&gt;\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "%@\n"
                                        "&lt;/FlightInfoRequest&gt;\n", departCity, arriveCity, departPort, arrivePort, airline, flightNo, classGrade, subClass, takeOffTime, arrivalTime, rate, price, tax, oilFee, nonRer, nonRef, nonEnd, rerNote, refNote, endNote, remark, needAppl, recommend, canPost, craftType, quantity, refundFeeFormulaID, upGrade, ticketType, allowCPType, productType, productSource, inventoryType, priceType, onlyOwnCity, canSeparateSale, routeIndex];
        
        flights = [flights stringByAppendingFormat:@"%@", flightInfoRequest];
    }
    
    flights = [flights stringByAppendingFormat:@"&lt;/FlightInfoList&gt;"];
    
    return flights;
}

- (NSString *)generatePassengerListXML
{
    NSString *passengers = @"&lt;PassengerList&gt;\n";
    
    for (Passenger *passenger in _passengerList) {
        NSString *name             = [NSString stringWithFormat:@"&lt;PassengerName&gt;%@&lt;/PassengerName&gt;", passenger.passengerName];
        NSString *birthDay         = [NSString stringWithFormat:@"&lt;BirthDay&gt;%@&lt;/BirthDay&gt;", [NSString stringFormatWithDate:passenger.birthDay]];
        NSString *passportTypeID   = [NSString stringWithFormat:@"&lt;PassportTypeID&gt;%lu&lt;/PassportTypeID&gt;", passenger.passportType];
        NSString *passportNo       = [NSString stringWithFormat:@"&lt;PassportNo&gt;%@&lt;/PassportNo&gt;", passenger.passportNumber];
        NSString *contactTel       = [NSString stringWithFormat:@"&lt;ContactTelephone&gt;%@&lt;/ContactTelephone&gt;", passenger.contactTelephone];
        NSString *gender           = [NSString stringWithFormat:@"&lt;Gender&gt;%@&lt;/Gender&gt;", [NSString genderToString:passenger.gender]];
        NSString *nationalityCode  = [NSString stringWithFormat:@"&lt;NationalityCode&gt;%@&lt;/NationalityCode&gt;", passenger.nationalityCode];

        NSString *passengerRequest = [NSString stringWithFormat:
                                      @"&lt;PassengerRequest&gt;\n"
                                      "%@\n"
                                      "%@\n"
                                      "%@\n"
                                      "%@\n"
                                      "%@\n"
                                      "%@\n"
                                      "%@\n"
                                      "&lt;/PassengerRequest&gt;\n", name, birthDay, passportTypeID, passportNo, contactTel, gender, nationalityCode];
        
        passengers = [passengers stringByAppendingFormat:@"%@", passengerRequest];
    }
    
    passengers = [passengers stringByAppendingFormat:@"&lt;/PassengerList&gt;"];
    
    return passengers;
}

- (NSString *)generateContactXML
{
    NSString *contactName      = [NSString stringWithFormat:@"&lt;ContactName&gt;%@&lt;/ContactName&gt;", _contact.contactName];
    NSString *confirmOption    = [NSString stringWithFormat:@"&lt;ConfirmOption&gt;%@&lt;/ConfirmOption&gt;", [NSString confirmOptionToString:_contact.confirmOption]];
    NSString *mobilePhone      = [NSString stringWithFormat:@"&lt;MobilePhone&gt;%@&lt;/MobilePhone&gt;", _contact.mobilePhone];
    NSString *contactTel       = [NSString stringWithFormat:@"&lt;ContactTel&gt;%@&lt;/ContactTel&gt;", _contact.contactTel];
    NSString *foreignMobile    = [NSString stringWithFormat:@"&lt;ForeignMobile&gt;%@&lt;/ForeignMobile&gt;", _contact.foreignMobile];
    NSString *mobileCountryFix = [NSString stringWithFormat:@"&lt;MobileCountryFix&gt;%@&lt;/MobileCountryFix&gt;", _contact.mobileCountryFix];
    NSString *contactEmail     = [NSString stringWithFormat:@"&lt;ContactEMail&gt;%@&lt;/ContactEMail&gt;", _contact.contactEmail];
    NSString *contactFax       = [NSString stringWithFormat:@"&lt;ContactFax&gt;%@&lt;/ContactFax&gt;", _contact.contactFax];

    NSString *contactInfo      = [NSString stringWithFormat:
                                  @"&lt;ContactInfo&gt;\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "&lt;/ContactInfo&gt;", contactName, confirmOption, mobilePhone, contactTel, foreignMobile, mobileCountryFix, contactEmail, contactFax];
    
    return contactInfo;
}

- (NSString *)generateDeliverInfoXML
{
    NSString *deliveryType     = [NSString stringWithFormat:@"&lt;DeliveryType&gt;%@&lt;/DeliveryType&gt;", [NSString deliveryTypeToString:_deliverInfo.deliveryType]];
    NSString *sendTicketCityID = [NSString stringWithFormat:@"&lt;SendTicketCityID&gt;%@&lt;/SendTicketCityID&gt;", _deliverInfo.sendTicketCityID];
    NSString *orderRemark      = [NSString stringWithFormat:@"&lt;OrderRemark&gt;%@&lt;/OrderRemark&gt;", _deliverInfo.orderRemark];

    NSString *receiver         = [NSString stringWithFormat:@"&lt;Receiver&gt;%@&lt;/Receiver&gt;", _deliverInfo.receiverName];
    NSString *province         = [NSString stringWithFormat:@"&lt;Province&gt;%@&lt;/Province&gt;", _deliverInfo.province];
    NSString *city             = [NSString stringWithFormat:@"&lt;City&gt;%@&lt;/City&gt;", _deliverInfo.city];
    NSString *canton           = [NSString stringWithFormat:@"&lt;Canton&gt;%@&lt;/Canton&gt;", _deliverInfo.canton];
    NSString *address          = [NSString stringWithFormat:@"&lt;Address&gt;%@&lt;/Address&gt;", _deliverInfo.address];
    NSString *postCode         = [NSString stringWithFormat:@"&lt;PostCode&gt;%@&lt;/PostCode&gt;", _deliverInfo.postCode];

    NSString *pjs              = [NSString stringWithFormat:
                                  @"&lt;PJS&gt;\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "&lt;/PJS&gt;", receiver, province, city, canton, address, postCode];

    NSString *deliverInfo      = [NSString stringWithFormat:
                                  @"&lt;DeliverInfo&gt;\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "&lt;/DeliverInfo&gt;", deliveryType, sendTicketCityID, orderRemark, pjs];
    
    return deliverInfo;
}

- (NSString *)generateCreditCardInfoXML
{
    NSString *cardInfoID       = [NSString stringWithFormat:@"&lt;CardInfoID&gt;%@&lt;/CardInfoID&gt;", _creditCardInfo.cardInfoID];
    NSString *creditCardType   = [NSString stringWithFormat:@"&lt;CreditCardType&gt;%@&lt;/CreditCardType&gt;", _creditCardInfo.creditCardType];
    NSString *creditCardNumber = [NSString stringWithFormat:@"&lt;CreditCardNumber&gt;%@&lt;/CreditCardNumber&gt;", _creditCardInfo.creditCardNumber];
    NSString *validity         = [NSString stringWithFormat:@"&lt;Validity&gt;%@&lt;/Validity&gt;", _creditCardInfo.validity];
    NSString *cardBin          = [NSString stringWithFormat:@"&lt;CardBin&gt;%@&lt;/CardBin&gt;", _creditCardInfo.cardBin];
    NSString *cardHolder       = [NSString stringWithFormat:@"&lt;CardHolder&gt;%@&lt;/CardHolder&gt;", _creditCardInfo.cardHolder];
    NSString *idCardType       = [NSString stringWithFormat:@"&lt;IdCardType&gt;%@&lt;/IdCardType&gt;", _creditCardInfo.idCardType];
    NSString *idNumber         = [NSString stringWithFormat:@"&lt;IdNumber&gt;%@&lt;/IdNumber&gt;", _creditCardInfo.idNumber];
    NSString *cvv2No           = [NSString stringWithFormat:@"&lt;CVV2No&gt;%@&lt;/CVV2No&gt;", _creditCardInfo.cvv2No];
    NSString *agreementCode    = [NSString stringWithFormat:@"&lt;AgreementCode&gt;%@&lt;/AgreementCode&gt;", _creditCardInfo.agreementCode];
    NSString *eid              = [NSString stringWithFormat:@"&lt;Eid&gt;%@&lt;/Eid&gt;", _creditCardInfo.eid];
    NSString *remark           = [NSString stringWithFormat:@"&lt;Remark&gt;%@&lt;/Remark&gt;", _creditCardInfo.remark];
    NSString *isClient         = [NSString stringWithFormat:@"&lt;IsClient&gt;%@&lt;/IsClient&gt;", (_creditCardInfo.isClient ? @"true" : @"false")];
    NSString *cCardPayFee      = [NSString stringWithFormat:@"&lt;CCardPayFee&gt;%f&lt;/CCardPayFee&gt;", _creditCardInfo.cCardPayFee];
    NSString *cCardPayFeeRate  = [NSString stringWithFormat:@"&lt;CCardPayFeeRate&gt;%f&lt;/CCardPayFeeRate&gt;", _creditCardInfo.cCardPayFeeRate];
    NSString *exponent         = [NSString stringWithFormat:@"&lt;Exponent&gt;%lu&lt;/Exponent&gt;", _creditCardInfo.exponent];
    NSString *exchangeRate     = [NSString stringWithFormat:@"&lt;ExchangeRate&gt;%@&lt;/ExchangeRate&gt;", _creditCardInfo.exchangeRate];
    NSString *fAmount          = [NSString stringWithFormat:@"&lt;FAmount&gt;%@&lt;/FAmount&gt;", _creditCardInfo.fAmount];

    NSString *creditCardInfo   = [NSString stringWithFormat:
                                  @"&lt;CreditCardInfo&gt;\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "&lt;/CreditCardInfo&gt;", cardInfoID, creditCardType, creditCardNumber, validity, cardBin, cardHolder, idCardType, idNumber, cvv2No, agreementCode, eid, remark, isClient, cCardPayFee, cCardPayFeeRate, exponent, exchangeRate, fAmount];

    NSString *payInfo          = [NSString stringWithFormat:
                                @"&lt;PayInfo&gt;\n"
                                "%@\n"
                                "&lt;/PayInfo&gt;", creditCardInfo];
    
    return payInfo;
}

@end
