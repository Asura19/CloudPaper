//
//  CPNoteManager.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/19.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteManager.h"
#import "CPNote.h"
#import "FMDB.h"

@implementation CPNoteManager

static FMDatabaseQueue *_queue;

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"notes.sqlite"];
//    NSLog(@"%@", path);
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_notes (id integer primary key autoincrement, noteID text, note_content, note_data blob);"];
    }];
}

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (NSMutableArray *)readAllNotes
{
    __block NSMutableArray *noteArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        noteArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_notes;"];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"note_data"];
            CPNote *note = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [noteArray addObject:note];
        }
    }];
    // 查询完数据后排序
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedDate"
                                                 ascending:NO];
    return [NSMutableArray arrayWithArray:[noteArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
//    return [[CPNoteManager sharedManager] searchNoteWithString:@""];
    
}

- (NSMutableArray *)searchNoteWithString:(NSString *)string
{
    __block NSMutableArray *noteArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        noteArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        if ([string isEqualToString:@""]) {
            rs = [db executeQuery:@"select * from t_notes;"];
        } else {
            
            NSString *dqlString = [NSString stringWithFormat:@"select * from t_notes where note_content like \"%%%@%%\";", string];
            NSLog(@"%@", dqlString);
            rs = [db executeQuery:dqlString];
            /**
             *  注意：此处因FMDB内部问题，不能直接在 executeQuery 中用 ？拼接语句，而应该先进行字符串拼接
             */
//            rs = [db executeQuery:@"select * from t_notes where note_content like \"%%%?%%\"", string];
        }
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"note_data"];
            CPNote *note = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [noteArray addObject:note];
        }
    }];
    
    NSLog(@"%ld", noteArray.count);
    // 查询完数据后排序
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedDate"
                                                 ascending:NO];
    return [NSMutableArray arrayWithArray:[noteArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
}

- (BOOL)addNote:(CPNote *)note
{
    __block BOOL isSuccess;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *noteID = note.noteID;
        NSString *noteContent = note.content;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note];
        isSuccess = [db executeUpdate:@"insert into t_notes (noteID, note_content, note_data) values(?, ?, ?)", noteID, noteContent, data];
    }];
    return isSuccess;
}

- (BOOL)deleteNote:(CPNote *)note
{
    __block BOOL isSuccess;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *noteID = note.noteID;
        isSuccess = [db executeUpdate:@"delete from t_notes where noteID = ?", noteID];
    }];
    return isSuccess;
}

- (BOOL)updateNote:(CPNote *)note
{
    __block BOOL isSuccess;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *noteID = note.noteID;
        NSString *noteContent = note.content;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note];
        isSuccess = [db executeUpdate:@"update t_notes set note_content = ?, note_data = ? where noteID = ?", noteContent, data, noteID];
    }];
    return isSuccess;
}

@end
