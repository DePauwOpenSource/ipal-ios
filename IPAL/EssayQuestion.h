//
//  EssayQuestion.h
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "Question.h"

@interface EssayQuestion : Question

@property (nonatomic, strong) NSString *answer;

- (id) initWithText:(NSString *)text;

@end
