//
//  QuestionsViewController.h
//  StackQA
//
//  Created by vsokoltsov on 18.01.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface QuestionsViewController : UITableViewController <SWTableViewCellDelegate>
@property(strong)NSMutableArray *questions;
@end
