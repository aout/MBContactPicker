//
//  ContactManager.h
//  syncengine
//
//  Created by Guillaume CASTELLANA on 2/12/13.
//  Copyright (c) 2013 Dylan Oudin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@class Contact;

@interface ContactManager : NSObject

- (void) fetchContactsFromAddressBook:(ABAddressBookRef)addressBook;
- (Contact*) createContactWithDictionary:(NSDictionary*)aDic;
- (Contact*) createContactWithName:(NSString*)aName andMail:(NSString*)anEmail;
- (Contact*) getContactWithDictionary:(NSDictionary*)aDic orCreateOne:(BOOL)creationFlag;
- (Contact*) getContactWithName:(NSString*)aName andMail:(NSString*)anEmail orCreateOne:(BOOL)creationFlag;
- (Contact*) getContactWithMail:(NSString*)aMail;
- (NSArray*) getContacts;
- (NSArray*) getFirst:(unsigned int)number contactsContainingString:(NSString*)aString;

+ (ContactManager*) sharedInstance;
+ (Contact*) getContactWithDictionary:(NSDictionary*)aDic orCreateOne:(BOOL)creationFlag;
+ (Contact*) getContactWithName:(NSString*)aName andMail:(NSString*)anEmail orCreateOne:(BOOL)creationFlag;
+ (Contact*) getContactWithMail:(NSString*)aMail;
+ (NSArray*) getContacts;
+ (NSArray*) getFirst:(unsigned int)number contactsContainingString:(NSString*)string; // 0 for all contacts

@end
