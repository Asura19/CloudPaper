//
//  CPNote.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNote : NSObject <NSCoding>

@property (nonatomic, copy) NSString *noteID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate;

- (BOOL)Persistence;

@end
