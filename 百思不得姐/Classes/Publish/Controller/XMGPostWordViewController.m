//
//  XMGPostWordViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/21.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGPostWordViewController.h"
#import "XMGPlaceholderTextView.h"
#import "XMGAddTagToolbar.h"
@interface XMGPostWordViewController ()<UITextViewDelegate>
/** 文本输入控件 */
@property (nonatomic, weak) XMGPlaceholderTextView *textView;
/** 工具条 */
@property (nonatomic, weak) XMGAddTagToolbar *toolbar;
@end

@implementation XMGPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    
    [self setUpTextView];
    
    [self setUpToolbar];
}

- (void)setUpToolbar{

    XMGAddTagToolbar *toolbar = [XMGAddTagToolbar viewFromXIB];
    toolbar.lh_Width = self.view.lh_Width;
    toolbar.lh_Y = XMGScreenH - toolbar.lh_Height;
    toolbar.lh_X = 0;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    [XMGNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{

    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y - XMGScreenH);
    }];
}

- (void)setUpTextView{

    XMGPlaceholderTextView *placeholderTextView = [[XMGPlaceholderTextView alloc] init];
    placeholderTextView.frame = self.view.bounds;
    placeholderTextView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    placeholderTextView.placeholderColor = [UIColor darkGrayColor];
    [self.view addSubview:placeholderTextView];
    self.textView = placeholderTextView;
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

- (void)setUpNav{

    self.title = @"发表文字";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post{

}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView{

    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
                  
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
