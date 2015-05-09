//
//  QuestionDetailViewController.h
//  StackQA
//
//  Created by vsokoltsov on 19.01.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData+MagicalRecord.h>
#import "Question.h"

@interface QuestionDetailViewController : UIViewController <UITextViewDelegate, UIWebViewDelegate>
@property (strong) Question *question;
@property (strong, nonatomic) IBOutlet UILabel *questionTitle;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *nestedView;
@property (strong, nonatomic) IBOutlet UITextView *questionText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
//- (IBAction)deleteQuestion:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *questionDate;
@property (strong, nonatomic) IBOutlet UILabel *questionCategory;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *commentsCount;
@property (strong, nonatomic) IBOutlet UIButton *answersCount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewAndScrollViewHeight;
- (IBAction)questionPopupView:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *questionTextHeight;


@end
