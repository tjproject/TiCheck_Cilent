//
//  SoapRequest.m
//  Test
//
//  Created by Boyi on 3/2/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "SoapRequest.h"
#import "ASIHTTPRequest.h"

const NSArray *___FlightRequestFileName;

#define cFlightRequestFileNameGet (___FlightRequestFileName == nil ? ___FlightRequestFileName = [[NSArray alloc] initWithObjects:\
@"Flight/DomesticFlight/OTA_FlightSearch.asmx",\
@"Flight/DomesticFlight/OTA_FltSaveOrder.asmx",\
@"Flight/DomesticFlight/OTA_FltCancelOrder.asmx",\
@"Flight/DomesticFlight/OTA_FltOrderList.asmx",\
@"Flight/DomesticFlight/OTA_FltViewOrder.asmx",\
@"Flight/DomesticFlight/OTA_GetStatusChangedOrders.asmx",\
@"User/OTA_UserUniqueID.asmx", nil] : ___FlightRequestFileName)

#define cFlightRequestFileNameString(fileName) ([cFlightRequestFileNameGet objectAtIndex:fileName])

@implementation SoapRequest

#pragma mark SOAP 1.2

+ (ASIHTTPRequest *)getASISoap12RequestWithURL:(NSString *)webURL
                             flightRequestType:(FlightRequestType)requestType
                                  xmlNameSpace:(NSString *)nameSpace
                                webServiceName:(NSString *)serviceName
                                xmlRequestBody:(NSString *)requestBody
{
    return [self getASISoap12Request:webURL
                      webServiceFile:cFlightRequestFileNameString(requestType)
                        xmlNameSpace:nameSpace
                      webServiceName:serviceName
                      xmlRequestBody:requestBody];
}

+ (NSString *)getSoap12WebServiceResponseWithURL:(NSString *)webURL
                               flightRequestType:(FlightRequestType)requestType
                                    xmlNameSpace:(NSString *)nameSpace
                                  webServiceName:(NSString *)serviceName
                                  xmlRequestBody:(NSString *)requestBody
{
    return [self getSoap12WebServiceResponse:webURL
                              webServiceFile:cFlightRequestFileNameString(requestType)
                                xmlNameSpace:nameSpace
                              webServiceName:serviceName
                              xmlRequestBody:requestBody];
}

#pragma mark SOAP 1.1

+ (ASIHTTPRequest *)getASISoap11RequestWithURL:(NSString *)webURL
                             flightRequestType:(FlightRequestType)requestType
                                  xmlNameSpace:(NSString *)nameSpace
                                webServiceName:(NSString *)serviceName
                                xmlRequestBody:(NSString *)requestBody
{
    return [self getASISoap11Request:webURL
                      webServiceFile:cFlightRequestFileNameString(requestType)
                        xmlNameSpace:nameSpace
                      webServiceName:serviceName
                      xmlRequestBody:requestBody];
}

+ (NSString *)getSoap11WebServiceResponseWithURL:(NSString *)webURL
                               flightRequestType:(FlightRequestType)requestType
                                    xmlNameSpace:(NSString *)nameSpace
                                  webServiceName:(NSString *)serviceName
                                  xmlRequestBody:(NSString *)requestBody
{
    NSLog(@"request type = %lu, string = %@", requestType, cFlightRequestFileNameString(requestType));
    return [self getSoap11WebServiceResponse:webURL
                              webServiceFile:cFlightRequestFileNameString(requestType)
                                xmlNameSpace:nameSpace
                              webServiceName:serviceName
                              xmlRequestBody:requestBody];
}

#pragma mark SOAP 1.2 Helper Methods

+ (ASIHTTPRequest *)getASISoap12Request:(NSString *)webURL
                         webServiceFile:(NSString *)fileName
                           xmlNameSpace:(NSString *)nameSpace
                         webServiceName:(NSString *)serviceName
                         xmlRequestBody:(NSString *)requestBody
{
    NSString *soapMsgBegin = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                              "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                              "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                              "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
                              "<soap12:Body>\n"
                              "<%@ xmlns=\"%@\">\n"
                              "<requestXML>\n", serviceName, nameSpace];
    NSString *soapMsgEnd = [NSString stringWithFormat:
                            @"</requestXML>\n"
                            "</%@>\n"
                            "</soap12:Body>\n"
                            "</soap12:Envelope>\n", serviceName];

    NSString *soapMsg = [soapMsgBegin stringByAppendingFormat:@"%@%@", requestBody, soapMsgEnd];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", webURL, fileName]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)[soapMsg length]];
    
    // 设置SOAP消息的Header，SOAP 1.2下无'SOAPAction'
    [request addRequestHeader:@"Content-Type" value:@"application/soap+xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];

    return request;
}

+ (NSString *)getSoap12WebServiceResponse:(NSString *)webURL
                           webServiceFile:(NSString *)fileName
                             xmlNameSpace:(NSString *)nameSpace
                           webServiceName:(NSString *)serviceName
                           xmlRequestBody:(NSString *)requestBody
{
    ASIHTTPRequest *request = [self getASISoap12Request:webURL
                                         webServiceFile:fileName
                                           xmlNameSpace:nameSpace
                                         webServiceName:serviceName
                                         xmlRequestBody:requestBody];
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        return [request responseString];
    } else {
        return [NSString stringWithFormat:@"Service Error. %@", [error localizedDescription]];
    }
}

#pragma mark SOAP 1.1 Helper Methods

+ (ASIHTTPRequest *)getASISoap11Request:(NSString *)webURL
                         webServiceFile:(NSString *)fileName
                           xmlNameSpace:(NSString *)nameSpace
                         webServiceName:(NSString *)serviceName
                         xmlRequestBody:(NSString *)requestBody
{
    NSString *soapMsgBegin = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                              "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                              "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                              "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                              "<soap:Body>\n"
                              "<%@ xmlns=\"%@\">\n"
                              "<requestXML>\n", serviceName, nameSpace];
    NSString *soapMsgEnd = [NSString stringWithFormat:
                            @"</requestXML>\n"
                            "</%@>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>\n", serviceName];
    
    NSString *soapMsg = [soapMsgBegin stringByAppendingFormat:@"%@%@", requestBody, soapMsgEnd];
    
//    NSLog(@"soap msg = %@", soapMsg);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", webURL, fileName]];
//    NSLog(@"url = %@", url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", (unsigned long)[soapMsg length]];
    
    // 设置SOAP消息的Header
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@", nameSpace, serviceName]];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    return request;
}

+ (NSString *)getSoap11WebServiceResponse:(NSString *)webURL
                           webServiceFile:(NSString *)fileName
                             xmlNameSpace:(NSString *)nameSpace
                           webServiceName:(NSString *)serviceName
                            xmlRequestBody:(NSString *)requestBody
{
    ASIHTTPRequest *request = [self getASISoap11Request:webURL
                                         webServiceFile:fileName
                                           xmlNameSpace:nameSpace
                                         webServiceName:serviceName
                                         xmlRequestBody:requestBody];
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        return [request responseString];
    } else {
        return [NSString stringWithFormat:@"Service Error. %@", [error localizedDescription]];
    }
}

@end