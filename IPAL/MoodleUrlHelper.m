//
//  MoodleUrlHelper.m
//  IPAL
//
//  Created by DePauw on 3/29/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "MoodleUrlHelper.h"

@implementation MoodleUrlHelper

+(bool) isValidUrl:(NSString *) url {
    NSString *urlRegex = @"^http(s)?:\\/\\/[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+([a-zA-Z0-9]+\\/?)*$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegex
                                                                           options: NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:url
                                                        options:0
                                                          range:NSMakeRange(0, [url length])];
    NSLog(@"url: %@ => %lu", url,(unsigned long)numberOfMatches);
    return numberOfMatches>0;
}

+(NSArray *) getPossibleUrls:(NSString *)url {
    NSString *strippedUrl = [MoodleUrlHelper stripUrl:url];
    NSString *http = [NSString stringWithFormat:@"http://%@/", strippedUrl];
    NSString *https = [NSString stringWithFormat:@"https://%@/", strippedUrl];
    return @[http, https];
}

//strip url of protocols ("http://" or "https://") and the last slash
//example: https://moodle.depauw.edu/ will become moodle.depauw.edu
+(NSString *) stripUrl:(NSString *)url {
    //NSLog(@"Start stripping Url");
    NSString *strippedUrl;
    NSString *https = [url substringToIndex:8];
    NSString *http = [url substringToIndex:7];
    if ([https isEqualToString:@"https://"]) {
        strippedUrl = [url substringFromIndex:8];
    } else if ([http isEqualToString:@"http://"]) {
        strippedUrl = [url substringFromIndex:7];
    }
    if ([strippedUrl characterAtIndex:strippedUrl.length-1] == '/') {
        strippedUrl = [strippedUrl substringToIndex:strippedUrl.length-1];
    }
    //NSLog(@"Stripped %@ into %@", url, strippedUrl);
    return strippedUrl;
}

@end
