//
//  CPRemindController.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/22.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPNote, CPRemindController;

@protocol CPRemindControllerDelegate <NSObject>


@optional
- (void)remindViewController:(CPRemindController *)remindVc didSaveNote:(CPNote *)note;

@end
@interface CPRemindController : UIViewController
- (instancetype)initWithNote:(CPNote *)note;

@property (nonatomic, weak) id<CPRemindControllerDelegate> delegate;
@end
