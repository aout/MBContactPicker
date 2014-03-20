//
//  ContactManager.m
//  syncengine
//
//  Created by Guillaume CASTELLANA on 2/12/13.
//  Copyright (c) 2013 Dylan Oudin. All rights reserved.
//

#import "ContactManager.h"
#import "Contact.h"
#import "NSDictionary+DictionaryWithABRecordRef.h"


@interface ContactManager ()

@property (nonatomic, strong, readwrite) NSMutableArray* contacts;

@end

@implementation ContactManager

- (id)init
{
    self = [super init];
    if (self) {
        self.contacts = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Contact Manager

- (void) fetchContactsFromAddressBook:(ABAddressBookRef)addressBook
{
    ABAddressBookRef ab = Nil;
    if (addressBook) {
        ab = addressBook;
    } else {
        ab = ABAddressBookCreateWithOptions(Nil, Nil);
    }
    // Get permission Status
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    // If we do not have it
    if (status == kABAuthorizationStatusNotDetermined) {
        // Create a Handler to receive the access request
        ABAddressBookRequestAccessCompletionHandler handler = ^(bool granted, CFErrorRef error) {
            // If the permission if granted
            if (granted) {
                // Call ourselves back with the adress book
                [self fetchContactsFromAddressBook:ab];
                return;
            }
        };
        // And ask for it
        ABAddressBookRequestAccessWithCompletion(ab, handler);
    } else  if (status == kABAuthorizationStatusAuthorized) {
        // Get all records from AB
        NSArray* records = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(ab);
        // Iterate
        for (unsigned int i = 0; i < [records count]; ++i) {
            // Create a dictionary for each record
            ABRecordRef record = (__bridge ABRecordRef)(records[i]);
            NSDictionary* recordDic = [NSDictionary dictionaryWithABRecordRef:record];
            // And since the dictionary we created can hold multiple mail adress
            for (NSString* mail in recordDic[@"emails"]) {
                // Create a single dictionary for each mail adress
                NSDictionary* contactDic = @{
                                             @"firstName" : recordDic[@"firstName"],
                                             @"lastName" : recordDic[@"lastName"],
                                             @"email" : mail
                                             };
                // Then create a contact with it
                [self getContactWithDictionary:contactDic orCreateOne:YES];
            }
        }
    }
}

- (Contact*) createContactWithDictionary:(NSDictionary*)aDic
{
    Contact* contact = [[Contact alloc] initWithDictionary:aDic];
    [self.contacts addObject:contact];
    return contact;
}

- (Contact*) createContactWithName:(NSString*)aName andMail:(NSString*)anEmail
{
    Contact* contact = [[Contact alloc] initWithName:aName andMail:anEmail];
    [self.contacts addObject:contact];
    return contact;
}

- (Contact*) getContactWithDictionary:(NSDictionary*)aDic orCreateOne:(BOOL)creationFlag
{
    Contact* matchedContact = [self getContactWithMail:aDic[@"email"]];
    if (matchedContact == Nil && creationFlag) {
        matchedContact = [self createContactWithDictionary:aDic];
    }
    return matchedContact;
}

- (Contact*) getContactWithName:(NSString*)aName andMail:(NSString*)anEmail orCreateOne:(BOOL)creationFlag
{
    Contact* matchedContact = [self getContactWithMail:anEmail];
    if (matchedContact == Nil && creationFlag) {
        matchedContact = [self createContactWithName:aName andMail:anEmail];
    }
    return matchedContact;
}

- (Contact*) getContactWithMail:(NSString*)aMail
{
    Contact* matchedContact = Nil;
    // First search for it in the list
    for (Contact* contact in self.contacts) {
        if ([contact matchesWithMail:aMail]) {
            matchedContact = contact;
            break;
        }
    }
    return matchedContact;
}

- (NSArray*) getContacts
{
    return self.contacts;
}

- (NSArray*) getFirst:(unsigned int)number contactsContainingString:(NSString*)aString
{
    NSIndexSet* indexes = [self.contacts indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        static int nbrOfMatches = 0;
        
        // Try to match
        Contact* contact = (Contact*) obj;
        BOOL matches = [contact containsString:aString];
        nbrOfMatches += matches;
        
        // Do we have enough (never stop if number == 0)
        if (nbrOfMatches >= number && number != 0) {
            *stop = YES;
        }
        
        return matches;
    }];
    return [self.contacts objectsAtIndexes:indexes];
}

#pragma mark - Statics

+ (ContactManager*) sharedInstance
{
    static ContactManager* instance = Nil;
    if (instance == Nil) {
        instance = [[ContactManager alloc] init];
        [instance fetchContactsFromAddressBook:Nil];
    }
    return instance;
}

+ (Contact*) getContactWithDictionary:(NSDictionary*)aDic orCreateOne:(BOOL)creationFlag
{
    ContactManager* cm = [ContactManager sharedInstance];
    return [cm getContactWithDictionary:aDic orCreateOne:creationFlag];
}

+ (Contact*) getContactWithName:(NSString*)aName andMail:(NSString*)anEmail orCreateOne:(BOOL)creationFlag
{
    ContactManager* cm = [ContactManager sharedInstance];
    return [cm getContactWithName:aName andMail:anEmail orCreateOne:creationFlag];
}

+ (Contact*) getContactWithMail:(NSString*)aMail
{
    ContactManager* cm = [ContactManager sharedInstance];
    return [cm getContactWithMail:aMail];
}

+ (NSArray*) getContacts
{
    ContactManager* cm = [ContactManager sharedInstance];
    return [cm getContacts];
}

+ (NSArray*) getFirst:(unsigned int)number contactsContainingString:(NSString*)aString
{
    ContactManager* cm = [ContactManager sharedInstance];
    return [cm getFirst:number contactsContainingString:aString];
}

@end
