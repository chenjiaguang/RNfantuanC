//
//  JSON+Helpers.m
//  mystar
//
//  Created by mos on 13-2-22.
//  Copyright (c) 2013年 medev. All rights reserved.
//

#import "JSON+Helpers.h"

@implementation NSDictionary (Utility)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key {
    if ( [[self allKeys]containsObject:key] ) {
        
        
    }else{
        //        return @"";
    }
    
    id object = [self objectForKey:key];
    
    if (object == [NSNull null]){
        return @" ";
    }
    return object;
}
- (id)objectForKeyNotBackNull:(id)key {
    if ( [[self allKeys]containsObject:key] ) {
        
        
    }else{
        return @"";
    }
    
    id object = [self objectForKey:key];
    
    if (object == [NSNull null]){
        return @" ";
    }
    return object;
}

- (NSDictionary *)deleteNull
{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@" " forKey:keyStr];
        }
        else{
            
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end