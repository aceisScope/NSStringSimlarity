//
//  NSString+Similarity.m
//
//  Created by B.H.Liu on 13-6-14.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import "NSString+Similarity.h"
#import <objc/runtime.h>

static char arrayKey;

@implementation NSString (Similarity)


enum decreaseDir {kInit = 0, kLeftUp, kUp, kLeft};

- (NSArray*)LCS_WithString:(NSString*)other
{
    if (other == nil) {
        return 0;
    }
    
    size_t m = self.length;
    size_t n = other.length;
    
    if (m == 0 || n == 0) {
        return 0;
    }
    
    NSMutableArray *c = [NSMutableArray arrayWithCapacity:m + 1];
    NSMutableArray *b = [NSMutableArray arrayWithCapacity:m + 1];
    
    for(int i = 0; i <= m; i++ ){
        
        c[i] = [NSMutableArray arrayWithCapacity:n + 1];
        b[i] = [NSMutableArray arrayWithCapacity:n + 1];
        
        for (int j = 0; j <= n; j++) {
            c[i][j] = @(0);
            b[i][j] = @(kInit);
        }
    }
    
    for (int i = 0; i < m; i++)
	{
        for (int j = 0; j < n; j++)
        {
            if ([[self substringWithRange:NSMakeRange(i, 1)] isEqual:[other substringWithRange:NSMakeRange(j, 1)]])
            {
                c[i + 1][j + 1] = @([c[i][j] integerValue] + 1);
                b[i + 1][j + 1] = @(kLeftUp); //↖
            }
            else if ([c[i][j + 1] integerValue]>= [c[i + 1][j] integerValue])
            {
                c[i + 1][j + 1] = @([c[i][j + 1]integerValue]);
                b[i + 1][j + 1] = @(kUp);  //↑
            }
            else
            {
                c[i + 1][j + 1] = @([c[i + 1][j]integerValue]);
                b[i + 1][j + 1] = @(kLeft); //←
            }
            
        }
        
	}
    
    NSMutableArray * charArray = objc_getAssociatedObject(self, &arrayKey);
    if (charArray)
    {
        charArray = nil;
    }
    charArray = [NSMutableArray array];
    objc_setAssociatedObject(self, &arrayKey, charArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self LCS_Print:b withString:other row:m andColumn:n];
    
    //return [c[m][n] integerValue];
    return charArray;
}

/** Print a LCS of two strings
 * @param LCS_direction: a 2-dimension matrix which records the direction of LCS generation
 *                other: the second string
 *                  row: the row index in the matrix LCS_direction
 *                  col: the column index in the matrix LCS_direction
**/
- (void)LCS_Print:(NSArray*)direction
      withString:(NSString*)other
              row:(NSInteger)i
        andColumn:(NSInteger)j
{
    if (other == nil ) {
        return;
    }
    
    size_t length1 = self.length;
    size_t length2 = other.length;
    
    if(length1 == 0 || length2 == 0 || i == 0 || j == 0){
        return;
    }
    
    if ([direction[i][j] integerValue]== kLeftUp)
	{
        NSLog(@"%@ %@ ", self, [self substringWithRange: NSMakeRange(i-1, 1)]);  //reverse
        
        NSMutableArray * charArray = objc_getAssociatedObject(self, &arrayKey);
        [charArray insertObject:[self substringWithRange: NSMakeRange(i-1, 1)] atIndex:0];
        
        [self LCS_Print:direction withString:other row:i-1 andColumn:j-1];
	}
	else if ([direction[i][j] integerValue]== kUp)
    {
        [self LCS_Print:direction withString:other row:i-1 andColumn:j];
    }
	else
    {
        [self LCS_Print:direction withString
                       :other row:i andColumn:j-1];
    }
}

- (NSInteger)LD_WithString:(NSString*)other
{
    //creating and retaining a matrix of size self.length+1 by other.length+1
    
    if (other == nil) {
        return self.length;
    }
    
    size_t m = self.length;
    size_t n = other.length;
    
    if (m == 0 || n == 0) {
        return abs(m-n);
    }
    
    NSMutableArray *d = [NSMutableArray arrayWithCapacity:m + 1];
    for(int i = 0; i <= m; i++ ){
        
        d[i] = [NSMutableArray arrayWithCapacity:n + 1];
        d[i][0] = @(i);
    }
    
    for (int j = 0; j <= n; j++) {
        d[0][j] = @(j);
    }
    
    for (int i = 1; i<= m; i ++)
    {
        for (int j = 1; j<= n; j++)
        {
            
            int cost = ![[self substringWithRange:NSMakeRange(i-1, 1)] isEqual:[other substringWithRange:NSMakeRange(j-1, 1)]];
            
            int min1 = [d[i - 1][j] integerValue] + 1;
            int min2 = [d[i][j - 1] integerValue]+ 1;
            int min3 = [d[i - 1][j - 1] integerValue] + cost;
            
            d[i][j] = @(MIN(MIN(min1, min2), min3));
        }
    }
    
    return [d[m][n] integerValue];
}

@end
