//
//  QuestionDetailViewController.m
//  StackQA
//
//  Created by vsokoltsov on 19.01.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QuestionsFormViewController.h"
#import "QuestionsViewController.h"
#import "AnswersViewController.h"
#import "CommentsListViewController.h"
#import "ProfileViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "Api.h"
#import "SCategory.h"
#import <UIImage-ResizeMagick/UIImage+ResizeMagick.h>
#import <BENTagsView.h>

@interface QuestionDetailViewController (){
    Api *api;
    User *author;
    SCategory *questionCategory;
    AppDelegate *app;
    NSManagedObjectContext *localContext;
    UIRefreshControl *refreshControl;
}

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.question.rateDelegate = self;
    self.webView.delegate = self;
    [self refreshInit];
    [self resizeView];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) resizeView{
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.scrollEnabled = NO;
    CGSize size = [self.question.text sizeWithAttributes:nil];
    float viewHeight;
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    viewHeight = size.width / 10.0;

    self.questionTextHeight.constant = viewHeight;
}
- (void) uploadQuestionData{
    api = [Api sharedManager];
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [api getData:[NSString stringWithFormat:@"/questions/%@", self.question.objectId] andComplition:^(id data, BOOL result){
        if(result){
            [self parseQuestionData:data];
        } else {
            NSLog(@"data is %@", data);
        }
    }];
}
-(void) viewDidAppear:(BOOL)animated{
//    [self uploadQuestionData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self uploadQuestionData];
}

