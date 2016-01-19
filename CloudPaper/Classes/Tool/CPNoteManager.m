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

//- (NSString *)createDataPathIfNeeded
//{
//    NSString *documentsDirectory = [self documentDirectoryPath];
//    self.docPath = documentsDirectory;
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
//        return self.docPath;
//    }
//    
//    NSError *error;
//    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
//                                             withIntermediateDirectories:YES
//                                                              attributes:nil
//                                                                   error:&error];
//    if (!success) {
//        NSLog(@"Error creating data path: %@", [error localizedDescription]);
//    }
//    return self.docPath;
//}

- (NSString *)createDataPathIfNeeded
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Cloud Paper"];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"notes.sqlite"];
    return path;
}

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"notes.sqlite"];
//    NSLog(@"%@", path);
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_notes (id integer primary key autoincrement, noteID text, note blob);"];
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
//    NSMutableArray *array = [NSMutableArray array];
//    NSError *error;
//    NSString *documentsDirectory = [self createDataPathIfNeeded];
//    NSLog(@"%@", documentsDirectory);
//    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
//    
//    if (files == nil) {
//        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
//        return nil;
//    }
//    // Create Note for each file
//    for (NSString *file in files) {
//        CPNote *note = [self readNoteWithID:file];
//        if (note) {
//            [array addObject:note];
//        }
//    }
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate"
//                                                 ascending:NO];
//    return [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:@[sortDescriptor]]];
/********************************************************************/
    __block NSMutableArray *noteArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        noteArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_notes;"];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"note"];
            CPNote *note = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [noteArray addObject:note];
        }
    }];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedDate"
                                                 ascending:NO];
    return [NSMutableArray arrayWithArray:[noteArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
}


- (CPNote *)readNoteWithID:(NSString *)noteID;
{
    NSString *dataPath = [_docPath stringByAppendingPathComponent:noteID];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) {
        return nil;
    }
    CPNote *note = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
    return note;
}

- (BOOL)addNote:(CPNote *)note
{
//    [self createDataPathIfNeeded];
//    NSString *dataPath = [_docPath stringByAppendingPathComponent:note.noteID];
//    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:note];
//    return [savedData writeToFile:dataPath atomically:YES];
    __block BOOL isSuccess;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *noteID = note.noteID;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note];
        isSuccess = [db executeUpdate:@"insert into t_notes (noteID, note) values(?, ?)", noteID, data];
    }];
    return isSuccess;
}

- (BOOL)updateNote:(CPNote *)note
{
    __block BOOL isSuccess;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *noteID = note.noteID;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note];
        isSuccess = [db executeUpdate:@"update t_notes set note = ? where noteID = ?", data, noteID];
    }];
    return isSuccess;
}

- (void)deleteNote:(CPNote *)note
{
    NSString *filePath = [_docPath stringByAppendingPathComponent:note.noteID];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}
@end
