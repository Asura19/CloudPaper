//
//  CPNoteCell.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
#import "CPNote.h"


@interface CPNoteCell : UITableViewCell

@property (nonatomic, weak) YYLabel *timeLabel;
@property (nonatomic, weak) YYLabel *noteContentLabel;
@property (nonatomic, weak) UIImageView *remindView;
@property (nonatomic, weak) UIImageView *photoView;
@property (nonatomic, strong) UIView *myContentView;
@property (nonatomic, strong) CPNote *note;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
