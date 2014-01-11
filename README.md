MDHTMLLabel
===========

MDHTMLLabel is a lightweight, easy to use replacement for UILabel which allows you to fully customize the appearence of the text using HTML (with a few added features thanks to CoreText), as well letting you handle whenever a user taps or holds down on link and automatically detect ones not wrapped in anchor tags.

Features:

- Fully style text using HTML
- Link interaction handling
- Automatic detection of URLs not wrapped in anchor tags
- Font tag support
- Bold and italic text styles
- Color and stroke styles
- Text shadows
- Indentation, kerning and line spacing settings
- Text insets
- Support for iOS 6.0+

<p align="center" >
  <img src="https://raw.github.com/mattdonnelly/MDHTMLLabel/master/Screenshot.png" alt="MDHTMLLabel" title="MDHTMLLabel" width="414" height="834">
</p>

## Getting Started

### Installation with CocoaPods

The recommended method of installation is to use [CocoaPods](http://cocoapods.org) which is a dependency manager for Objective-C, that automates and simplifies the process of using 3rd-party libraries in your projects.

Include the following in your Podfile:

```ruby
platform :ios, '6.0'
pod 'MDHTMLLabel'
```

You can also choose to simply drag the source files in to your project instead.

## How To Use

Just import the header file and create an instance of MDHTMLLabel like you would with UILabel.

```objective-c
#import <MDHTMLLabel/MDHTMLLabel.h>

...

- (void)viewDidLoad
{
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] initWithFrame:frame];
    htmlLabel.delegate = self;
    htmlLabel.htmlText = htmlText;

    [self.view addSubview:htmlLabel];
}
```

### Link Interaction

MDHTMLLabel automatically creates user interactable links inside the label to represent HTML anchor tags and allows you to detect when a user taps or holds down on a link by implementing an optional delgate. The delegate has two methods for you to implement:

```objective-c
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL
- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL *)URL
```

It will also detect any URLs inside the text that aren't wrapped in anchor tags and create links for them too.

### Customizing Appearence

Changing the appearence of MDHTMLLabel can be done similarly to UILabel, but with many more features. Inline styling can be done using [HTML font tags](http://www.w3schools.com/tags/tag_font.asp) which allows you use different combinations of fonts, colors and sizes throughout the text. Changing fonts is done using the `face` attribute and must be set to a string that's interpretable by `+UIFont fontWithName:`.

Here's an example of how it's used in the demo app.

```objective-c
NSString *const kDemoText = @"... <font face='Didot-Italic' size='19'>customise</font>  ..."
```

MDHTMLLabel also allows you to change the appearence of links inside the text using the `linkAttributes` property which takes an `NSDictionary` of values representing how links should be styled. You can also set the appearence for highlighted links when the user taps one too using the `ativeLinkAttributes` property.

```objective-c
MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] initWithFrame:frame];
htmlLabel.delegate = self;
htmlLabel.htmlText = htmlText;

htmlLabel.linkAttributes = @{ NSForegroundColorAttributeName: [UIColor blueColor],
                              NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                              NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };

htmlLabel.activeLinkAttributes = @{ NSForegroundColorAttributeName: [UIColor redColor],
                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
```

## Special Thanks

MDHTMLLabel is based off of [RTLabel](https://github.com/honcheng/RTLabel) and wouldn't have been possible to make without it

## License

MDHTMLLabel is available under the MIT license. See the LICENSE file for more info.
