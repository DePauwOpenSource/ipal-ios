//
//  Question.h
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface Question : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *text;

//properties representing hidden field in question form
@property int answerId; // -1 for essay, otherwise the value of the choices
@property int questionId;
@property int activeQuestionId;
@property int courseId;
@property int userId;
@property int ipalId;
@property (nonatomic, strong) NSString *instructor;

- (NSDictionary *) getParametersForSubmission;

@end
