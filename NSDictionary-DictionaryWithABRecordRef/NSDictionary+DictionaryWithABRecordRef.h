//
//  NSDictionary+DictionaryWithABRecordRef.h
//  syncengine
//
//  Created by Guillaume CASTELLANA on 3/12/13.
//  Copyright (c) 2013 Dylan Oudin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface NSDictionary (DictionaryWithABRecordRef)

+ (NSDictionary*) dictionaryWithABRecordRef:(ABRecordRef)aRecord;

@end
