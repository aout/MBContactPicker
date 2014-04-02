//
//  NSString+Mail.m
//  Nimbly
//
//  Created by Guillaume CASTELLANA on 5/2/14.
//  Copyright (c) 2014 Guillaume CASTELLANA. All rights reserved.
//

#import "NSString+Mail.h"

@implementation NSString (Mail)

- (BOOL) isAnEmailAdress {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (NSString*) stringByRemovingMailReplyQuotes
{
    NSString* messageString = @"";
    NSMutableString* mstr = [[NSMutableString alloc] init];
    
    // Create a Regex to remove Quotes + New Line separators
    NSString* pattern = @"^>.*(\\r|\\n)+";
    NSError* e = NULL;
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:NSRegularExpressionAnchorsMatchLines
                                                                        error:&e];
    [mstr appendString:self];
    [regex replaceMatchesInString:mstr
                          options:NSMatchingReportCompletion
                            range:NSMakeRange(0, [mstr length])
                     withTemplate:@""];
    
    
    // Then try to catch the line that precedes a quote
    NSTextCheckingResult* result = [self checkingResultOfTextPrecedingQuote:mstr];
    if (result)  {
        NSRange r = NSMakeRange(0, result.range.location);
        messageString = [mstr substringWithRange:r];
    } else {
        messageString = mstr;
    }
    // Get rid of useless white spaces and new lines at the start / end
    messageString = [messageString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return messageString;
}

- (NSTextCheckingResult*) checkingResultOfTextPrecedingQuote:(NSString*)aString
{
    NSTextCheckingResult* result = NULL;
    // Anything that has: "Letter or Number [...] <something@something>" in it
    NSString* pattern = @"[0-9A-Za-z].*<.*@.*>.*"; // TODO: IMPROVE IT (for GMail only?)
    NSError* e = NULL;
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:NSRegularExpressionAnchorsMatchLines
                                                                        error:&e];
    result = [regex firstMatchInString:aString options:0 range:NSMakeRange(0, [aString length])];
    return result;
}

@end
