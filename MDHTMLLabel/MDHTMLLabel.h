//
//  MDHTMLLabel.h
//  MDHTMLLabel
//
//  Copyright (c) 2013 Matt Donnelly
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

extern NSString *const MDHTMLLabelAttributeColorName;  // UIColor or hex color code string
extern NSString *const MDHTMLLabelAttributeStrokeWidthName;  // NSNumber
extern NSString *const MDHTMLLabelAttributeStrokeColorName;  // UIColor or hex color code string
extern NSString *const MDHTMLLabelAttributeFontName;  // UIFont
extern NSString *const MDHTMLLabelAttributeFontStyleName;  // Default = MDHTMLLabelAttributeFontStyleNormal
extern NSString *const MDHTMLLabelAttributeUnderlineName;  // NSNumber between 0 and 2
extern NSString *const MDHTMLLabelAttributeKerningName;  // NSNumber

extern NSString *const MDHTMLLabelAttributeFontStyleNormalName;
extern NSString *const MDHTMLLabelAttributeFontStyleBoldName;
extern NSString *const MDHTMLLabelAttributeFontStyleItalicName;

@class MDHTMLLabel;

@protocol MDHTMLLabelDelegate <NSObject>

@optional
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL*)URL;
- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL*)URL;

@end

@interface MDHTMLLabel : UIView

@property (nonatomic, weak) NSObject <MDHTMLLabelDelegate> *delegate;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, readonly) NSString *plainText;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) NSDictionary *linkAttributes;
@property (nonatomic, strong) NSDictionary *selectedLinkAttributes;

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowRadius;

@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

+ (CGFloat)heightForHTMLString:(NSString *)htmlString
                      withFont:(UIFont *)font
    andPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth;

@end
