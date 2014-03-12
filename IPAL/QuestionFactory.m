//
//  QuestionFactory.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "QuestionFactory.h"

@interface QuestionFactory()

@end

@implementation QuestionFactory

+ (Question *)createNewQuestionWithData:(NSData *)data
{    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    //Set the question type
    NSArray *elements = [doc searchWithXPathQuery:@"//p[@id='questiontype'][1]"];
    TFHppleElement *type = elements[0];
    
    NSArray *textElement = [doc searchWithXPathQuery:@"//legend[1]"];
    TFHppleElement *text = textElement[0];
    
    Question *question;
    
    if([[type text] isEqualToString:@"multichoice"])
    {
        NSLog(@"Found MCQ...");
        NSMutableArray *choices;
        elements = [doc searchWithXPathQuery:@"//label"];
        for(TFHppleElement *e in elements)
        {
            [choices addObject:[e text]];
        }
        NSLog(@"Populated choices");
        question = [[MultipleChoiceQuestion alloc] initWithText:[text text] withChoices:choices];
    }
    else if([[type text] isEqualToString:@"essay"])
    {
        NSArray *elements = [doc searchWithXPathQuery:@"//legend[1]"];
        TFHppleElement *text = elements[0];
        question = [[EssayQuestion alloc] initWithText:[text text]];
    }
    
    //populate properties from hidden input
    int answerId = [[QuestionFactory getInputWithName:@"answer_id" fromDoc:doc] intValue];
    int questionId = [[QuestionFactory getInputWithName:@"question_id" fromDoc:doc] intValue];
    int activeQuestionId = [[QuestionFactory getInputWithName:@"active_question_id" fromDoc:doc] intValue];
    int courseId = [[QuestionFactory getInputWithName:@"course_id" fromDoc:doc] intValue];
    int userId = [[QuestionFactory getInputWithName:@"user_id" fromDoc:doc] intValue];
    int ipalId = [[QuestionFactory getInputWithName:@"ipal_id" fromDoc:doc] intValue];
    NSString *instructor = [QuestionFactory getInputWithName:@"instructor" fromDoc:doc];
    question.answerId = answerId;
    question.questionId = questionId;
    question.activeQuestionId = activeQuestionId;
    question.courseId = courseId;
    question.userId = userId;
    question.ipalId = ipalId;
    question.instructor = instructor;
    
    return question;
}

+(NSString *) getInputWithName:(NSString *) name fromDoc: (TFHpple *) doc
{
    NSString *query = [NSString stringWithFormat:@"//input[@name='%@'][1]", name];
    NSArray *elements = [doc searchWithXPathQuery:query];
    return [elements[0] objectForKey:@"value"];
}

@end
