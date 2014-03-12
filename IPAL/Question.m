//
//  Question.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "Question.h"

@implementation Question

-(NSString *) description
{
    return [NSString stringWithFormat:@"[Question type: %@, text: %@\nanswerId:%d, questionId: %d, activeQuestionId: %d, courseId: %d, userId: %d, ipalId: %d, instructor: %@"
            , self.type, self.text, self.answerId, self.questionId, self.activeQuestionId, self.courseId, self.userId, self.ipalId, self.instructor];
}

-(NSDictionary *)getParametersForSubmission
{
    //To suppress warning only. This method is supposed to be empty, see implementation in question subclasses.
    return @{};
}

@end
