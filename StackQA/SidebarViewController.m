//
//  SidebarViewController.m
//  StackQA
//
//  Created by vsokoltsov on 08.03.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "SidebarViewController.h"
#import "AuthorizationViewController.h"
#import "QuestionsViewController.h"

@interface SidebarViewController (){
    NSArray *menuID;
    NSArray *menuItems;
    NSArray *menuIcons;
}

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    menuID = @[@"logo", @"login", @"registration", @"questions",  @"categories", @"feedbacks", @"callbacks", @"news"];
    menuItems = @[@"StackQ&A", @"Логин", @"Регистрация", @"Вопросы", @"Категории", @"Отзывы", @"Обратная связь", @"Новости"];
    menuIcons = @[@"", @"login17.png", @"create1.png", @"ask_question-32.png", @"category.png",@"response-32.png", @"feedback-32.png", @"news-32.png"];
//    self.tableView.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *touched = menuID[indexPath.row];
    [self
     performSegueWithIdentifier:touched sender:self];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = menuItems[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:menuIcons[indexPath.row]];
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"login"]){
        AuthorizationViewController *view = segue.destinationViewController;
    }
    if([[segue identifier] isEqualToString:@"questions"]){
        QuestionsViewController *view = segue.destinationViewController;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
