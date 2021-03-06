//
//  CPNote.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNote.h"
#import "CPNoteManager.h"

#define kNoteIDKey      @"NoteID"
#define kTitleKey       @"Title"
#define kContentKey     @"Content"
#define kCreatedDate    @"CreatedDate"
#define kUpdatedDate    @"UpdatedDate"
#define kRemindDate    @"RemindDate"

@implementation CPNote

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate
         remindDate:(NSDate *)remindDate;
{
    self = [super init];
    if (self) {
        _noteID = [NSNumber numberWithDouble:[createdDate timeIntervalSince1970]].stringValue;
        _title = title;
        _content = content;
        _createdDate = createdDate;
        _updatedDate = updatedDate;
        _remindDate = remindDate;
        if (_title == nil || _title.length == 0) {
            _title = @"无标题";
        }
        if (_content == nil || _content.length == 0) {
            _content = @"";
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_noteID forKey:kNoteIDKey];
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_content forKey:kContentKey];
    [encoder encodeObject:_createdDate forKey:kCreatedDate];
    [encoder encodeObject:_updatedDate forKey:kUpdatedDate];
    [encoder encodeObject:_remindDate forKey:kRemindDate];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    NSString *content = [decoder decodeObjectForKey:kContentKey];
    NSDate *createDate = [decoder decodeObjectForKey:kCreatedDate];
    NSDate *updateDate = [decoder decodeObjectForKey:kUpdatedDate];
    NSDate *remindDate = [decoder decodeObjectForKey:kRemindDate];
    return [self initWithTitle:title
                       content:content
                   createdDate:createDate
                    updateDate:updateDate
                    remindDate:remindDate];
}

- (BOOL)PersistenceToCreate {
    return [[CPNoteManager sharedManager] addNote:self];
}

- (BOOL)PersistenceToUpdate {
    return [[CPNoteManager sharedManager] updateNote:self];
}
@end
