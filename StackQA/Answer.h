//
//  Answer.h
//  StackQA
//
//  Created by vsokoltsov on 24.03.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * object_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSNumber * is_helpful;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Question *question;

@end