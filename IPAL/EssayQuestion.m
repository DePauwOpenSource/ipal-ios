//
//  EssayQuestion.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "EssayQuestion.h"

@implementation EssayQuestion

- (id)initWithText:(NSString *)text
{
    self = [super init];
    self.text = text;
    self.type = @"essay";
    self.answer = @"";
    return self;
}


-(NSString *) description {
    return [NSString stringWithFormat:@"%@\nCurrentAnswer: %@]", [super description], self.answer];
}



@end
