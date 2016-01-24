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
#import "CPNavigationController.h"
#import "CPNotificationManager.h"
#import "UIView+CP.h"
#import "CPNoteListController.h"
#import "CPRemindActionSheet.h"

CGFloat const kHorizontalMargin = 10.f;
CGFloat const kVerticalMargin = 10.f;

@interface CPNoteEditController ()<YYTextViewDelegate, FDActionSheetDelegate, CPRemindActionSheetDelegate>
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:SaveNoteWhenApplicationEnterBackground object:nil];
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
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"barbuttonicon_back"
                                                     highligntedIcon:@"nothing"
                                                              target:self
                                                              action:@selector(back)];
}

- (void)initSuiews
{
    CGRect frame = self.view.bounds;
    _contentTextView = [[YYTextView alloc] initWithFrame:frame];

    _contentTextView.textContainerInset = UIEdgeInsetsMake(10, 14, 10, 10);
    _contentTextView.delegate = self;
    _contentTextView.textColor = [UIColor blackColor];
    _contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];

    if (_note.createdDate) {
        [self setupAttributedText:_note.content];
        [self turnToLookingUpState];
    } else {
        [self setupAttributedText:@""];
        [self turnToEditingState];
        _remindItem.enabled = NO;
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

- (void)back {
    if (!_saved) {
        [self save];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    if (_note.createdDate) {
        // 更新便签
        NSDate *updateDate;
        if ([_tempContent isEqualToString:_contentTextView.text] && (_editTimes < 2)) {
            updateDate = _note.updatedDate;
        } else {
            updateDate = [NSDate date];
        }
        createDate = _note.createdDate;
        NSDate *remindDate = _note.remindDate ? _note.remindDate : nil;
        CPNote *note = [[CPNote alloc] initWithTitle:nil
                                             content:string
                                         createdDate:createDate
                                          updateDate:updateDate
                                          remindDate:remindDate];
        
        _note = note;
        
        if ([[CPNotificationManager sharedManager] shouldRegistLocalNotifiation:_note]) {
            [self dealWithLocalNotification];
        }
        
        BOOL success = [note PersistenceToUpdate];
        if (success) {
            _saved = YES;
            [self turnToLookingUpState];
        } else {
//            [ProgressHUD showError:@"SaveFail"];
        }
    } else {
        // 新建便签
        createDate = [NSDate date];
        NSDate *remindDate = _note.remindDate ? _note.remindDate : nil;
        CPNote *note = [[CPNote alloc] initWithTitle:nil
                                             content:string
                                         createdDate:createDate
                                          updateDate:[NSDate date]
                                          remindDate:remindDate];
        _note = note;
        
        if ([[CPNotificationManager sharedManager] shouldRegistLocalNotifiation:_note]) {
            [self dealWithLocalNotification];
        }
        
        BOOL success = [note PersistenceToCreate];
        if (success) {
            _saved = YES;
            [self turnToLookingUpState];
        } else {
//            [ProgressHUD showError:@"SaveFail"];
        }
    }
}


/**
 *  创建本地通知、修改本地通知 或 删除本地通知
 */
- (void)dealWithLocalNotification {
    [[CPNotificationManager sharedManager] deleteLocalNotificationIfExist:_note];
    if (_note.remindDate) {
        [[CPNotificationManager sharedManager] registLocalNotifiation:_note];
    }
}


- (void)deleteLocalNotificationIfExist {
    //拿到 存有 所有 推送的数组
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //便利这个数组 根据 key 拿到我们想要的 UILocalNotification
    for (UILocalNotification * loc in array) {
        if ([[loc.userInfo objectForKey:@"key"] isEqualToString:_note.noteID]) {
            //取消 本地推送
            [[UIApplication sharedApplication] cancelLocalNotification:loc];
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
        NSLog(@"The \"takePhotoAction\" alert action sheet's destructive action occured.");
    }];
    
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:choosePhotoTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"choosePhotoAction\" alert action sheet's destructive action occured.");
    }];
    
    UIAlertAction *drawPictureAction = [UIAlertAction actionWithTitle:drawPictureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"drawPictureAction\" alert action sheet's destructive action occured.");
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:drawPictureAction];
    [alertController addAction:choosePhotoAction];
    [alertController addAction:takePhotoAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)share {
    NSString *cancelButtonTitle = @"取消";
    NSString *wechatTitle = @"微信";
    NSString *weiboTitle = @"微博";
    NSString *mailTitle = @"邮件";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享便签" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
    }];
    
    UIAlertAction *wechatAction = [UIAlertAction actionWithTitle:wechatTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"wechatAction\" alert action sheet's destructive action occured.");
    }];
    
    UIAlertAction *weiboTitleAction = [UIAlertAction actionWithTitle:weiboTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"weiboTitleAction\" alert action sheet's destructive action occured.");
    }];
    
    UIAlertAction *mailAction = [UIAlertAction actionWithTitle:mailTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"The \"mailAction\" alert action sheet's destructive action occured.");
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:mailAction];
    [alertController addAction:weiboTitleAction];
    [alertController addAction:wechatAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    [self hideKeyboard];
    CPRemindActionSheet *remindView = [[CPRemindActionSheet alloc] initWithNote:_note];;
    remindView.delegate = self;
    [remindView show];
 
}


- (void)textViewDidChange:(YYTextView *)textView {
    // 监听字数
//    NSLog(@"%ld", [_contentTextView.text length]);
    _note.content = _contentTextView.text;

    _remindItem.enabled = [_contentTextView.text isEqualToString:@""] ? NO : YES;
    
    
    NSString *count = [NSString stringWithFormat:@"%ld", [_contentTextView.text length]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:NAVIGATIONBAR_COUNT_FONT_SIZE];
    titleLabel.text = count;
    titleLabel.textColor = [UIColor whiteColor];
    CGSize titleLabelSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:NAVIGATIONBAR_COUNT_FONT}];
    titleLabel.frame = (CGRect){{0, 0}, titleLabelSize};
    self.navigationItem.titleView = titleLabel;
    _editTimes++;
    
}


- (void)remindActionSheet:(CPRemindActionSheet *)remindActionSheet didSaveNote:(CPNote *)note {
    _note = note;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
    NSLog(@"%@",_contentTextView.text);
    NSString *string = [_contentTextView.text substringWithRange:characterRange];
    NSLog(@"%@", string);
    
    
    NSURL *url = [NSURL URLWithString:string];
    
}



@end
