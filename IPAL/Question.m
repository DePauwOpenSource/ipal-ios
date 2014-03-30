//
//  Question.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "Question.h"

@implementation Choice

-(id) initWithValue:(NSString *)value withText:(NSString *)text {
    self = [[Choice alloc] init];
    if (self) {
        _value = value;
        _text = text;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"(%@: %@)", self.text, self.value];
}

@end

@implementation Question

NSString *const MULTIPLE_CHOICE = @"multichoice";
NSString *const ESSAY = @"essay";
NSString *const NO_CURRENT = @"nocurrentquestion";

-(NSString *) description
{
    return [NSString stringWithFormat:@"[Question type: %@, text: %@\nanswerId:%d, questionId: %d, activeQuestionId: %d, courseId: %d, userId: %d, ipalId: %d, instructor: %@"
            , self.type, self.text, self.answerId, self.questionId, self.activeQuestionId, self.courseId, self.userId, self.ipalId, self.instructor];
}

-(NSDictionary *)getParametersForSubmission
{
    return @{@"answer_id": [NSNumber numberWithInt:self.answerId],
             @"question_id": [NSNumber numberWithInt:self.questionId],
            @"active_question_id": [NSNumber numberWithInt:self.activeQuestionId],
             @"course_id": [NSNumber numberWithInt:self.courseId],
             @"user_id": [NSNumber numberWithInt:self.userId],
             @"ipal_id": [NSNumber numberWithInt:self.ipalId],
             @"instructor": self.instructor,
             @"submit": @"Submit"};

}
@end
