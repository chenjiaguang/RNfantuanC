//
//  RootModel.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/6.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "RootModel.h"

@implementation RootModel

- (NSString *)description {
    return [self yy_modelDescription];
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init]; return [self yy_modelInitWithCoder:aDecoder];
    
}
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
    
}
- (NSUInteger)hash {
    return [self yy_modelHash];
    
}
- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
    
}
/*
- (NSString *)debugDescription
{
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSString class]])
    {
        return self.debugDescription;
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil"; // 默认值为nil字符串
        [dictionary setObject:value forKey:name];
    }
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class], self, dictionary];
}
*/
@end
