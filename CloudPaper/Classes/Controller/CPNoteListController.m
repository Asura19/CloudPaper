//
//  CPNoteListController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/17.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteListController.h"
#import "UIBarButtonItem+CP.h"
#import "CPMacro.h"
#import "CPNoteEditController.h"
#import "CPNavigationController.h"
#import "CPNoteManager.h"
#import "CPNote.h"
#import "CPBaseNavigationController.h"
#import "CPSettingController.h"
#import "CPNoteCell.h"
#import "UIImage+Phoenix.h"
#import "CPGuideToCreateNoteView.h"

@interface CPNoteListController ()

@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic, weak) CPGuideToCreateNoteView *guideView;
@end

@implementation CPNoteListController

- (NSMutableArray *)notes {
    if (!_notes) {
        _notes = [[CPNoteManager sharedManager] readAllNotes];
    }
    return _notes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = CPColor(244, 244, 244);
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamedInResourceBundle:@"bg"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CPNOTECELL_BORDER, 0);
    [self setupGuideToCreateNoteView];
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    // setup navigationbar title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:NAVIGATIONBAR_TITLE_FONT_SIZE];
    titleLabel.text = @"Cloud Paper";
    titleLabel.textColor = [UIColor whiteColor];
    CGSize titleLabelSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:NAVIGATIONBAR_TITLE_FONT}];
    titleLabel.frame = (CGRect){{0, 0}, titleLabelSize};
    self.navigationItem.titleView = titleLabel;
    // setup navigationbar right item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"btn_new"
                                                           highligntedIcon:@"nothing"
                                                                    target:self
                                                                    action:@selector(createNewNote)];
    //setup navigationbar left item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"barbuttonicon_set"
                                                          highligntedIcon:@"nothing"
                                                                   target:self
                                                                   action:@selector(setting)];
}

- (void)setupGuideToCreateNoteView {
    CPGuideToCreateNoteView *guideView = [[CPGuideToCreateNoteView alloc] init];
    self.guideView = guideView;
    self.guideView.hidden = YES;
    guideView.frame = CGRectMake(0, 0, 180, 180);
    guideView.center = self.tableView.backgroundView.center;
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:guideView];
    [self.tableView.backgroundView addSubview:guideView];
}

- (void)createNewNote {
    CPNoteEditController *noteEditController = [[CPNoteEditController alloc] init];
    [self.navigationController pushViewController:noteEditController animated:YES];
}

- (void)setting {
    CPSettingController *settingController = [[CPSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    CPBaseNavigationController *nav = [[CPBaseNavigationController alloc] initWithRootViewController:settingController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    _notes = [[CPNoteManager sharedManager] readAllNotes];
    
    if (self.notes.count) {
        self.guideView.hidden = YES;
    } else {
        self.guideView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPNoteCell *cell = [CPNoteCell cellWithTableView:tableView];
    
    CPNote *note = self.notes[indexPath.row];
    if ([note.content length] > 40) {
        cell.noteContentLabel.text = [note.content substringWithRange:NSMakeRange(0, 40)];
    } else {
        cell.noteContentLabel.text = note.content;
    }
    // 时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy年"];
    NSString *s = [fmt stringFromDate:note.updatedDate];
    
    cell.timeLabel.text = s;
    return cell;
}

#pragma mark TableView Delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CPNote *note = self.notes[indexPath.row];
    CPNoteEditController *noteEditController = [[CPNoteEditController alloc] initWithNote:note];
    [self.navigationController pushViewController:noteEditController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CPNOTECELL_HEIGHT;
}

@end
