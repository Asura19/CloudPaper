//
//  CPNotificationManager.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/23.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPNote;
@interface CPNotificationManager : NSObject

+ (instancetype)sharedManager;
- (BOOL)shouldRegistLocalNotifiation:(CPNote *)note;
- (void)registLocalNotifiation:(CPNote *)note;
- (void)deleteLocalNotificationIfExist:(CPNote *)note;
@end
