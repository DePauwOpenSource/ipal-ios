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

#define FONT_SIZE 12.0f
#define CELL_HORIZONTAL_PAD 10
#define CELL_VERTICAL_PAD 10
#define CHOICE_LABEL_TAG 1

- (void) initElements {
    [super initElements];
    self.choicesView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.choicesView.dataSource = self;
    self.choicesView.delegate = self;
    //the frame of the choicesView will the area between the submit button and question Text
    CGRect frame = CGRectMake(0, self.questionText.frame.origin.y + self.questionText.frame.size.height + CELL_HORIZONTAL_PAD,
                              self.bounds.size.width, self.frame.size.height - self.questionText.frame.origin.y - self.questionText.bounds.size.height - self.submitButton.bounds.size.height);
    self.choicesView.frame = frame;
    if ([self.choicesView respondsToSelector:@selector(seperatorInset)]) {
        self.choicesView.separatorInset = UIEdgeInsetsZero;
    }
    [self addSubview:self.choicesView];
    
    //NSLog(self.choicesButton);
    //[self addSubview:self.choicesButton];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *choices = ((MultipleChoiceQuestion *)self.question).choices;
    return [choices count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choicesCell"];
    UILabel *label = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTag:CHOICE_LABEL_TAG];
        label.numberOfLines = 0;
        [[cell contentView] addSubview:label];
        
    }
    if (!label) {
        label = (UILabel *) [cell viewWithTag:1];
    }
    NSAttributedString *text = [self getAttributedStringForChoiceAtIndex:[indexPath row]];
    label.attributedText = text;
    //label.textAlignment = NSTextAlignmentCenter;
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    CGSize labelSize = CGSizeZero;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(cell.frame.size.width -2*CELL_HORIZONTAL_PAD, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    labelSize = boundingRect.size;
    label.frame = CGRectMake(CELL_HORIZONTAL_PAD, CELL_VERTICAL_PAD,
                                cell.frame.size.width - 2*CELL_HORIZONTAL_PAD, ceilf(labelSize.height));
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, label.frame.size.height + 2*CELL_VERTICAL_PAD);
    cell.contentView.frame = cell.frame;
    return cell;
}

-(float) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAttributedString *text = [self getAttributedStringForChoiceAtIndex:[indexPath row]];
    CGSize cellSize = CGSizeZero;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 2*CELL_HORIZONTAL_PAD, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    cellSize = boundingRect.size;
    return cellSize.height + 2*CELL_VERTICAL_PAD;
}

-(NSAttributedString *) getAttributedStringForChoiceAtIndex:(int)index {
    NSArray *choices = ((MultipleChoiceQuestion *)self.question).choices;
    NSMutableArray *choiceTexts = [[NSMutableArray alloc] init];
    for (Choice *c in choices) {
        [choiceTexts addObject:c.text];
    }
    //Set color
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[choiceTexts objectAtIndex:index]];
    [attributedString setAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, attributedString.length)];
    
    //Set paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    
    //Set font
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} range: NSMakeRange(0, attributedString.length)];
    return attributedString;
}

-(int) getChoicesValueFromText:(NSString *) text {
    NSArray *choices = ((MultipleChoiceQuestion *)self.question).choices;
    for (Choice *c in choices) {
        if ([text isEqualToString:c.text])
            return [c.value intValue];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *selectedLabel = (UILabel *) [selectedCell viewWithTag:CHOICE_LABEL_TAG];
    int selectedChoiceValue = [self getChoicesValueFromText:[selectedLabel.attributedText string]];
    self.question.answerId = selectedChoiceValue;
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
