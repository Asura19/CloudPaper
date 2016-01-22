//
//  CPNoteEditController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteEditController.h"
#import "CPNote.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "CPMacro.h"
#import "YYText.h"
#import "UIBarButtonItem+CP.h"
#import "CPNoteManager.h"
#import "FDActionSheet.h"

CGFloat const kHorizontalMargin = 10.f;
CGFloat const kVerticalMargin = 10.f;

@interface CPNoteEditController ()<YYTextViewDelegate, FDActionSheetDelegate>
{
    CPNote *_note;
    YYTextView *_contentTextView;
    BOOL _saved;
    UIBarButtonItem *_doneItem;
    UIBarButtonItem *_addPhotoItem;
    UIBarButtonItem *_deleteItem;
    UIBarButtonItem *_shareItem;
    UIBarButtonItem *_remindItem;
    NSString *_tempContent;
    int _editTimes;
}
@end

@implementation CPNoteEditController

- (instancetype)initWithNote:(CPNote *)note {
    self = [super init];
    if (self) {
        _note = note;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tempContent = _note.content;
    _editTimes = 0;
    _saved = NO;
    // 右划返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self ceateNavigationBarItem];
    [self initSuiews];
    // 监听键盘状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)ceateNavigationBarItem
{
    // 创建导航栏Item
    _doneItem = [UIBarButtonItem itemWithIcon:@"btn_done"
                              highligntedIcon:@"nothing"
                                       target:self
                                       action:@selector(save)];
    
    _addPhotoItem = [UIBarButtonItem itemWithIcon:@"btn_camera"
                                  highligntedIcon:@"nothing"
                                           target:self
                                           action:@selector(addPhoto)];
    
    _shareItem = [UIBarButtonItem itemWithIcon:@"btn_send"
                               highligntedIcon:@"nothing"
                                        target:self
                                        action:@selector(share)];
    
    _deleteItem = [UIBarButtonItem itemWithIcon:@"btn_delete"
                                highligntedIcon:@"nothing"
                                         target:self
                                         action:@selector(deleteButtonClicked)];
    
    _remindItem = [UIBarButtonItem itemWithIcon:@"topbar_button_clock"
                                highligntedIcon:@"nothing"
                                         target:self
                                         action:@selector(setupRemindNotification)];
    
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:_shareItem, _deleteItem, nil];
    
}

- (void)initSuiews
{
    CGRect frame = self.view.bounds;
    _contentTextView = [[YYTextView alloc] initWithFrame:frame];

    _contentTextView.textContainerInset = UIEdgeInsetsMake(10, 14, 10, 10);
    _contentTextView.delegate = self;
    _contentTextView.textColor = [UIColor blackColor];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];

    if (_note) {
        [self setupAttributedText:_note.content];
        [self turnToLookingUpState];
    } else {
        [self setupAttributedText:@""];
        [self turnToEditingState];
        [_contentTextView becomeFirstResponder];
    }
    [self.view addSubview:_contentTextView];
}

- (void)turnToEditingState {
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_doneItem, _addPhotoItem, _remindItem, nil];
}

- (void)turnToLookingUpState {
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_shareItem, _deleteItem, _remindItem, nil];
}

- (void)setupAttributedText:(NSString *)string {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = [UIFont fontWithName:@"Times New Roman" size:19];
//    text.yy_lineSpacing = 1;
    text.yy_firstLineHeadIndent = 0;
    _contentTextView.attributedText = text;
    [_contentTextView setFont:[UIFont fontWithName:@"Times New Roman" size:19]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!_saved) {
        [self save];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self turnToEditingState];
//    _isEditingContent = YES;
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGFloat keyboardHeight = keyboardFrame.size.height;
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - keyboardHeight;
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    _isEditingContent = NO;
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         
         _contentTextView.frame = self.view.frame;
     }               completion:nil];
}

- (void)hideKeyboard
{
    if ([_contentTextView isFirstResponder]) {
//        _isEditingContent = NO;
        [_contentTextView resignFirstResponder];
    }
}

#pragma mark - Save

- (void)save
{
    [self hideKeyboard];
    NSString *string = (NSString *)_contentTextView.text;
    string = [string stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ((string == nil || string.length == 0)) {
        if (_note) {
            [self delete];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSDate *createDate;
    if (_note) {
        
        NSDate *updateDate;
        if ([_tempContent isEqualToString:_contentTextView.text] && (_editTimes < 2)) {
            updateDate = _note.updatedDate;
        } else {
            updateDate = [NSDate date];
        }
        createDate = _note.createdDate;
        CPNote *note = [[CPNote alloc] initWithTitle:nil
                                             content:string
                                         createdDate:createDate
                                          updateDate:updateDate];
        _note = note;
        BOOL success = [note PersistenceToUpdate];
        if (success) {
            _saved = YES;
            [self turnToLookingUpState];
        } else {
//            [ProgressHUD showError:@"SaveFail"];
        }
    } else {
        createDate = [NSDate date];
        CPNote *note = [[CPNote alloc] initWithTitle:nil
                                             content:string
                                         createdDate:createDate
                                          updateDate:[NSDate date]];
        _note = note;
        BOOL success = [note PersistenceToCreate];
        if (success) {
            _saved = YES;
            [self turnToLookingUpState];
        } else {
//            [ProgressHUD showError:@"SaveFail"];
        }
    }
}

- (void)deleteButtonClicked {
    [self hideKeyboard];
    FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"确定要删除此条便签?"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"删除", nil];
    
    [actionSheet setTitleColor:[UIColor blackColor] fontSize:12];
    [actionSheet setButtonTitleColor:[UIColor redColor] bgColor:nil fontSize:0 atIndex:0];
    [actionSheet show];
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self delete];
    }
}

- (void)addPhoto {
    [self hideKeyboard];
    NSString *cancelButtonTitle = @"取消";
    NSString *takePhotoTitle = @"拍摄照片";
    NSString *choosePhotoTitle = @"选择照片";
    NSString *drawPictureTitle = @"手绘图片";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
    }];
    
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:choosePhotoTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
    }];
    
    UIAlertAction *drawPictureAction = [UIAlertAction actionWithTitle:drawPictureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:drawPictureAction];
    [alertController addAction:choosePhotoAction];
    [alertController addAction:takePhotoAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)share {
    
}

- (void)delete {
    BOOL success = [[CPNoteManager sharedManager] deleteNote:_note];
    if (success) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [ProgressHUD showError:@"DeleteFail"];
    }
}


- (void)setupRemindNotification {
    NSLog(@"remind");
}


- (void)textViewDidChange:(YYTextView *)textView {
    // 监听字数
//    NSLog(@"%ld", [_contentTextView.text length]);
    NSString *count = [NSString stringWithFormat:@"%ld", [_contentTextView.text length]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:NAVIGATIONBAR_COUNT_FONT_SIZE];
    titleLabel.text = count;
    titleLabel.textColor = [UIColor whiteColor];
    CGSize titleLabelSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:NAVIGATIONBAR_COUNT_FONT}];
    titleLabel.frame = (CGRect){{0, 0}, titleLabelSize};
    self.navigationItem.titleView = titleLabel;
//    self.title = count;
    _editTimes++;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
