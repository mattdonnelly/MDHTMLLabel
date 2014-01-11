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

typedef NS_ENUM(NSUInteger, MDHTMLLabelVerticalAlignment) {
    MDHTMLLabelVerticalAlignmentCenter   = 0,
    MDHTMLLabelVerticalAlignmentTop      = 1,
    MDHTMLLabelVerticalAlignmentBottom   = 2,
};

@class MDHTMLLabel;

@protocol MDHTMLLabelDelegate <NSObject>

///-----------------------------------
/// @name Responding to Link Selection
///-----------------------------------
@optional

/**
 Tells the delegate that the user did select a link

 @param label The label that the link was selected in.
 @param URL the URL of link the user selected.
 */
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL*)URL;

/**
 Tells the delegate that the user did hold a link

 @param label The label that the link was held in.
 @param URL the URL of link the user held.
 */
- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL*)URL;

@end

/** 
 `MDHTMLLabel` is a lightweight, easy to use replacement for `UILabel` which allows you to fully customize the appearence of the text using HTML tags.

# Differences Between `MDHTMLLabel` and `UILabel`

For the most part, `MDHTMLLabel` behaves the same as `UILabel`. The following are notable exceptions, in which `MDHTMLLabel` properties may act differently:

- `lineBreakMode` - This property displays only the first line when the value is `NSLineBreakByTruncatingHead`, `NSLineBreakByTruncatingMiddle`, or `NSLineBreakByTruncatingTail`
- `adjustsFontsizeToFitWidth` - This property is effective for any value of `numberOfLines` greater than zero.
*/

@interface MDHTMLLabel : UILabel

///-----------------------------
/// @name Accessing the Delegate
///-----------------------------

/**
 The receiver's delegate.

 @discussion A `TTTAttributedLabel` delegate responds to messages sent by tapping on links in the label. You can use the delegate to respond to links referencing a URL, address, phone number, date, or date with a specified time zone and duration.
 */

@property (nonatomic, weak) IBOutlet NSObject <MDHTMLLabelDelegate> *delegate;

///----------------------------------
/// @name Setting the Text Attributes
///----------------------------------

/**
 The text that HTML tags will be parsed for and rendered by the label.
 */

@property (nonatomic, copy) NSString *htmlText;

///--------------------------------------------
/// @name Detecting, Accessing, & Styling Links
///--------------------------------------------

/**
 A dictionary containing the `NSAttributedString` attributes to be applied to links detected or manually added to the label text. The default link style is the label's tintColor on iOS 7 and blue below iOS 7.
 */
@property (nonatomic, strong) NSDictionary *linkAttributes;

/**
 A dictionary containing the `NSAttributedString` attributes to be applied to links when they are in the active state. Supply `nil` or an empty dictionary to opt out of active link styling. The default active link style is red.
 */
@property (nonatomic, strong) NSDictionary *activeLinkAttributes;

/**
 A dictionary containing the `NSAttributedString` attributes to be applied to links when they are in the inactive state, which is triggered a change in `tintColor` in iOS 7. Supply `nil` or an empty dictionary to opt out of inactive link styling. The default inactive link style is gray.
 */
@property (nonatomic, strong) NSDictionary *inactiveLinkAttributes;

/**
 The length of time the user most hold a link to trigger the 'HTMLLabel:didHoldLinkWithURL' delegate method. The value is 0.5 by default.
 */
@property (nonatomic, assign) NSTimeInterval minimumPressDuration;

///---------------------------------------
/// @name Acccessing Text Style Attributes
///---------------------------------------

/**
 The shadow blur radius for the label. A value of 0 indicates no blur, while larger values produce correspondingly larger blurring. This value must not be negative. The default value is 0.
 */
@property (nonatomic, assign) CGFloat shadowRadius;

/**
 The shadow blur radius for the label when the label's `highlighted` property is `YES`. A value of 0 indicates no blur, while larger values produce correspondingly larger blurring. This value must not be negative. The default value is 0.
 */
@property (nonatomic, assign) CGFloat highlightedShadowRadius;

/**
 The shadow offset for the label when the label's `highlighted` property is `YES`. A size of {0, 0} indicates no offset, with positive values extending down and to the right. The default size is {0, 0}.
 */
@property (nonatomic, assign) CGSize highlightedShadowOffset;
/**
 The shadow color for the label when the label's `highlighted` property is `YES`. The default value is `nil` (no shadow color).
 */
@property (nonatomic, strong) UIColor *highlightedShadowColor;

///--------------------------------------------
/// @name Acccessing Paragraph Style Attributes
///--------------------------------------------

/**
 The distance, in points, from the leading margin of a frame to the beginning of the paragraph's first line. This value is always nonnegative, and is 0.0 by default.
 */
@property (nonatomic, assign) CGFloat firstLineIndent;

/**
 The space in points added between lines within the paragraph. This value is always nonnegative and is 0.0 by default.
 */
@property (nonatomic, assign) CGFloat leading;

/**
 The line height multiple. This value is 1.0 by default.
 */
@property (nonatomic, assign) CGFloat lineHeightMultiple;

/**
 The distance, in points, from the margin to the text container. This value is `UIEdgeInsetsZero` by default.

 @discussion The `UIEdgeInset` members correspond to paragraph style properties rather than a particular geometry, and can change depending on the writing direction.

 ## `UIEdgeInset` Member Correspondence With `CTParagraphStyleSpecifier` Values:

 - `top`: `kCTParagraphStyleSpecifierParagraphSpacingBefore`
 - `left`: `kCTParagraphStyleSpecifierHeadIndent`
 - `bottom`: `kCTParagraphStyleSpecifierParagraphSpacing`
 - `right`: `kCTParagraphStyleSpecifierTailIndent`

 */
@property (nonatomic, assign) UIEdgeInsets textInsets;

/**
 The vertical text alignment for the label, for when the frame size is greater than the text rect size. The vertical alignment is `TTTAttributedLabelVerticalAlignmentCenter` by default.
 */
@property (nonatomic, assign) MDHTMLLabelVerticalAlignment verticalAlignment;

///--------------------------------------------
/// @name Accessing Truncation Token Appearance
///--------------------------------------------

/**
 The truncation token that appears at the end of the truncated line. `nil` by default.

 @discussion When truncation is enabled for the label, by setting `lineBreakMode` to either `UILineBreakModeHeadTruncation`, `UILineBreakModeTailTruncation`, or `UILineBreakModeMiddleTruncation`, the token used to terminate the truncated line will be `truncationTokenString` if defined, otherwise the Unicode Character 'HORIZONTAL ELLIPSIS' (U+2026).
 */
@property (nonatomic, strong) NSString *truncationTokenString;

/**
 The attributes to apply to the truncation token at the end of a truncated line. If unspecified, attributes will be inherited from the preceding character.
 */
@property (nonatomic, strong) NSDictionary *truncationTokenStringAttributes;


///--------------------------------------------
/// @name Calculating Size of HTML String
///--------------------------------------------

/**
 Calculate and return the size that best fits a HTML string, given the specified constraints on size and number of lines.

 @param htmlString - the string to render
 @param font - the font to render the string with
 @param size - the size to constrain the string to
 @param numberOfLines - the number of lines to limit the string to

 @return The size that fits the HTML string within the specified constraints.
 */
+ (CGFloat)sizeThatFitsHTMLString:(NSString *)htmlString
                         withFont:(UIFont *)font
                      constraints:(CGSize)size
           limitedToNumberOfLines:(NSUInteger)numberOfLines;

@end
