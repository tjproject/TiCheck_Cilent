//
//  PrintObject.m
//  mgen_viewHierarchy
//
//  Created by MgenLiu on 13-9-27.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import "PrintObject.h"
#import <objc/runtime.h>
#import "NSString+DateFormat.h"
#define PRINT_OBJ_LOGGING 1

@implementation PrintObject

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        id value = nil;
        @try {
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            value = [self getObjectInternal:[obj valueForKey:propName]];
            if(value != nil) {
                [dic setObject:value forKey:propName];
            }
        }
        @catch (NSException *exception) {
            [self logError:exception];
        }
        
    }
    return dic;
}

+ (void)print:(id)obj
{
    NSLog(@"%@", [self getObjectData:obj]);
}


+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}

+ (id)getObjectInternal:(id)obj
{
    if(!obj
       || [obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSDate class]]) {
        return [NSString stringFormatWithTime:obj];
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

+ (void)logError:(NSException*)exp
{
#if PRINT_OBJ_LOGGING
    NSLog(@"PrintObject Error: %@", exp);
#endif
}




+ (id)getObject:(id)object WithData:(NSDictionary *)dictionary
{
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    id key;
    NSArray* propertiesNameList = [self getPropertiesNameList:object];
    
    
    //unsigned int outCount, i;
    //objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (int i = 0; i<propertiesNameList.count; i++)
    {
        id propertyValue = [object valueForKey:(NSString *)[propertiesNameList objectAtIndex:i]];
        
    }
    
    
    
    
//    while ((key = [enumerator nextObject])) {
//        NSString *keyName = key;
//        id propertyValue = [object valueForKey:keyName];
//
//        if(!propertyValue
//           || [propertyValue isKindOfClass:[NSString class]]
//           || [propertyValue isKindOfClass:[NSNumber class]]
//           || [propertyValue isKindOfClass:[NSNull class]])
//        {
//            //
//            propertyValue = dictionary[keyName];
//        }
//        
//        if([propertyValue isKindOfClass:[NSArray class]]) {
//            NSArray *objarr = propertyValue;
//            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
//            for(int i = 0;i < objarr.count; i++) {
//                [self getObject:propertyValue WithData:[(NSArray *)dictionary[keyName] objectAtIndex:i]];
//            }
//            //return arr;
//        }
//        
//        if([propertyValue isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *objdic = propertyValue;
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
//            [self getObject:propertyValue WithData:dictionary];
////            for(NSString *key in objdic.allKeys) {
////                [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
////            }
//            //return dic;
//        }
//    }
//    
    
    
    return object;
}

+ (NSArray *)getPropertiesNameList:(id)object
{
    NSMutableArray * result = [[NSMutableArray alloc]init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [result addObject:propertyName];
    }
    free(properties);
    return result;
}

+ (NSDictionary *)getProperties:(id)object
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [object valueForKey:(NSString *)propertyName];
        if (propertyValue)
            [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}




@end
