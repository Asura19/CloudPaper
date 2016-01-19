//
//  CPNoteListController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/17.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteListController.h"
//#import "Masonry.h"
#import "UIBarButtonItem+CP.h"
#import "CPMacro.h"
#import "CPNoteEditController.h"
#import "CPNavigationController.h"
#import "CPNoteManager.h"
#import "CPNote.h"
//#import "CPConstants.h"

@interface CPNoteListController ()
//@property (nonatomic, weak) UITableView *noteListView;
@property (nonatomic, strong) NSMutableArray *notes;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItems];
//    [self setupnoteListView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadTableViewData)
//                                                 name:@"CreateNewFile"
//                                               object:nil];
//    
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

- (void)createNewNote {
    CPNoteEditController *noteEditController = [[CPNoteEditController alloc] init];
    [self.navigationController pushViewController:noteEditController animated:YES];
}

- (void)setting {
    NSLog(@"--------setting");
}

//- (void)setupnoteListView {
//    UITableView *noteListView = [[UITableView alloc] init];
//    noteListView.frame = self.view.bounds;
//    [self.view addSubview:noteListView];
//    noteListView.delegate = self;
//    noteListView.dataSource = self;
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    CPNote *note = self.notes[indexPath.row];
    cell.textLabel.text = note.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CPNote *note = self.notes[indexPath.row];
    CPNoteEditController *noteEditController = [[CPNoteEditController alloc] initWithNote:note];
    [self.navigationController pushViewController:noteEditController animated:YES];
}

//- (void)reloadTableViewData {
//    _notes = [[CPNoteManager sharedManager] readAllNotes];
//    [self.tableView reloadData];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    _notes = [[CPNoteManager sharedManager] readAllNotes];
    [self.tableView reloadData];
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:@"CreateNewFile"];
//}

@end
