//
//  DSXURLConnection.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/16.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "DSXURLConnection.h"

@implementation DSXURLConnection

+ (NSData *)dataWithURL:(NSString *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *data = [self sendSynchronousRequest:request returningResponse:nil error:nil];
    return data;
}
@end
