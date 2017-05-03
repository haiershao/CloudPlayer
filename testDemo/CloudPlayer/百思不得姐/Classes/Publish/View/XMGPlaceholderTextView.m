//
//  XMGPlaceholderTextView.m
//  百思不得姐
//
//  Created by hwawo on 16/7/21.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "XMGPlaceholderTextView.h"
@interface XMGPlaceholderTextView ()
/** 占位文字label */
@property (nonatomic, weak) UILabel *placeholderLabel;
@end
@implementation XMGPlaceholderTextView
- (UILabel *)placeholderLabel{

    if (!_placeholderLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.lh_X = 4;
        label.lh_Y = 7;
        [self addSubview:label];
        _placeholderLabel = label;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor darkGrayColor];
        
        [XMGNoteCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{

    [XMGNoteCenter removeObserver:self];
}

- (void)textDidChange{

    self.placeholderLabel.hidden = self.hasText;
}

- (void)updatePlaceholderLabelSize{

    CGSize maxSize = CGSizeMake(self.frame.size.width - 2*self.placeholderLabel.frame.origin.x
                                , MAXFLOAT);
    self.placeholderLabel.lh_Size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;

}

- (void)setPlaceholder:(NSString *)placeholder{

    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabelSize];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{

    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;

}

- (void)setFont:(UIFont *)font{

    [super setFont:font];
    self.placeholderLabel.font = font;
    [self updatePlaceholderLabelSize];
}

- (void)setText:(NSString *)text{

    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{

    [super setAttributedText:attributedText];
    [self textDidChange];
}
@end
