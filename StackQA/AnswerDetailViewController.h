//
//  AnswerDetailViewController.h
//  StackQA
//
//  Created by vsokoltsov on 22.04.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "ViewController.h"
#import "Answer.h"

@interface AnswerDetailViewController : ViewController
@property (strong) Answer *answer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *answerDetailTextViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UITextView *answerDetailTextView;
- (IBAction)dissmissDetailAnswerView:(id)sender;
- (IBAction)answerSave:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *answerSaveButton;
@property (strong, nonatomic) IBOutlet UIButton *answerDismissButton;

@end
