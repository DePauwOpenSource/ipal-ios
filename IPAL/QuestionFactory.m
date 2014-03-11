//
//  QuestionFactory.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "QuestionFactory.h"

@implementation QuestionFactory

+ (Question *)createNewQuestionWithData:(NSData *)data
{    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    //Set the question type
    NSArray *elements = [doc searchWithXPathQuery:@"//p[@id='questiontype'][1]"];
    TFHppleElement *type = elements[0];
    
    NSArray *textElement = [doc searchWithXPathQuery:@"//legend[1]"];
    TFHppleElement *text = textElement[0];
    
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
        return [[MultipleChoiceQuestion alloc] initWithText:[text text] withChoices:choices];
    }
    else if([[type text] isEqualToString:@"essay"])
    {
        NSArray *elements = [doc searchWithXPathQuery:@"//legend[1]"];
        TFHppleElement *text = elements[0];
        EssayQuestion *eq = [[EssayQuestion alloc] initWithText:[text text]];
        return eq;
    }
    
    return Nil;
}

@end
