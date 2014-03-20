//
//  NSString+NSString_ContainsString.m
//  airmail
//
//  Created by Guillaume CASTELLANA on 22/10/13.
//  Copyright (c) 2013 Guillaume CASTELLANA. All rights reserved.
//

#import "NSString+NSString_ContainsString.h"

@implementation NSString (NSString_ContainsString)

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:NSCaseInsensitiveSearch];
}

@end
