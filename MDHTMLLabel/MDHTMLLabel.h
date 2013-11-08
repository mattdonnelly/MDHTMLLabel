//
//  MDHTMLLabel.h
//  Dribbble
//
//  Created by Matt Donnelly on 06/11/2013.
//  Copyright (c) 2013 Matt Donnelly. All rights reserved.
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

@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

+ (CGFloat)heightForHTMLString:(NSString *)htmlString
                      withFont:(UIFont *)font
    andPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth;

@end
