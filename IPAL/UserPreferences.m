//
//  UserPreferences.m
//  IPAL
//
//  Created by DePauw on 3/30/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "UserPreferences.h"

@implementation UserPreferences

+(void) saveUrl:(NSString *) url{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:@"url"];
    NSLog(@"URL saved: %@", url);
}

+(NSString *) getUrl {
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
    if (url) {
       return url;
    } else {
        return @"";
    }
}

+(void) saveUsername:(NSString *)username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
    NSLog(@"Username saved: %@", username);
}

+(NSString *) getUsername {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    if (username) {
        return username;
    } else {
        return @"";
    }
}
@end
