//
//  MultipleChoiceQuestion.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "MultipleChoiceQuestion.h"

@implementation MultipleChoiceQuestion

- (id)initWithText:(NSString *)text withChoices:(NSArray *)choices
{
    self = [super init];
    self.text = text;
    self.choices = choices;
    self.type = @"multiplechoice";
    
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@\nChoices: %@]", [super description], self.choices];
}

@end
