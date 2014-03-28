//
//  MultipleChoiceQuestionView.m
//  IPAL
//
//  Created by Ngoc Nguyen on 3/18/14.
//  Copyright (c) 2014 DePauw Open Source. All rights reserved.
//

#import "MultipleChoiceQuestionView.h"
#import "MultipleChoiceQuestion.h"

@interface MultipleChoiceQuestionView()

@property (nonatomic, strong) UISegmentedControl *choicesButton;

@end

@implementation MultipleChoiceQuestionView

- (void) initElements {
    [super initElements];
    NSArray *choices = ((MultipleChoiceQuestion *)self.question).choices;
    NSMutableArray *choiceTexts = [[NSMutableArray alloc] init];
    for (Choice *c in choices) {
        NSLog([NSString stringWithFormat:@"Text: %@",c.text]);
        [choiceTexts addObject:c.text];
    }
    //NSLog(choiceTexts);
    NSArray *text = [NSArray arrayWithObjects: @"text", @"Control",@"iPhone", nil];
    _choicesButton = [[UISegmentedControl alloc] initWithItems:choiceTexts];
    self.choicesButton.frame = CGRectMake(0, 200, 300, 150);
    //self.choicesButton.tintColor = [UIColor blackColor];
    self.choicesButton.selectedSegmentIndex = 1;
    self.choicesButton.backgroundColor = [UIColor whiteColor];
    self.choicesButton.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    //Rotating the text inside each segment
    NSArray *arr = [self.choicesButton subviews];
    for (int i=0; i < [arr count]; i++) {
        UIView *v = (UIView *) [arr objectAtIndex:i];
        NSArray *subArr = [v subviews];
        for (int j=0; j< [subArr count]; j++) {
            if ([[subArr objectAtIndex:j] isKindOfClass:[UILabel class]]) {
                UILabel *l = (UILabel *) [subArr objectAtIndex:j];
                l.transform = CGAffineTransformMakeRotation(-M_PI / 2.0);
            }
        }
    }

    NSLog(@"Segmeted");
    //NSLog(self.choicesButton);
    [self addSubview:self.choicesButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
