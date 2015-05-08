//
//  Comment.h
//  
//
//  Created by vsokoltsov on 04.05.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "Answer.h"

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSNumber * object_id;
@property (nonatomic, retain) NSNumber * commentable_id;
@property (nonatomic, retain) NSString * commentable_type;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Answer *answer;
@property (nonatomic, retain) Question *question;

+ (void) sync: (NSArray *) params;
+ (void) create: (NSDictionary *) params;
+ (NSMutableArray *) commentsForCurrentEntity: (id) entity andID:(NSNumber *) objectID;
- (User *) getUserForComment;
+ (void) setCommentsToUser: (User *) user;
@end
