//
//  XMGAddTagViewController.m
//  百思不得姐
//
//  Created by hwawo on 16/7/22.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGAddTagViewController.h"
#import "XMGTagButton.h"
@interface XMGAddTagViewController ()
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) UITextField *textField;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation XMGAddTagViewController

- (NSMutableArray *)tagButtons{

    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton{

    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addButton.backgroundColor = XMGRGBColor(74, 139, 209);
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, XMGTopicCellMargin, 0, XMGTopicCellMargin);
        addButton.lh_Width = self.contentView.lh_Width;
        addButton.lh_Height = 35;
        
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    
    [self setUpContentView];
    
    [self setUpTextFiled];
}

- (void)setUpTextFiled{

    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.placeholder = @"多个标签用逗号或者换行隔开";
    textFiled.lh_Width = XMGScreenW;
    textFiled.lh_Height = 25;
    [textFiled becomeFirstResponder];
    [textFiled addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:textFiled];
    self.textField = textFiled;
    
}

- (void)addButtonClick{

    XMGLogFunc;
    XMGTagButton *tagButton = [XMGTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    tagButton.lh_Height = self.textField.lh_Height;
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    [self updateTagButtonFrame];
    
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
}

- (void)tagButtonClick:(XMGTagButton *)tagButton{

    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    [UIView animateWithDuration:0.25 animations:^{
        
       [self updateTagButtonFrame];
    }];
    
}

- (void)updateTagButtonFrame{

    NSLog(@"self.tagButtons.count%lu",(unsigned long)self.tagButtons.count);
    for (int i=0; i<self.tagButtons.count; i++) {
        XMGTagButton *tagButton = self.tagButtons[i];
        
        if (i==0) {
            tagButton.lh_X =0;
            tagButton.lh_Y =0;
        }else {
            XMGTagButton *lastButton = self.tagButtons[i-1];
            CGFloat leftWidth = CGRectGetMaxX(lastButton.frame) + XMGTagMargin;
            CGFloat rightWidth = self.contentView.lh_Width - leftWidth;
            
            if (rightWidth >= tagButton.lh_Width) {
                tagButton.lh_X = leftWidth;
                tagButton.lh_Y = lastButton.lh_Y;
            }else{
                
                tagButton.lh_X = 0;
                tagButton.lh_Y = CGRectGetMaxY(lastButton.frame) + XMGTagMargin;
            }
        }
        
    }
    
    XMGTagButton *lastButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastButton.frame) + XMGTagMargin;
    
    // 更新textField的frame
    if (self.contentView.lh_Width - leftWidth >= [self textFieldTextWidth]) {
        
        self.textField.lh_X = leftWidth;
        self.textField.lh_Y = lastButton.lh_Y;
    }else{
    
        self.textField.lh_X = 0;
        self.textField.lh_Y = CGRectGetMaxY(lastButton.frame);
    }
}

- (CGFloat)textFieldTextWidth{

    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    
    return MAX(100, textW);
}

- (void)textDidChange{

    if (self.textField.hasText) {
        self.addButton.hidden = NO;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@", self.textField.text] forState:UIControlStateNormal];
        self.addButton.lh_Y = CGRectGetMaxY(self.textField.frame) + XMGTagMargin;
    }else{
    
        self.addButton.hidden = YES;
    }
    
    [self updateTagButtonFrame];
}

- (void)setUpContentView{

    UIView *contentView = [[UIView alloc] init];
    contentView.lh_X = XMGTagMargin;
    contentView.lh_Width = self.view.lh_Width - 2*contentView.lh_X;
    contentView.lh_Y = 64 + XMGTagMargin;
    contentView.lh_Height = XMGScreenH;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setUpNav{

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)done{

    
    
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
