//
//  CPRemindActionSheet.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/23.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPNote, CPRemindActionSheet;

@protocol CPRemindActionSheetDelegate <NSObject>

@optional
- (void)remindActionSheet:(CPRemindActionSheet *)remindActionSheet didSaveNote:(CPNote *)note;
@end

@interface CPRemindActionSheet : UIView

@property (nonatomic, weak) id<CPRemindActionSheetDelegate> delegate;

- (instancetype)initWithNote:(CPNote *)note;

- (void)show;

@end