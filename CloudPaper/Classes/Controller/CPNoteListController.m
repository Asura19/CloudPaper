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
#import "CPSettingController.h"
#import "CPNoteCell.h"
#import "UIImage+Phoenix.h"
#import "CPGuideToCreateNoteView.h"
#import "CPSearchBar.h"
#import "Masonry.h"
#import "CPNotificationManager.h"

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
    
//    [self createGestureRecognizer];
    [self setupGuideToCreateNoteView];
    [self setupNavigationItems];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}


- (void)setupTableView {
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamedInResourceBundle:@"bg"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CPNOTECELL_BORDER, 0);
//    self.tableView.backgroundColor = CPColor(115, 194, 247);
}


//- (void)createGestureRecognizer {
//    //创建长按手势监听
//    UILongPressGestureRecognizer *cellLongPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(TableviewCellLongPressed:)];
//    
//    UITapGestureRecognizer *cellDoubleTaped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TableviewCellDoubleTaped:)];
//    
//    cellDoubleTaped.numberOfTouchesRequired = 1;
//    
//    cellDoubleTaped.numberOfTapsRequired = 2;
//    
//    cellDoubleTaped.delegate = self;
//    //将长按手势添加到需要实现长按操作的视图里
//    [self.tableView addGestureRecognizer:cellLongPressed];
//    [self.tableView addGestureRecognizer:cellDoubleTaped];
//}

/**
 *  长按事件的手势监听实现方法
 *  长按进入编辑状态
 */
//- (void)TableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
//    
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        // 取得选中的行
//        CGPoint point = [gestureRecognizer locationInView:self.tableView];
//        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
//        if (indexPath == nil) {
//            NSLog(@"nil");
//        }else {
//            NSLog(@"长按的行号是：%ld",[indexPath row]);
//        }
//        
//        self.tableView.editing = !self.tableView.isEditing;
//    }
//}

/**
 *  单指双击事件的手势监听实现方法
 *  双击退出编辑状态
 */
//- (void)TableviewCellDoubleTaped:(UITapGestureRecognizer*)gestureRecognizer {
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        if (self.tableView.isEditing) {
//            self.tableView.editing = NO;
//        }
//    }
//}

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
    CPNote *note = [[CPNote alloc] init];
    CPNoteEditController *noteEditController = [[CPNoteEditController alloc] initWithNote:note];
    [self.navigationController pushViewController:noteEditController animated:YES];
}

- (void)setting {
    CPSettingController *settingController = [[CPSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    CPNavigationController *nav = [[CPNavigationController alloc] initWithRootViewController:settingController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    _notes = [[CPNoteManager sharedManager] readAllNotes];
    // 提醒过期处理
    for (CPNote *note in _notes) {
        if ([note.remindDate timeIntervalSinceNow] < 0) {
            note.remindDate = nil;
            [[CPNoteManager sharedManager] updateNote:note];
        }
    }
    _notes = [[CPNoteManager sharedManager] readAllNotes];
    [self.tableView reloadData];
}


#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.notes.count) {
        self.guideView.hidden = YES;
//        self.searchView.hidden = NO;
    } else {
        self.guideView.hidden = NO;
//        if (!self.searchBar.isEditing) {
//            self.searchView.hidden = YES;
//        }
    }
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPNoteCell *cell = [CPNoteCell cellWithTableView:tableView];
    cell.note = self.notes[indexPath.row];
    if (cell.note.remindDate) {
        cell.remindView.hidden = NO;
    } else {
        cell.remindView.hidden = YES;
    }
    
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
    _searchBar.frame = CGRectMake(1, 5 , SCREEN_WIDTH - 2, 33);
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
        
        [[CPNoteManager sharedManager] deleteNote:self.notes[indexPath.row]];
        [[CPNotificationManager sharedManager] deleteLocalNotificationIfExist:self.notes[indexPath.row]];
        
        [self.notes removeObjectAtIndex:indexPath.row];

        [self.tableView reloadData];

    }
}


/**
 *  @return cell是否可被拖动
 */
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.row == 0) // Don't move the first row
//    {
//        return NO;
//    }
//    return YES;
//}

/**
 *  拖动cell调整顺序
 */
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    NSLog(@"move from:%ld to:%ld", fromIndexPath.row, toIndexPath.row);
//    // fetch the object at the row being moved
//    NSString *r = [self.notes objectAtIndex:fromIndexPath.row];
//    
//    // remove the original from the data structure
//    [self.notes removeObjectAtIndex:fromIndexPath.row];
//    
//    // insert the object at the target row
//    [self.notes insertObject:r atIndex:toIndexPath.row];
//    NSLog(@"result of move :\n%@", [self notes]);
//}

/**
 *  TableView滑动时，搜索栏退出键盘
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
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
