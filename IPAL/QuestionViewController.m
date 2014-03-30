//
//  QuestionViewController.m
//  IPAL
//
//  Created by Tarun Verghis on 3/10/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionView.h"
#import "EssayQuestionView.h"
#import "Question.h"
#import "AFNetworking.h"
#import "MultipleChoiceQuestionView.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) loadView {
    [self loadQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getQuestionFromServer:(UIBarButtonItem *)sender {
    [self loadQuestion];
}

- (void)loadQuestion {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://54.218.0.148/moodle/mod/ipal/tempview.php?p=125&user=user"]];
    Question *question = [QuestionFactory createNewQuestionWithData:data];
    QuestionView *questionView = [self getQuestionViewFromQuestion:question];
    NSLog(@"%@", question);
    questionView.question = question;
    self.view = questionView;
}

- (QuestionView *)getQuestionViewFromQuestion:(Question *)question {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect questionViewFrame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, applicationFrame.size.width, applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height);
    if ([question.type isEqualToString:MULTIPLE_CHOICE]) {
        return [[MultipleChoiceQuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    } else if ([question.type isEqualToString:ESSAY]) {
        return [[EssayQuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    } else {
        return [[QuestionView alloc] initWithFrame:questionViewFrame withQuestion:question];
    }
}

@end
