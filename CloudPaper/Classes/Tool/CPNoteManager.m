//
//  CPNoteManager.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/19.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteManager.h"
#import "CPNote.h"

@implementation CPNoteManager

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (NSString *)createDataPathIfNeeded
{
    NSString *documentsDirectory = [self documentDirectoryPath];
    self.docPath = documentsDirectory;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        return self.docPath;
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return self.docPath;
}

- (NSString *)documentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Cloud Paper"];
    return documentsDirectory;
}

- (NSMutableArray *)readAllNotes
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error;
    NSString *documentsDirectory = [self createDataPathIfNeeded];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    // Create Note for each file
    for (NSString *file in files) {
        CPNote *note = [self readNoteWithID:file];
        if (note) {
            [array addObject:note];
        }
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate"
                                                 ascending:NO];
    return [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:@[sortDescriptor]]];
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

- (BOOL)storeNote:(CPNote *)note
{
    [self createDataPathIfNeeded];
    NSString *dataPath = [_docPath stringByAppendingPathComponent:note.noteID];
    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:note];
    return [savedData writeToFile:dataPath atomically:YES];
}

- (void)deleteNote:(CPNote *)note
{
    NSString *filePath = [_docPath stringByAppendingPathComponent:note.noteID];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}
@end
