//
//  NSString+Similarity.h
//
//  Created by B.H.Liu on 13-6-14.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Similarity)

/**
 *@param 
 *  other: the string for comparing with self
 *@Output
 *  an array of common sequence of the two strings
 */
- (NSArray*)LCS_WithString:(NSString*)other;

/**
 *@param
 *  other: the string for comparing with self
 *@Output
 *  the Levenshtein Distance of the two strings
 */
- (NSInteger)LD_WithString:(NSString*)other;

@end
