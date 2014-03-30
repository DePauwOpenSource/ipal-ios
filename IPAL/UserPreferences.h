//
//  UserPreferences.h
//  IPAL
//
//  Created by DePauw on 3/30/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject

+(void) saveUrl:(NSString *)url;
+(NSString *) getUrl;
+(void) saveUsername:(NSString *)username;
+(NSString *) getUsername;

@end
