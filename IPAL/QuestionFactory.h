//
//  QuestionFactory.h
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "MultipleChoiceQuestion.h"
#import "EssayQuestion.h"

@interface QuestionFactory : NSObject

+ (Question *)createNewQuestionWithData:(NSData *) data; //Pass data from URL

@end
