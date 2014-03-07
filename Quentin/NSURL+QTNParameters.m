//
// Created by Florian Bürger on 19/02/14.
// Copyright (c) 2014 keslcod. All rights reserved.
//

#import "NSURL+QTNParameters.h"

@implementation NSURL (QTNParameters)

- (NSDictionary *)parameters
{
    NSString *query = [self query];
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    for (NSString *pair in parameters) {
        NSArray *bits = [pair componentsSeparatedByString:@"="];
        NSString *key = [bits[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [bits[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        pairs[key] = value;
    }
    return [pairs copy];
}

@end
