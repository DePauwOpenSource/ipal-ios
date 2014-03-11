//
//  MultipleChoiceQuestion.h
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "Question.h"

@interface MultipleChoiceQuestion : Question

- (id)initWithText:(NSString *)text withChoices:(NSArray *)choices;

@property (nonatomic, strong) NSArray *choices;

@end
