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

NSString *const kDemoText = @"<a href='http://github.com/mattdonnelly/MDHTMLLabel'>MDHTMLLabel</a> is a lightweight, easy to use replacement for <b>UILabel</b> which allows you to fully <font face='Didot-Italic' size='19'>customize</font> the appearence of the text using HTML tags (with a few added features thanks to <b>CoreText</b>), as well letting you handle whenever a user taps or holds down on link and automatically detecting ones not wrapper in anchor tags";

@interface DemoViewController () <MDHTMLLabelDelegate>

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.htmlText = kDemoText;
    htmlLabel.delegate = self;
    htmlLabel.numberOfLines = 0;
    htmlLabel.shadowColor = [UIColor whiteColor];
    htmlLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    htmlLabel.translatesAutoresizingMaskIntoConstraints = NO;

    htmlLabel.linkAttributes = @{ NSForegroundColorAttributeName: [UIColor blueColor],
                                  NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };

    htmlLabel.activeLinkAttributes = @{ NSForegroundColorAttributeName: [UIColor redColor],
                                        NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };

    [self.view addSubview:htmlLabel];

    NSDictionary *views = @{@"htmlLabel": htmlLabel,
                            @"topLayoutGuide": self.topLayoutGuide};

    NSDictionary *metrics = @{@"padding": @(kPadding)};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[htmlLabel]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-(padding)-[htmlLabel]"
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
