//
//  DemoViewController.m
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

#import "DemoViewController.h"
#import "MDHTMLLabel.h"

static const CGFloat kPadding = 10.0;

NSString *const kDemoText =
@"<a href='http://github.com/mattdonnelly/MDHTMLLabel'>MDHTMLLabel</a> is a lightweight, easy to \
use class for rendering text containing HTML tags on iOS 6.0+. It behaves almost <i>exactly</i> the \
same as <b>UILabel</b>, allows you to fully <font face='Didot-Italic' size='18'>customise</font> its \
appearence with added features thanks to <b>CoreText</b> and lets you handle when a user taps or \
holds down a link in the label unlike many similar libraries.";

@interface DemoViewController () <MDHTMLLabelDelegate>

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.text = kDemoText;
    htmlLabel.delegate = self;
    htmlLabel.preferredMaxLayoutWidth = self.view.frame.size.width - kPadding - kPadding;
    htmlLabel.linkAttributes = @{MDHTMLLabelAttributeColorName: [UIColor blueColor],
                                 MDHTMLLabelAttributeFontName: [UIFont boldSystemFontOfSize:16.0f],
                                 MDHTMLLabelAttributeUnderlineName: @(1)};
    htmlLabel.selectedLinkAttributes = @{MDHTMLLabelAttributeColorName: @"#ff0000",
                                         MDHTMLLabelAttributeFontName: [UIFont boldSystemFontOfSize:16.0f]};
    htmlLabel.shadowColor = [UIColor whiteColor];
    htmlLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    htmlLabel.shadowRadius = 1.0;
    htmlLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:htmlLabel];

    NSDictionary *views = @{@"htmlLabel": htmlLabel,
                            @"topLayoutGuide": self.topLayoutGuide};

    NSDictionary *metrics = @{@"padding": @(kPadding)};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[htmlLabel]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-(padding)-[htmlLabel]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
}

#pragma mark - MDHTMLLabelDelegate methods

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL
{
    NSLog(@"Did select link with URL: %@", URL.absoluteString);
}

- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL *)URL
{
    NSLog(@"Did hold link with URL: %@", URL.absoluteString);
}

@end
