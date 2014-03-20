//
//  Contact.m
//  syncengine
//
//  Created by Guillaume CASTELLANA on 2/12/13.
//  Copyright (c) 2013 Dylan Oudin. All rights reserved.
//

#import "Contact.h"
#import "NSString+NSString_ContainsString.h"


@interface Contact ()

@property (nonatomic, strong, readwrite) NSString* firstName;
@property (nonatomic, strong, readwrite) NSString* lastName;
@property (nonatomic, strong, readwrite) NSString* email;
@property (nonatomic, strong) NSDictionary* dic;

@end

@implementation Contact

- (id)init
{
    self = [super init];
    if (self) {
        self.dic = Nil;
        self.firstName = @"";
        self.lastName = @"";
        self.email = @"";
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)aDic
{
    self = [self init];
    if (self) {
        // We should not accept people without mail
        self.firstName = aDic[@"firstName"];
        self.lastName = aDic[@"lastName"];
        self.email = aDic[@"email"];
        self.dic = aDic;
    }
    return self;
}

- (id) initWithName:(NSString*)aName andMail:(NSString*)anEmail
{
    self = [self init];
    if (self) {
        // Try to cut our name in two parts separated by the first space
        NSRange firstSpace = [aName rangeOfString:@" "];
        if (firstSpace.location != NSNotFound) {
            self.firstName = [aName substringToIndex:firstSpace.location];
            self.lastName = [aName substringFromIndex:NSMaxRange(firstSpace)];
        } else {
            // If it doesn't work then just set is as First Name
            self.firstName = aName;
        }
        self.email = anEmail;
    }
    return self;
}

- (BOOL) matchesWithMail:(NSString*)aMail
{
    return ([self.email isEqualToString:aMail]);
}

- (BOOL) matchesWithDictionary:(NSDictionary*)aDic
{
    return ([self.dic isEqualToDictionary:aDic]);
}

- (BOOL) containsString:(NSString*)string
{
    // FIRST CHECK IF IT HAS A MAIL
    if (![self.email length]) {
        return false;
    }
    if ([self.email containsString:string]) {
        return true;
    }
    if ([self.firstName containsString:string]) {
        return true;
    }
    if ([self.lastName containsString:string]) {
        return true;
    }
    return false;
}

- (NSString*) getFullName
{
    NSString* fullName = @"";
    if ([self.lastName length]) {
        fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else {
        fullName = [self getShortName];
    }
    return [fullName capitalizedString];
}

- (NSString*) getShortName
{
    NSString* shortName = @"";
    if ([self.firstName length]) {
        shortName = self.firstName;
    } else {
        shortName = [self.email componentsSeparatedByString: @"@"][0];
    }
    return [shortName capitalizedString];
}

- (NSString*) getInitials
{
    NSMutableString* initials = [[NSMutableString alloc] init];
    [initials appendString:[[self getShortName] substringToIndex:1]];
    if ([self.lastName length]) {
        [initials appendString:[self.lastName substringToIndex:1]];
        
    }
    return [initials uppercaseString];
}

@end
