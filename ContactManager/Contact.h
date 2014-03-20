//
//  Contact.h
//  syncengine
//
//  Created by Guillaume CASTELLANA on 2/12/13.
//  Copyright (c) 2013 Dylan Oudin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Contact : NSObject

@property (nonatomic, strong, readonly) NSString* firstName;
@property (nonatomic, strong, readonly) NSString* lastName;
@property (nonatomic, strong, readonly) NSString* email;

- (id) initWithDictionary:(NSDictionary*)aDic;
- (id) initWithName:(NSString*)aName andMail:(NSString*)anEmail;

- (BOOL) matchesWithMail:(NSString*)aMail;
- (BOOL) matchesWithDictionary:(NSDictionary*)aDic;
- (BOOL) containsString:(NSString*)aString;

- (NSString*) getFullName; // John Appleseed
- (NSString*) getShortName; // John OR john.appleseed (if only mail)
- (NSString*) getInitials; // JA

@end
