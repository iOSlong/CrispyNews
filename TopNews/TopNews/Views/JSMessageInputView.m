//
//  JSMessageInputView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessageInputView.h"
#define SEND_BUTTON_WIDTH 78.0f


@interface JSMessageInputView ()

- (void)setup;
//- (void)setupTextView;
//- (void)setupRecordButton;



@end



@implementation JSMessageInputView

@synthesize sendButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame delegate:(id<JSMessageInputViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        _delegate = delegate;
        [self setAutoresizesSubviews:NO];
    }
    return self;
}

- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

+ (JSInputBarStyle)inputBarStyle
{
    return JSInputBarStyleDefault;
}
- (UIImage *)inputBar
{
    if ([JSMessageInputView inputBarStyle] == JSInputBarStyleFlat)
        return [UIImage imageNamed:@"input-bar-flat"];
    else      // jSInputBarStyleDefault
        return [[UIImage imageNamed:@"input-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)];
}
#pragma mark - Setup
- (void)setup
{
    self.image = [self inputBar];
    self.backgroundColor = RGBCOLOR_HEX(0xebecee);
    
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
//    line.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0];
//    [self addSubview:line];
    
//    CGFloat height = [JSMessageInputView textViewLineHeight];
    CGFloat send_w = 45;
    
    self.textView = [[HPGrowingTextView  alloc] initWithFrame:CGRectMake(k_SpanLeft,[JSMessageInputView maxLines], SCREENW-2*k_SpanLeft - send_w - k_SpanIn, self.height - 2 * [JSMessageInputView maxLines])];
    //    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.minHeight = [JSMessageInputView textViewLineHeight];
    self.textView.maxNumberOfLines = 5;
    self.textView.animateHeightChange = YES;
    self.textView.animationDuration = 0.25;
    self.textView.delegate = self;
    
    
    [self.textView.layer setBorderWidth:1];
    [self.textView.layer setBorderColor:RGBCOLOR_HEX(0xe4e4e4).CGColor];
    [self.textView.layer setCornerRadius:2];
//    self.textView.returnKeyType = UIReturnKeySend;
//    self.textView.returnKeyType = UIReturnKeySend;
    [self addSubview:self.textView];
    
    
    self.sendButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendButton.frame = CGRectMake(SCREENW-k_SpanLeft-send_w,_textView.top + k_SpanIn, send_w, 30);
    [self.sendButton setTitle:@"send" forState:UIControlStateNormal];
    [self.sendButton setCenterY:self.height * 0.5];
    [self.sendButton addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.sendButton.userInteractionEnabled = NO;
    [self addSubview:self.
     sendButton];

    
}




-(void)publishBtnClick{
    if ([self.delegate respondsToSelector:@selector(textViewEnterSend)]) {
        [self.delegate textViewEnterSend];
    }
}



#pragma mark - HPTextViewDelegate
//- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;

//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
//- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;{
//    if (growingTextView.text.length > _maxLength) {
//        growingTextView.text = [growingTextView.text substringToIndex:_maxLength];
//    }
//}


-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    if (growingTextView.text.length > _maxLength) {
        
        growingTextView.text = [growingTextView.text substringToIndex:_maxLength];
        if ([self.delegate respondsToSelector:@selector(superInput)]) {
            [self.delegate superInput];
        }
    }
    if (growingTextView.text.length>0) {
        self.sendButton.userInteractionEnabled = YES;
        [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }else{
        self.sendButton.userInteractionEnabled = NO;
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > _maxLength) {
        //TODO 下面这一句在存在崩溃情况
//        growingTextView.text = [growingTextView.text substringToIndex:_maxLength];
        if ([self.delegate respondsToSelector:@selector(superInput)]) {
            [self.delegate superInput];
        }
        return NO;
    }
    
#if 0
    if ([text isEqual:@"\n"])
    {
        [self.delegate textViewEnterSend];
        return NO;
    }
#endif
    
    
    return YES;
}
//- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float bottom = self.bottom;
    if ([growingTextView.text length] == 0)
    {
        [self setHeight:height + 13];
    }
    else
    {
        [self setHeight:height + 2*[JSMessageInputView maxLines]];
    }
    
//    [self.sendButton setCenterY:height/2+5];
    self.sendButton.top = height - self.sendButton.height;
    
    
    [self setBottom:bottom];
//    [growingTextView setContentInset:UIEdgeInsetsZero];
    //    [UIView animateKeyframesWithDuration:0.25 delay:0 options:0 animations:^{
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
    if ([self.delegate respondsToSelector:@selector(viewheightChanged:)]) {
        [self.delegate viewheightChanged:height];
    }
}

//- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
//{
//}

//- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
//{
//    return YES;
//}


#pragma mark - Setters
//- (void)setSendButton:(UIButton *)btn
//{
//    if(sendButton)
//        [sendButton removeFromSuperview];
//    
//    sendButton = btn;
//    [self addSubview:self.sendButton];
//}

#pragma mark - Message input view

+ (CGFloat)textViewLineHeight
{
    return 30.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 5.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}
+ (CGFloat)defaultHeight{
    return [JSMessageInputView textViewLineHeight]+2*[JSMessageInputView maxLines];
}

- (void)willBeginRecord
{
    [self.textView setHidden:YES];
    [self.recordButton setHidden:NO];
}

- (void)willBeginInput
{
    [self.textView setHidden:NO];
    [self.recordButton setHidden:YES];
}
-(void)setDefaultHeight
{
    
}
- (CGFloat)bottom {
    return self.top + self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end
