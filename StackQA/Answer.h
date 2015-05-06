//
//  Answer.h
//  StackQA
//
//  Created by vsokoltsov on 24.03.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData+MagicalRecord.h>
#import "User.h"

@class Question;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * object_id;
@property (nonatomic) BOOL is_helpfull;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * question_id;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Question *question;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSMutableSet *comments;

+ (NSDate *) correctConvertOfDate:(NSString *) date;
+ (void) create: (NSDictionary *) params;
+ (void) create: (NSDictionary *) params inContext:(NSManagedObjectContext *) localContext;
+ (void) setQuestionsForUser:(User *) user;
+ (void) sync: (NSArray *) params;
+ (void) deleteAnswersFromDevice: (NSArray *) answers;
+ (void) setAnswersToUser: (User *) user;
- (Question *) getAnswerQuestion;
- (void) destroy;
+ (NSArray *) answersForQuestion:(Question *)question;

@end
