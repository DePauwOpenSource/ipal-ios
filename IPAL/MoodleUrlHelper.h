//
//  MoodleUrlHelper.h
//  IPAL
//
//  Created by DePauw on 3/29/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoodleUrlHelper : NSObject

//Check if the url is a valid url
+(bool) isValidUrl:(NSString *) url;

//return a list consisting of http and https versions of the provided url.
//the ViewController will try both of these urls when logging in.
+ (NSArray *) getPossibleUrls:(NSString *)url;


@end
