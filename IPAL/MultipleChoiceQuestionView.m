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

@property (nonatomic, strong) UITableView *choicesView;

@end

@implementation MultipleChoiceQuestionView

- (void) initElements {
    [super initElements];
    self.choicesView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.choicesView.dataSource = self;
    self.choicesView.delegate = self;
    CGRect frame = CGRectMake(0, 200, self.bounds.size.width, 200);
    self.choicesView.frame = frame;
    [self addSubview:self.choicesView];
    
    //NSLog(self.choicesButton);
    //[self addSubview:self.choicesButton];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *choices = ((MultipleChoiceQuestion *)self.question).choices;
    return [choices count]+1;
}

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 1.0f

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *label = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        [[cell contentView] addSubview:label];
    }
    NSArray *choices = ((MultipleChoiceQuestion *)self.question).choices;
    NSMutableArray *choiceTexts = [[NSMutableArray alloc] init];
    for (Choice *c in choices) {
        [choiceTexts addObject:c.text];
    }
    [choiceTexts addObject:@"Gov. Andrew M. Cuomo"];
    NSString *text = [choiceTexts objectAtIndex:[indexPath row]];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeCharacterWrap];
    CGFloat height = MAX(size.height, 15.0f);
    
    if (!label) {
        label = (UILabel *) [cell viewWithTag:1];
    }
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), height)];
    
    return cell;
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
