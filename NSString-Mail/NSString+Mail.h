//
//  NSString+Mail.h
//  Nimbly
//
//  Created by Guillaume CASTELLANA on 5/2/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Mail)

- (BOOL) isAnEmailAdress;
- (NSString*) stringByRemovingMailReplyQuotes;

@end
