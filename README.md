MDHTMLLabel
===========

MDHTMLLabel is a lightweight, easy to use class for rendering text containing HTML tags on iOS 6.0+. It behaves almost exactly the same as UILabel and allows you to fully customize its appearence with added features thanks to CoreText. It also lets you handle when a user taps or holds down a link in the label unlike many similar libraries.

It provides:

- Link interaction
- Auto-detection of URLs not wrapped in anchor tags
- Bold and italic text styles
- Color and stroke styles
- Indentation, kerning and line spacing settings
- Text shadow styles

<p align="center" >
  <img src="https://raw.github.com/mattdonnelly/MDHTMLLabel/master/Screenshot.png" alt="MDHTMLLabel" title="MDHTMLLabel">
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
    htmlLabel.text = text;

    [self.view addSubview:htmlLabel];
}
```

### Link Interaction

MDHTMLLabel automatically creates user interactable links inside the label to represent HTML achor tags and allows you to detect when a user taps or holds down on a link by implementing an optional delgate. The delegate has two methods for you to implement: 

```objective-c
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL
- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL *)URL
```

It will also detect any URLs inside the text that aren't wrapped in anchor tags and create links for them too.

### Customizing Appearence

Changing the appearence of MDHTMLLabel is the as how you would go about doing it for UILabel, however it also allows you to change the appearence of links inside the text using the `linkAttributes` property which takes an `NSDictionary` of values representing how links should be styled. You can also set the appearence for highlighted links when the user taps one too using the `selectedLinkAttributes` property.

```objective-c
MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] initWithFrame:frame];
htmlLabel.delegate = self;
htmlLabel.text = text;

htmlLabel.linkAttributes = @{MDHTMLLabelAttributeColorName: [UIColor blueColor],
                             MDHTMLLabelAttributeFontName: [UIFont boldSystemFontOfSize:14.0f],
                             MDHTMLLabelAttributeUnderlineName: @(1)};

htmlLabel.selectedLinkAttributes = @{MDHTMLLabelAttributeColorName: @"#ff0000",
                                     MDHTMLLabelAttributeFontName: [UIFont boldSystemFontOfSize:14.0f]};
```

See the header file for the complete list of attributes you can specify.

## Special Thanks

MDHTMLLabel is based off of [RTLabel](https://github.com/honcheng/RTLabel) and wouldn't have been possible to make without it

## License

MDHTMLLabel is available under the MIT license. See the LICENSE file for more info.
