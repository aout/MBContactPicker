//
//  NSDictionary+DictionaryWithABRecordRef.m
//  syncengine
//
//  Created by Guillaume CASTELLANA on 3/12/13.
//  Copyright (c) 2013 Dylan Oudin. All rights reserved.
//

#import "NSDictionary+DictionaryWithABRecordRef.h"

@implementation NSDictionary (DictionaryWithABRecordRef)

+ (NSDictionary*) dictionaryWithABRecordRef:(ABRecordRef)aRecord
{
    NSDictionary* recordDic = Nil;
    
    NSString* firstName = (__bridge NSString*)ABRecordCopyValue(aRecord, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge NSString*)ABRecordCopyValue(aRecord, kABPersonLastNameProperty);

    // Put all mail adresses in an array
    NSMutableArray* mailArray = [[NSMutableArray alloc] init];
    ABMultiValueRef mails = ABRecordCopyValue(aRecord, kABPersonEmailProperty);
    for (CFIndex j = 0; j < ABMultiValueGetCount(mails); j++)
    {
        NSString* email = (__bridge NSString*) ABMultiValueCopyValueAtIndex(mails, j);
        [mailArray addObject:email];
    }
    
    recordDic = @{
                  @"firstName" : firstName ? firstName : @"",
                  @"lastName" : lastName ? lastName : @"",
                  @"emails" : mailArray
                  };
    
    return recordDic;
}

@end