- (void) parseQuestionData:(id) data{
    [self.question update:data];
    author = [[User alloc] initWithParams:data[@"user"]];
    questionCategory = [[SCategory alloc] initWithParams:data[@"category"]];
    self.upRateButton.layer.cornerRadius = 6.0;
    self.downRateButton.layer.cornerRadius = 6.0;
    if(data[@"current_user_voted"] != [NSNull null]){
        [self designRateButtonsForAction:data[@"current_user_voted"][@"vote_value"]];
    } else {
        [self designRateButtonsForAction:@""];
    }
    
//    [Question create:data];
//    author = [User create:data[@"user"]];
//    questionCategory = [[SQACategory MR_findByAttribute:@"object_id" withValue:self.question.category_id] firstObject];
    [self initQuestionData];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initQuestionData{
    self.questionTitle.text = self.question.title;
    [self.webView loadHTMLString:self.question.text baseURL:nil];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss dd-MM-yyyy"];
    
    NSDate *date = [format dateFromString:[NSString stringWithFormat:@"%@", self.question.createdAt]];
    NSString* finalDateString = [format stringFromDate:self.question.createdAt];
    
    self.questionDate.text = finalDateString;
    [self.questionCategory setTitle:questionCategory.title forState:UIControlStateNormal];
    UIImage* resizedImage = [[questionCategory categoryImage] resizedImageByMagick: @"32x32#"];
    [self.questionCategory setImage:resizedImage forState:UIControlStateNormal];
    
    [self.answersCount setTitle:[NSString stringWithFormat:@"%@", self.question.answersCount] forState:UIControlStateNormal];
    [self.commentsCount setTitle:[NSString stringWithFormat:@"%@", self.question.commentsCount] forState:UIControlStateNormal];
    
    [self.authorProfileLink setTitle:nil forState:UIControlStateNormal];
    UIImage *profileImage = [[author profileImage] resizedImageByMagick: @"32x32#"];
    
    [self.authorProfileLink setImage:profileImage forState:UIControlStateNormal];
    [self.authorProfileLink setTitle: [author getCorrectNaming] forState:UIControlStateNormal];
    
    self.questionRate.text = [NSString stringWithFormat: @"%@", self.question.rate];
    
    self.tagsView.tagStrings = [self.question breakTagsLine];
    [self.tagsView setOnColor:[UIColor redColor]];
//    [self.tagsView setFont:[UIFont fontWithName:@"System" size:8]];
    [self.tagsView setTagCornerRadius:6];
    self.tagsView.backgroundColor = [UIColor clearColor];
//    [self.questionInfoView addSubview:tagView];
    float buttonWidth = self.buttonsView.frame.size.width / 2;
//    self.authorProfileLink.frame = CGSizeMake(buttonWidth, self.buttonsView.frame.size.height);
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = 320;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

-(void) findQuestionAndDelete{
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    if(self.question){
//        [self.question MR_deleteEntity];
        [localContext MR_save];
    }
    else{
        [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Данный вопрос не найден" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"updateQuestion"]){
        QuestionsFormViewController *form = segue.destinationViewController;
        form.question = self.question;
    }
    if([[segue identifier] isEqualToString:@"afterDeleteQuestion"]){
        QuestionsViewController *view = segue.destinationViewController;
    }
    if ([[segue identifier] isEqualToString:@"answers_list"]) {
        AnswersViewController *detail = segue.destinationViewController;
        detail.question = self.question;
    }
    if([[segue identifier] isEqualToString:@"commentsQuestionView"]){
        CommentsListViewController *view = segue.destinationViewController;
        view.question = self.question;
    }
    if([[segue identifier] isEqualToString:@"categoryQuestionView"]){
        QuestionsViewController *view = segue.destinationViewController;
        view.category = questionCategory;
    }
    if([[segue identifier] isEqualToString:@"questionAuthor"]){
        ProfileViewController *view = segue.destinationViewController;
        view.user = author;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(IBAction)deleteQuestion:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Сообшение" message:@"Вы действительно хотите удалить вопрос?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да", nil];
    [alert show];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex){
            case 1:
            [self findQuestionAndDelete];
            break;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)questionPopupView:(id)sender {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:
                                @"+1",
                                @"-1",
                                @"Редактировать",
                                @"Удалить",
                                nil];
        popup.tag = 1;
        [popup showInView:self.nestedView];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
    }
}

- (void) refreshInit{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.scrollView addSubview:refreshView]; //the tableView is a IBOutlet
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.backgroundColor = [UIColor grayColor];
    [refreshView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(uploadQuestionData) forControlEvents:UIControlEventValueChanged];
}

-(void)reloadData
{
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Последнее обновление: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
    [self initQuestionData];
}
- (IBAction)increaseRate:(id)sender {
    [self.question changeQuestionRate:@"plus"];
}

- (IBAction)decreaseRate:(id)sender {
    [self.question changeQuestionRate:@"minus"];
}
- (void) designRateButtonsForAction: (NSString *) action{
    if([action isEqualToString:@"plus"]){
        if(self.downRateButton.tag == 2){
            [self designRateButtonsForAction: @""];
            return;
        }
        self.upRateButton.backgroundColor = [UIColor lightGrayColor];
        self.upRateButton.tag = 2;
        self.downRateButton.backgroundColor = [UIColor clearColor];
        self.downRateButton.tag = 1;
    } else if([action isEqualToString:@"minus"]){
        if(self.upRateButton.tag == 2){
            [self designRateButtonsForAction: @""];
            return;
        }
        self.upRateButton.backgroundColor = [UIColor clearColor];
        self.upRateButton.tag = 1;
        self.downRateButton.backgroundColor = [UIColor lightGrayColor];
        self.downRateButton.tag = 2;
    } else {
        self.upRateButton.backgroundColor = [UIColor clearColor];
        self.upRateButton.tag = 1;
        self.downRateButton.backgroundColor = [UIColor clearColor];
        self.downRateButton.tag = 1;
    }
}
- (void) successRateCallbackWithData:(id) data{
    [self designRateButtonsForAction: data[@"action"]];
    self.questionRate.text = [data[@"rate"] stringValue];
}
- (void) failedRateCallbackWithData: (NSError *) error{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Вы уж голосовали за данный вопрос с таким результатом" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (IBAction)showQuestionCategory:(id)sender {
    [self performSegueWithIdentifier:@"categoryQuestionView" sender:self];
}

- (IBAction)showQuestionAuthor:(id)sender {
    [self performSegueWithIdentifier:@"questionAuthor" sender:self];
}
@end
