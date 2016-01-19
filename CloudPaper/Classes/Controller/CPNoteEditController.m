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
//#import "CPConstants.h"

static const CGFloat kViewOriginY = 70;
static const CGFloat kTextFieldHeight = 30;
static const CGFloat kToolbarHeight = 44;
static const CGFloat kVoiceButtonWidth = 100;
CGFloat const kHorizontalMargin = 10.f;
CGFloat const kVerticalMargin = 10.f;

@interface CPNoteEditController ()
{
    CPNote *_note;
    UITextView *_contentTextView;
    BOOL _isEditingContent;
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
    // 右划返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self initSuiews];
    [self setupNavigationBar];
//    [self setupSpeechRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigationBar
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(save)];
    
//    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_new"]
//                                                                 style:UIBarButtonItemStylePlain
//                                                                target:self
//                                                                action:@selector(delete)];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(delete)];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreItem, saveItem, nil];
}

//- (void)setupSpeechRecognizer
//{
//    NSString *initString = [NSString stringWithFormat:@"%@=%@", [IFlySpeechConstant APPID], kIFlyAppID];
//    
//    [IFlySpeechUtility createUtility:initString];
//    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
//    _iflyRecognizerView.delegate = self;
//    
//    [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
//    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
//}

- (void)initSuiews
{
    CGRect frame = CGRectMake(kHorizontalMargin, kViewOriginY, self.view.frame.size.width - kHorizontalMargin * 2, kTextFieldHeight);
    
//    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
//    doneBarButton.width = ceilf(self.view.frame.size.width) / 3 - 30;
//    
//    UIBarButtonItem *voiceBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"micro_small"] style:UIBarButtonItemStylePlain target:self action:@selector(useVoiceInput)];
//    voiceBarButton.width = ceilf(self.view.frame.size.width) / 3;
//    
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kToolbarHeight)];
//    toolbar.tintColor = [UIColor systemColor];
//    toolbar.items = [NSArray arrayWithObjects:doneBarButton, voiceBarButton, nil];
//    
//    frame = CGRectMake(kHorizontalMargin,
//                       0,
//                       self.view.frame.size.width - kHorizontalMargin * 2,
//                       self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin * 2);
    _contentTextView = [[UITextView alloc] initWithFrame:frame];
    _contentTextView.backgroundColor = [UIColor grayColor];
    _contentTextView.textColor = [UIColor blackColor];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];
//    UIView *superView = self.view;
//    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.mas_left).offset(kHorizontalMargin);
//        make.top.equalTo(superView.mas_top).offset(kViewOriginY);
//        make.right.equalTo(superView.mas_right).offset(-kHorizontalMargin);
//        if (_isEditingContent) {
//            make.bottom.equalTo(superView.mas_bottom).offset(300);
//        } else {
//            make.bottom.equalTo(superView.mas_bottom);
//        }
//        
//    }];
    
    if (_note) {
        _contentTextView.text = _note.content;
    }
//    _contentTextView.inputAccessoryView = toolbar;
    [self.view addSubview:_contentTextView];
    
//    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_voiceButton setFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
//    [_voiceButton setTitle:NSLocalizedString(@"VoiceInput", @"") forState:UIControlStateNormal];
//    [_voiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _voiceButton.layer.cornerRadius = kVoiceButtonWidth / 2;
//    _voiceButton.layer.masksToBounds = YES;
//    [_voiceButton setBackgroundColor:[UIColor systemColor]];
//    [_voiceButton addTarget:self action:@selector(useVoiceInput) forControlEvents:UIControlEventTouchUpInside];
//    [_voiceButton setTintColor:[UIColor whiteColor]];
//    [self.view addSubview:_voiceButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self save];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    _isEditingContent = YES;
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGFloat keyboardHeight = keyboardFrame.size.height;
         
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - keyboardHeight - kVerticalMargin - kToolbarHeight,
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _isEditingContent = NO;
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - kVoiceButtonWidth - kVerticalMargin * 3;
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)hideKeyboard
{
    if ([_contentTextView isFirstResponder]) {
        _isEditingContent = NO;
        [_contentTextView resignFirstResponder];
    }
}

#pragma mark - Save

- (void)save
{
    [self hideKeyboard];
    if ((_contentTextView.text == nil || _contentTextView.text.length == 0)) {
        return;
    }
    NSDate *createDate;
    if (_note && _note.createdDate) {
        createDate = _note.createdDate;
    } else {
        createDate = [NSDate date];
    }
    CPNote *note = [[CPNote alloc] initWithTitle:nil
                                         content:_contentTextView.text
                                     createdDate:createDate
                                      updateDate:[NSDate date]];
    _note = note;
    BOOL success = [note Persistence];
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateNewFile" object:nil userInfo:nil];
    } else {
        [ProgressHUD showError:@"SaveFail"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)delete {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
