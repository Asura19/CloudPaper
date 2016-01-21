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
#import "CPSearchBar.h"
#import "Masonry.h"

@interface CPNoteListController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic, weak) CPGuideToCreateNoteView *guideView;
@property (nonatomic, weak) CPSearchBar *searchBar;
@property (nonatomic, strong) UIView *searchView;
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

    
    
    [self setupTableView];
    [self setupGuideToCreateNoteView];
    [self setupNavigationItems];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}



- (void)setupTableView {
    //    self.view.backgroundColor = CPColor(244, 244, 244);
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamedInResourceBundle:@"bg"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CPNOTECELL_BORDER, 0);
//    self.tableView.backgroundColor = CPColor(115, 194, 247);
    
    
    // failed to use Masonry
//    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tableView.mas_top).offset(5);
//        make.centerX.equalTo(self.tableView.mas_centerX);
//        make.width.equalTo(@(SCREEN_WIDTH - 2 * CPNOTECELL_BORDER));
//        make.height.equalTo(@(30));
//    }];
//    [self.tableView addSubview:searchBar];
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view insertSubview:searchBar atIndex:0];
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
    guideView.frame = CGRectMake(0, 0, 200, 200);
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
    
    [self.tableView reloadData];
}

#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"----");
    if (self.notes.count) {
        self.guideView.hidden = YES;
        self.searchView.hidden = NO;
    } else {
        self.guideView.hidden = NO;
        self.searchView.hidden = YES;
    }
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPNoteCell *cell = [CPNoteCell cellWithTableView:tableView];
    cell.note = self.notes[indexPath.row];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _searchView = [[UIView alloc] init];
//    _searchView.backgroundColor = [UIColor redColor];
    
    self.searchBar = [CPSearchBar searchBar];
    _searchBar.frame = CGRectMake(1, 6 , SCREEN_WIDTH - 2, 33);
    _searchBar.center = CGPointMake(self.tableView.center.x, _searchBar.center.y);
    _searchBar.delegate = self;
    
    [_searchView addSubview:_searchBar];
    
    return _searchView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.notes.count) {
        return 40;
    } else {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
        // 1.删除模型数据
        [self.notes removeObjectAtIndex:indexPath.row];

        [[CPNoteManager sharedManager] deleteNote:self.notes[indexPath.row]];
        // 2.刷新表格
        [self.tableView reloadData];
        
        // 3.归档
//        [NSKeyedArchiver archiveRootObject:self.contacts toFile:MJContactsFilepath];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // 1.修改模型数据
//        MJContact *contact = [[MJContact alloc] init];
//        contact.name = @"jack";
//        contact.phone = @"10086";
//        [self.contacts insertObject:contact atIndex:indexPath.row + 1];
//        
//        // 2.刷新表格
//        NSIndexPath *nextPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[nextPath] withRowAnimation:UITableViewRowAnimationBottom];
//        //        [self.tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;//uitableview和子view也响应 no只响应子view uipangesturerecognizer
}



#pragma mark TextField Delegate method

- (void)textFieldDidChange:(NSNotification *)noti {
    _notes = [[CPNoteManager sharedManager] searchNoteWithString:self.searchBar.text];
    [self.tableView reloadData];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
