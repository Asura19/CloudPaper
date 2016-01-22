//
//  CPNoteManager.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/19.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPNote;
@interface CPNoteManager : NSObject

@property (nonatomic, strong) NSString *docPath;

- (NSMutableArray *)readAllNotes;
- (NSMutableArray *)searchNoteWithString:(NSString *)string;
- (CPNote *)readNoteWithNoteID:(NSString *)noteID;
- (BOOL)addNote:(CPNote *)note;
- (BOOL)updateNote:(CPNote *)note;
- (BOOL)deleteNote:(CPNote *)note;
+ (instancetype)sharedManager;
@end
