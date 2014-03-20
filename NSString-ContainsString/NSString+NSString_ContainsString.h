//
//  NSString+NSString_ContainsString.h
//  airmail
//
//  Created by Guillaume CASTELLANA on 22/10/13.
//  Copyright (c) 2013 Guillaume CASTELLANA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_ContainsString)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;

@end
