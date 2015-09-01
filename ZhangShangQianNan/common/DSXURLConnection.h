//
//  DSXURLConnection.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/16.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXURLConnection : NSURLConnection

+ (NSData *)dataWithURL:(NSString *)urlString;

@end
