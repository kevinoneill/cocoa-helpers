//
//  NSStringHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/14/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "NSStringHelper.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Helper)

- (BOOL)containsString:(NSString*)string {
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

- (long)longValue {
	return (long)[self longLongValue];
}

- (long long)longLongValue {
	NSScanner* scanner = [NSScanner scannerWithString:self];
	long long valueToGet;
	if([scanner scanLongLong:&valueToGet] == YES) {
		return valueToGet;
	} else {
		return 0;
	}
}

/*
 * We did not write the method below
 * It's all over Google and we're unable to find the original author
 * Please contact info@enormego.com with the original author and we'll
 * Update this comment to reflect credit
 */
- (NSString*)md5 {
	const char* string = [self UTF8String];
	unsigned char result[16];
	CC_MD5(string, strlen(string), result);
	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
												result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], 
												result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];

	return [hash lowercaseString];
}

/*
 * Again, we did not write the methods below
 * We found them on Google a long time ago, and do not remember where
 * Please contact info@enormego.com with the original author and we'll
 * Update this comment to reflect credit
 */

- (NSString*)stringByTruncatingToLength:(int)length {
	return [self stringByTruncatingToLength:length direction:NSTruncateStringPositionEnd];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom {
	return [self stringByTruncatingToLength:length direction:truncateFrom withEllipsisString:@"..."];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis {
	NSMutableString *result = [[NSMutableString alloc] initWithString:self];
	NSString *immutableResult;
	
	if([result length] <= length) {
		[result release];
		return self;
	}
	
	unsigned int charactersEachSide = length / 2;
	
	NSString* first;
	NSString* last;
	
	switch(truncateFrom) {
		case NSTruncateStringPositionStart:
			[result insertString:ellipsis atIndex:[result length] - length + [ellipsis length] ];
			immutableResult  = [[result substringFromIndex:[result length] - length] copy];
			[result release];
			return [immutableResult autorelease];
		case NSTruncateStringPositionMiddle:
			first = [result substringToIndex:charactersEachSide - [ellipsis length]+1];
			last = [result substringFromIndex:[result length] - charactersEachSide];
			immutableResult = [[[NSArray arrayWithObjects:first, last, NULL] componentsJoinedByString:ellipsis] copy];
			[result release];
			return [immutableResult autorelease];
		default:
		case NSTruncateStringPositionEnd:
			[result insertString:ellipsis atIndex:length - [ellipsis length]];
			immutableResult  = [[result substringToIndex:length] copy];
			[result release];
			return [immutableResult autorelease];
	}
}

@end
