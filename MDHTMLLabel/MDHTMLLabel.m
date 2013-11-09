//
//  MDHTMLLabel.m
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

#import "MDHTMLLabel.h"

NSString *const MDHTMLLabelAttributeColorName = @"MDHTMLAttributeColor";
NSString *const MDHTMLLabelAttributeStrokeWidthName = @"MDHTMLLabelAttributeStrokeWidth";
NSString *const MDHTMLLabelAttributeStrokeColorName = @"MDHTMLLabelAttributeStrokeColor";
NSString *const MDHTMLLabelAttributeFontStyleName = @"MDHTMLLabelAttributeFontStyle";
NSString *const MDHTMLLabelAttributeFontName = @"MDHTMLLabelAttributeFont";
NSString *const MDHTMLLabelAttributeUnderlineName = @"MDHTMLLabelAttributeUnderline";
NSString *const MDHTMLLabelAttributeKerningName = @"MDHTMLLabelAttributeKerning";

NSString *const MDHTMLLabelAttributeFontStyleNormalName = @"MDHTMLLabelAttributeFontStyleNormal";
NSString *const MDHTMLLabelAttributeFontStyleBoldName = @"MDHTMLLabelAttributeFontStyleBold";
NSString *const MDHTMLLabelAttributeFontStyleItalicName = @"MDHTMLLabelAttributeFontStyleItalic";

#pragma mark - MDHTMLLabelButton

@interface MDHTMLLabelButton : UIButton

@property (nonatomic, assign) NSInteger componentIndex;
@property (nonatomic) NSURL *URL;

@end

@implementation MDHTMLLabelButton

@end

#pragma mark - MDHTMLComponent

@interface MDHTMLComponent : NSObject

@property (nonatomic, assign) NSInteger componentIndex;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *htmlTag;

@property (nonatomic) NSMutableDictionary *attributes;

@property (nonatomic, assign) NSInteger position;

- (id)initWithString:(NSString *)string
             htmlTag:(NSString *)htmlTag
          attributes:(NSMutableDictionary *)attributes;

- (id)initWithTag:(NSString *)htmlTag
         position:(NSInteger)position
       attributes:(NSMutableDictionary *)attributes;

@end

@implementation MDHTMLComponent

- (id)initWithString:(NSString *)string
             htmlTag:(NSString *)htmlTag
          attributes:(NSMutableDictionary *)attributes
{
    self = [super init];

	if (self)
    {
		self.text = string;
        self.htmlTag = htmlTag;
		self.attributes = attributes;
	}

	return self;
}

- (id)initWithTag:(NSString *)htmlTag
         position:(NSInteger)position
       attributes:(NSMutableDictionary *)attributes
{
    self = [super init];

    if (self)
    {
        self.htmlTag = htmlTag;
		self.position = position;
		self.attributes = attributes;
    }

    return self;
}

- (NSString *)description
{
	NSMutableString *desc = [NSMutableString string];
	[desc appendFormat:@"Text: %@", self.text];
	[desc appendFormat:@"\nPosition: %li", (long)self.position];

    if (self.htmlTag)
    {
        [desc appendFormat:@"\nHTML Tag: %@", self.htmlTag];
    }

    if (self.attributes)
    {
        [desc appendFormat:@"\nAttributes: %@", self.attributes];
    }

	return desc;
}

@end

#pragma mark - MDHTMLExtractedStyle

@interface MDHTMLExtractedStyle : NSObject

@property (nonatomic, strong) NSMutableArray *styleComponents;
@property (nonatomic, copy) NSString *plainText;

- (instancetype)initWithStyleComponents:(NSMutableArray *)styleComponents
                             plainText:(NSString *)plainText;

@end

@implementation MDHTMLExtractedStyle

- (instancetype)initWithStyleComponents:(NSMutableArray *)styleComponents
                             plainText:(NSString *)plainText
{
    self = [super init];

    if (self)
    {
        self.styleComponents = styleComponents;
        self.plainText = plainText;
    }

    return self;
}

@end

@interface MDHTMLLabel ()

@property (nonatomic, copy) NSString *plainText;

@property (nonatomic, strong) NSMutableArray *styleComponents;
@property (nonatomic, strong) NSMutableArray *highlightedStyleComponents;

@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, assign) NSInteger selectedLinkComponentIndex;
@property (nonatomic, assign) BOOL highlighted;

- (MDHTMLExtractedStyle *)extractStyleFromText:(NSString *)data;

- (NSString *)detectURLsInText:(NSString *)text;

- (void)render;

- (void)applyItalicStyleToText:(CFMutableAttributedStringRef)text
                    atPosition:(NSInteger)position
                    withLength:(NSInteger)length;

- (void)applyBoldStyleToText:(CFMutableAttributedStringRef)text
                  atPosition:(NSInteger)position
                  withLength:(NSInteger)length;

- (void)applyBoldItalicStyleToText:(CFMutableAttributedStringRef)text
                        atPosition:(NSInteger)position
                        withLength:(NSInteger)length;

- (void)applyColor:(id)value
            toText:(CFMutableAttributedStringRef)text
        atPosition:(NSInteger)position
        withLength:(NSInteger)length;

- (void)applySingleUnderlineText:(CFMutableAttributedStringRef)text
                      atPosition:(NSInteger)position
                      withLength:(NSInteger)length;

- (void)applyDoubleUnderlineText:(CFMutableAttributedStringRef)text
                      atPosition:(NSInteger)position
                      withLength:(NSInteger)length;

- (void)applyUnderlineColor:(NSString *)value
                     toText:(CFMutableAttributedStringRef)text
                 atPosition:(NSInteger)position
                 withLength:(NSInteger)length;

- (void)applyFontAttributes:(NSDictionary *)attributes
                     toText:(CFMutableAttributedStringRef)text
                 atPosition:(NSInteger)position
                 withLength:(NSInteger)length;

- (void)applyParagraphStyleToText:(CFMutableAttributedStringRef)text
                       attributes:(NSMutableDictionary *)attributes
                       atPosition:(NSInteger)position
                       withLength:(NSInteger)length;

- (NSArray *)colorComponentsForHex:(NSString *)hexColor;

@end

@implementation MDHTMLLabel

- (id)init
{
    self = [super init];

    if (self)
	{
		[self initialize];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
	{
		[self initialize];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
	{
		[self initialize];
    }

    return self;
}

- (void)initialize
{
	self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = YES;

	self.font = [UIFont systemFontOfSize:16];
	self.textColor = [UIColor blackColor];
	self.text = @"";
	self.textAlignment = NSTextAlignmentLeft;
	self.lineBreakMode = NSLineBreakByWordWrapping;
	self.lineSpacing = 3;
	self.selectedLinkComponentIndex = -1;
    self.shadowColor = nil;
    self.shadowOffset = CGSizeZero;
    self.shadowRadius = 1.0;
}

#pragma mark - Setters

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
	_textAlignment = textAlignment;
	[self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
	_lineBreakMode = lineBreakMode;
	[self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted != _highlighted)
    {
        _highlighted = highlighted;

        [self setNeedsDisplay];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setText:(NSString *)text
{
	_text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];

    _text = [self detectURLsInText:_text];

    MDHTMLExtractedStyle *component = [self extractStyleFromText:_text];
    self.styleComponents = component.styleComponents;
    self.plainText = component.plainText;

    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Data Detection

- (NSString *)detectURLsInText:(NSString *)text
{
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];

    NSArray *matches = [detector matchesInString:text
                                         options:0
                                           range:NSMakeRange(0, text.length)];

    for (NSTextCheckingResult *match in matches)
    {
        if (match.resultType == NSTextCheckingTypeLink)
        {
            if (match.range.location > 6 && ![[text substringWithRange:NSMakeRange(match.range.location-6, 4)] isEqualToString:@"href"])
            {
                text = [text stringByReplacingCharactersInRange:match.range
                                                     withString:[NSString stringWithFormat:@"<a href='%@'>%@</a>", match.URL.absoluteString, match.URL.absoluteString]];
            }
        }
    }

    return text;
}

#pragma mark - Drawing

+ (CGFloat)heightForHTMLString:(NSString *)htmlString
                      withFont:(UIFont *)font
    andPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth
{
    MDHTMLLabel *label = [[MDHTMLLabel alloc] init];
    label.text = htmlString;
    label.font = font;
    label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;

    return label.contentSize.height;
}

- (CGSize)contentSize
{
	[self render];
    [self invalidateIntrinsicContentSize];

    return _contentSize;
}

- (CGSize)intrinsicContentSize
{
    return self.contentSize;
}

- (void)drawRect:(CGRect)rect
{
	[self render];
}

- (void)render
{
    // Remove buttons from last render
	if (_selectedLinkComponentIndex == -1)
	{
		for (id view in [self subviews])
		{
			if ([view isKindOfClass:[UIView class]])
			{
				[view removeFromSuperview];
			}
		}
	}

    if (!_plainText)
    {
        return;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (context != NULL)
    {
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.frame.size.height);
        CGContextConcatCTM(context, flipVertical);

        if (_shadowColor)
        {
            CGContextSetShadowWithColor(context, _shadowOffset, _shadowRadius, _shadowColor.CGColor);
        }
        else if (!CGSizeEqualToSize(_shadowOffset, CGSizeZero))
        {
            CGContextSetShadow(context, _shadowOffset, _shadowRadius);
        }
    }

    // Create attributed string ref for text
	CFStringRef string = (__bridge CFStringRef)_plainText;
	CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), string);

    // Apply text color to text
	CFMutableDictionaryRef styleDict = CFDictionaryCreateMutable(0, 0, 0, 0);
	CFDictionaryAddValue(styleDict, kCTForegroundColorAttributeName, _textColor.CGColor);
	CFAttributedStringSetAttributes(attrString, CFRangeMake( 0, CFAttributedStringGetLength(attrString)), styleDict, 0);

    CFRelease(styleDict);

    // Apply default paragraph text style
	styleDict = CFDictionaryCreateMutable(0, 0, 0, 0);
	[self applyParagraphStyleToText:attrString attributes:nil atPosition:0 withLength:CFAttributedStringGetLength(attrString)];

    // Apply font to text
	CTFontRef font = CTFontCreateWithName ((__bridge CFStringRef)_font.fontName, _font.pointSize, NULL);
	CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTFontAttributeName, font);

	NSMutableArray *links = [NSMutableArray array];
	NSMutableArray *styleComponents = nil;

    if (self.highlighted)
    {
        styleComponents = self.highlightedStyleComponents;
    }
    else
    {
        styleComponents = self.styleComponents;
    }

    // Loop through each component and apply its style to the text
	for (MDHTMLComponent *component in styleComponents)
	{
		NSInteger index = [styleComponents indexOfObject:component];
		component.componentIndex = index;

		if ([component.htmlTag caseInsensitiveCompare:@"i"] == NSOrderedSame)
		{
			[self applyItalicStyleToText:attrString
                              atPosition:component.position
                              withLength:component.text.length];
		}
		else if ([component.htmlTag caseInsensitiveCompare:@"b"] == NSOrderedSame
                 || [component.htmlTag caseInsensitiveCompare:@"strong"] == NSOrderedSame)
		{
			[self applyBoldStyleToText:attrString
                            atPosition:component.position
                            withLength:[component.text length]];
		}
        else if ([component.htmlTag caseInsensitiveCompare:@"bi"] == NSOrderedSame)
        {
            [self applyBoldItalicStyleToText:attrString
                                  atPosition:component.position
                                  withLength:component.text.length];
        }
		else if ([component.htmlTag caseInsensitiveCompare:@"a"] == NSOrderedSame)
		{
			if (self.selectedLinkComponentIndex == index)
			{
				if (self.selectedLinkAttributes)
				{
					[self applyFontAttributes:self.selectedLinkAttributes
                                       toText:attrString
                                   atPosition:component.position
                                   withLength:component.text.length];
				}
				else
				{
                    [self applyColor:[UIColor redColor]
                              toText:attrString
                          atPosition:component.position
                          withLength:component.text.length];
				}
			}
			else
			{
				if (self.linkAttributes)
				{
					[self applyFontAttributes:self.linkAttributes
                                       toText:attrString
                                   atPosition:component.position
                                   withLength:component.text.length];
				}
				else
				{
                    #ifdef __IPHONE_7_0
                        [self applyColor:self.window.tintColor
                                  toText:attrString
                              atPosition:component.position
                              withLength:component.text.length];
                    #else
                        [self applyColor:[UIColor blueColor]
                                  toText:attrString
                              atPosition:component.position
                              withLength:component.text.length];
                    #endif
				}
			}

			NSString *hrefString = [component.attributes objectForKey:@"href"];
			hrefString = [hrefString stringByReplacingOccurrencesOfString:@"'" withString:@""];
			component.attributes[@"href"] = hrefString;

			[links addObject:component];
		}
		else if ([component.htmlTag caseInsensitiveCompare:@"u"] == NSOrderedSame || [component.htmlTag caseInsensitiveCompare:@"uu"] == NSOrderedSame)
		{
			if ([component.htmlTag caseInsensitiveCompare:@"u"] == NSOrderedSame)
			{
				[self applySingleUnderlineText:attrString
                                    atPosition:component.position
                                    withLength:[component.text length]];
			}
			else if ([component.htmlTag caseInsensitiveCompare:@"uu"] == NSOrderedSame)
			{
				[self applyDoubleUnderlineText:attrString
                                    atPosition:component.position
                                    withLength:[component.text length]];
			}

			if ([component.attributes objectForKey:MDHTMLLabelAttributeColorName])
			{
				id value = [component.attributes objectForKey:MDHTMLLabelAttributeColorName];
				[self applyUnderlineColor:value
                                   toText:attrString
                               atPosition:component.position
                               withLength:[component.text length]];
			}
		}
		else if ([component.htmlTag caseInsensitiveCompare:@"font"] == NSOrderedSame)
		{
			[self applyFontAttributes:component.attributes
                               toText:attrString
                           atPosition:component.position
                           withLength:[component.text length]];
		}
		else if ([component.htmlTag caseInsensitiveCompare:@"p"] == NSOrderedSame)
		{
			[self applyParagraphStyleToText:attrString
                                 attributes:component.attributes
                                 atPosition:component.position
                                 withLength:[component.text length]];
		}
		else if ([component.htmlTag caseInsensitiveCompare:@"center"] == NSOrderedSame)
		{
			[self applyCenterStyleToText:attrString
                              attributes:component.attributes
                              atPosition:component.position
                              withLength:[component.text length]];
		}
	}

    // Create frame to set attributed string in
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);

	CGMutablePathRef path = CGPathCreateMutable();

    CGRect bounds;
    if (_preferredMaxLayoutWidth)
    {
        bounds = CGRectMake(0.0, 0.0, _preferredMaxLayoutWidth, self.frame.size.height);
    }
    else
    {
        bounds = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    }

	CGPathAddRect(path, NULL, bounds);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);

	CFRange range;
    CGSize constraint;
    if (_preferredMaxLayoutWidth)
    {
        constraint = CGSizeMake(_preferredMaxLayoutWidth, CGFLOAT_MAX);
    }
    else
    {
        constraint = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    }

    // Update content size
    self.contentSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, _plainText.length), nil, constraint, &range);

    // Create buttons for link components
	if (_selectedLinkComponentIndex == -1)
	{
		for (MDHTMLComponent *linkableComponents in links)
		{
			CGFloat height = 0.0;

			CFArrayRef frameLines = CTFrameGetLines(frame);
			for (CFIndex i = 0; i < CFArrayGetCount(frameLines); i++)
			{
				CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(frameLines, i);
				CFRange lineRange = CTLineGetStringRange(line);

                CGFloat ascent;
				CGFloat descent;
				CGFloat leading;

				CTLineGetTypographicBounds(line, &ascent, &descent, &leading);

                CGPoint origin;
				CTFrameGetLineOrigins(frame, CFRangeMake(i, 1), &origin);

				if ((linkableComponents.position < lineRange.location && linkableComponents.position + linkableComponents.text.length > (u_int16_t)(lineRange.location))
                    || (linkableComponents.position >= lineRange.location && linkableComponents.position < lineRange.location + lineRange.length))
				{
					CGFloat startOffset = CTLineGetOffsetForStringIndex(CFArrayGetValueAtIndex(frameLines, i), linkableComponents.position, NULL);
					CGFloat endOffset = CTLineGetOffsetForStringIndex(CFArrayGetValueAtIndex(frameLines, i), linkableComponents.position + linkableComponents.text.length, NULL);

					CGFloat buttonWidth = endOffset - startOffset;

					MDHTMLLabelButton *linkButton = [[MDHTMLLabelButton alloc] initWithFrame:CGRectMake(startOffset + origin.x, height, buttonWidth, ascent + descent)];
                    linkButton.backgroundColor = [UIColor clearColor];
                    linkButton.componentIndex = linkableComponents.componentIndex;
                    linkButton.URL = [NSURL URLWithString:[linkableComponents.attributes objectForKey:@"href"]];

					[linkButton addTarget:self action:@selector(linkTouchDown:) forControlEvents:UIControlEventTouchDown];
					[linkButton addTarget:self action:@selector(linkTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
					[linkButton addTarget:self action:@selector(linkPressed:) forControlEvents:UIControlEventTouchUpInside];

                    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                                             action:@selector(linkLongPressed:)];
                    longPressGestureRecognizer.minimumPressDuration = 1.0;
                    [linkButton addGestureRecognizer:longPressGestureRecognizer];

                    [self addSubview:linkButton];
				}

				origin.y = self.frame.size.height - origin.y;
				height = origin.y + descent + _lineSpacing;
			}
		}
	}

	CFRelease(font);
	CFRelease(path);
	CFRelease(styleDict);
	CFRelease(framesetter);
	CTFrameDraw(frame, context);
    CFRelease(frame);
}

#pragma mark - Styling methods

- (NSArray *)colorComponentsForHex:(NSString *)hexColor
{
	hexColor = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    NSRange range;
    range.location = 0;
    range.length = 2;

    NSString *rString = [hexColor substringWithRange:range];

    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];

    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];

    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

	NSArray *components = @[[NSNumber numberWithFloat:((float) r / 255.0f)],
                            [NSNumber numberWithFloat:((float) g / 255.0f)],
                            [NSNumber numberWithFloat:((float) b / 255.0f)],
                            [NSNumber numberWithFloat:1.0]];

    return components;
}

- (void)applyParagraphStyleToText:(CFMutableAttributedStringRef)text
                       attributes:(NSMutableDictionary *)attributes
                       atPosition:(NSInteger)position
                       withLength:(NSInteger)length
{
	CFMutableDictionaryRef styleDict = ( CFDictionaryCreateMutable( (0), 0, (0), (0) ) );

	CTWritingDirection direction = kCTWritingDirectionLeftToRight;

	CGFloat firstLineIndent = 0.0;
	CGFloat headIndent = 0.0;
	CGFloat tailIndent = 0.0;

    CGFloat lineHeightMultiple = 1.0;
	CGFloat maxLineHeight = 0;
	CGFloat minLineHeight = 0;

    CGFloat paragraphSpacing = 0.0;
	CGFloat paragraphSpacingBefore = 0.0;

    CTTextAlignment textAlignment = (CTTextAlignment)_textAlignment;
	CTLineBreakMode lineBreakMode = (CTLineBreakMode)_lineBreakMode;

    CGFloat lineSpacing = _lineSpacing;

	for (NSUInteger i = 0; i < attributes.allKeys.count; i++)
	{
		NSString *key = [[attributes allKeys] objectAtIndex:i];
		id value = [attributes objectForKey:key];

		if ([key caseInsensitiveCompare:@"align"] == NSOrderedSame)
		{
			if ([value caseInsensitiveCompare:@"left"] == NSOrderedSame)
			{
				textAlignment = kCTLeftTextAlignment;
			}
			else if ([value caseInsensitiveCompare:@"right"] == NSOrderedSame)
			{
				textAlignment = kCTRightTextAlignment;
			}
			else if ([value caseInsensitiveCompare:@"justify"] == NSOrderedSame)
			{
				textAlignment = kCTJustifiedTextAlignment;
			}
			else if ([value caseInsensitiveCompare:@"center"] == NSOrderedSame)
			{
				textAlignment = kCTCenterTextAlignment;
			}
		}
		else if ([key caseInsensitiveCompare:@"indent"] == NSOrderedSame)
		{
			firstLineIndent = [value floatValue];
		}
		else if ([key caseInsensitiveCompare:@"linebreakmode"] == NSOrderedSame)
		{
			if ([value caseInsensitiveCompare:@"wordwrap"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByWordWrapping;
			}
			else if ([value caseInsensitiveCompare:@"charwrap"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByCharWrapping;
			}
			else if ([value caseInsensitiveCompare:@"clipping"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByClipping;
			}
			else if ([value caseInsensitiveCompare:@"truncatinghead"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByTruncatingHead;
			}
			else if ([value caseInsensitiveCompare:@"truncatingtail"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByTruncatingTail;
			}
			else if ([value caseInsensitiveCompare:@"truncatingmiddle"] == NSOrderedSame)
			{
				lineBreakMode = kCTLineBreakByTruncatingMiddle;
			}
		}
	}

	CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment },
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode  },
		{ kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &direction },
		{ kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing },
		{ kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineIndent },
		{ kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent },
		{ kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent },
		{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple },
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight },
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight },
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing },
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore }
	};


	CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));
	CFDictionaryAddValue(styleDict, kCTParagraphStyleAttributeName, paragraphRef);

	CFAttributedStringSetAttributes(text, CFRangeMake(position, length), styleDict, 0);

	CFRelease(paragraphRef);
    CFRelease(styleDict);
}

- (void)applyCenterStyleToText:(CFMutableAttributedStringRef)text
                    attributes:(NSMutableDictionary *)attributes
                    atPosition:(NSInteger)position
                    withLength:(NSInteger)length
{
	CFMutableDictionaryRef styleDict = CFDictionaryCreateMutable(0, 0, 0, 0) ;

	CTWritingDirection direction = kCTWritingDirectionLeftToRight;

	CGFloat firstLineIndent = 0.0;
	CGFloat headIndent = 0.0;
	CGFloat tailIndent = 0.0;

	CGFloat lineHeightMultiple = 1.0;

    CGFloat maxLineHeight = 0;
	CGFloat minLineHeight = 0;

    CGFloat paragraphSpacing = 0.0;
	CGFloat paragraphSpacingBefore = 0.0;

    NSInteger textAlignment = _textAlignment;
	NSInteger lineBreakMode = _lineBreakMode;
	NSInteger lineSpacing = (NSInteger)_lineSpacing;

    textAlignment = kCTCenterTextAlignment;

	CTParagraphStyleSetting settings[] =
	{
		{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment },
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode  },
		{ kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &direction },
		{ kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing },
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineIndent },
		{ kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent },
		{ kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent },
		{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple },
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight },
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight },
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing },
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore }
	};

	CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));
	CFDictionaryAddValue(styleDict, kCTParagraphStyleAttributeName, paragraphRef);

	CFAttributedStringSetAttributes( text, CFRangeMake(position, length), styleDict, 0 );

	CFRelease(paragraphRef);
    CFRelease(styleDict);
}

- (void)applySingleUnderlineText:(CFMutableAttributedStringRef)text
                      atPosition:(NSInteger)position
                      withLength:(NSInteger)length
{
	CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTUnderlineStyleAttributeName,  (__bridge CFNumberRef)[NSNumber numberWithInt:kCTUnderlineStyleSingle]);
}

- (void)applyDoubleUnderlineText:(CFMutableAttributedStringRef)text
                      atPosition:(NSInteger)position
                      withLength:(NSInteger)length
{
	CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTUnderlineStyleAttributeName,  (__bridge CFNumberRef)[NSNumber numberWithInt:kCTUnderlineStyleDouble]);
}

- (void)applyItalicStyleToText:(CFMutableAttributedStringRef)text
                    atPosition:(NSInteger)position
                    withLength:(NSInteger)length
{
    CFTypeRef actualFontRef = CFAttributedStringGetAttribute(text, position, kCTFontAttributeName, NULL);
    CTFontRef italicFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, kCTFontItalicTrait, kCTFontItalicTrait);

    if (!italicFontRef)
    {
        UIFont *font = [UIFont italicSystemFontOfSize:CTFontGetSize(actualFontRef)];
        italicFontRef = CTFontCreateWithName ((__bridge CFStringRef)[font fontName], [font pointSize], NULL);
    }

    CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, italicFontRef);

    CFRelease(italicFontRef);
}

- (void)applyFontAttributes:(NSDictionary *)attributes
                     toText:(CFMutableAttributedStringRef)text
                 atPosition:(NSInteger)position
                 withLength:(NSInteger)length
{
	for (NSString *key in attributes)
	{
		id value = attributes[key];

        if ([value isKindOfClass:[NSString class]])
        {
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@""];
        }

		if ([key isEqualToString:MDHTMLLabelAttributeColorName])
		{
			[self applyColor:value toText:text atPosition:position withLength:length];
		}
		else if ([key isEqualToString:MDHTMLLabelAttributeStrokeWidthName])
		{
			CFAttributedStringSetAttribute(text,
                                           CFRangeMake(position, length),
                                           kCTStrokeWidthAttributeName,
                                           (__bridge CFTypeRef)([attributes objectForKey:MDHTMLLabelAttributeStrokeWidthName]));
		}
        else if ([key isEqualToString:MDHTMLLabelAttributeStrokeColorName])
		{
			[self applyStrokeColor:value toText:text atPosition:position withLength:length];
		}
		else if ([key isEqualToString:MDHTMLLabelAttributeKerningName])
		{
			CFAttributedStringSetAttribute(text,
                                           CFRangeMake(position, length),
                                           kCTKernAttributeName,
                                           (__bridge CFTypeRef)([attributes objectForKey:MDHTMLLabelAttributeKerningName]));
		}
		else if ([key isEqualToString:MDHTMLLabelAttributeUnderlineName])
		{
			NSInteger numberOfLines = [value intValue];
			if (numberOfLines == 1)
			{
				[self applySingleUnderlineText:text atPosition:position withLength:length];
			}
			else if (numberOfLines == 2)
			{
				[self applyDoubleUnderlineText:text atPosition:position withLength:length];
			}
		}
		else if ([key isEqualToString:MDHTMLLabelAttributeFontStyleName])
		{
			if ([value isEqualToString:MDHTMLLabelAttributeFontStyleBoldName])
			{
				[self applyBoldStyleToText:text atPosition:position withLength:length];
			}
			else if ([value isEqualToString:MDHTMLLabelAttributeFontStyleItalicName])
			{
				[self applyItalicStyleToText:text atPosition:position withLength:length];
			}
		}
	}

	UIFont *font = [attributes objectForKey:MDHTMLLabelAttributeFontName];

	if (font)
	{
		CTFontRef customFont = CTFontCreateWithName ((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
		CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, customFont);
		CFRelease(customFont);
	}
}

- (void)applyBoldStyleToText:(CFMutableAttributedStringRef)text
                  atPosition:(NSInteger)position
                  withLength:(NSInteger)length
{
    CFTypeRef actualFontRef = CFAttributedStringGetAttribute(text, position, kCTFontAttributeName, NULL);
    CTFontRef boldFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, kCTFontBoldTrait, kCTFontBoldTrait);

    if (!boldFontRef)
    {
        UIFont *font = [UIFont boldSystemFontOfSize:CTFontGetSize(actualFontRef)];
        boldFontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, _font.pointSize, NULL);
    }

    CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, boldFontRef);

    CFRelease(boldFontRef);
}

- (void)applyBoldItalicStyleToText:(CFMutableAttributedStringRef)text
                        atPosition:(NSInteger)position
                        withLength:(NSInteger)length
{
    CFTypeRef actualFontRef = CFAttributedStringGetAttribute(text, position, kCTFontAttributeName, NULL);
    CTFontRef boldItalicFontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, kCTFontBoldTrait | kCTFontItalicTrait , kCTFontBoldTrait | kCTFontItalicTrait);

    if (!boldItalicFontRef)
    {
        NSString *fontName = [NSString stringWithFormat:@"%@-BoldOblique", _font.fontName];
        boldItalicFontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, _font.pointSize, NULL);
    }

    if (boldItalicFontRef)
    {
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTFontAttributeName, boldItalicFontRef);
        CFRelease(boldItalicFontRef);
    }
}

- (void)applyColor:(id)value
            toText:(CFMutableAttributedStringRef)text
        atPosition:(NSInteger)position
        withLength:(NSInteger)length
{
    if ([value isKindOfClass:[UIColor class]])
    {
        UIColor *color = (UIColor *)value;
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTForegroundColorAttributeName, color.CGColor);
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        if ([value rangeOfString:@"#"].location == 0)
        {
            if ([value rangeOfString:@"#"].location == 0)
            {
                value = [value stringByReplacingOccurrencesOfString:@"#" withString:@""];
            }

            CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

            NSArray *colorComponents = [self colorComponentsForHex:value];

            CGFloat components[] = {[[colorComponents objectAtIndex:0] floatValue],
                [[colorComponents objectAtIndex:1] floatValue],
                [[colorComponents objectAtIndex:2] floatValue],
                [[colorComponents objectAtIndex:3] floatValue]};

            CGColorRef color = CGColorCreate(rgbColorSpace, components);
            CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTForegroundColorAttributeName, color);
            
            CFRelease(color);
            CGColorSpaceRelease(rgbColorSpace);
        }
    }
}

- (void)applyStrokeColor:(id)value
                  toText:(CFMutableAttributedStringRef)text
              atPosition:(NSInteger)position
              withLength:(NSInteger)length
{
    if ([value isKindOfClass:[UIColor class]])
    {
        UIColor *color = (UIColor *)value;
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTStrokeColorAttributeName, color.CGColor);
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        if ([value rangeOfString:@"#"].location == 0)
        {
            value = [value stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }

        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

        NSArray *colorComponents = [self colorComponentsForHex:value];

        CGFloat components[] = {[[colorComponents objectAtIndex:0] floatValue],
            [[colorComponents objectAtIndex:1] floatValue],
            [[colorComponents objectAtIndex:2] floatValue],
            [[colorComponents objectAtIndex:3] floatValue]};

        CGColorRef color = CGColorCreate(rgbColorSpace, components);
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTStrokeColorAttributeName, color);

        CFRelease(color);
        CGColorSpaceRelease(rgbColorSpace);
    }
}

- (void)applyUnderlineColor:(id)value
                     toText:(CFMutableAttributedStringRef)text
                 atPosition:(NSInteger)position withLength:(NSInteger)length
{
    if ([value isKindOfClass:[UIColor class]])
    {
        UIColor *color = (UIColor *)value;
        CFAttributedStringSetAttribute(text, CFRangeMake(position, length), kCTForegroundColorAttributeName, color.CGColor);
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        value = [value stringByReplacingOccurrencesOfString:@"'" withString:@""];

        if ([value rangeOfString:@"#"].location==0)
        {
            CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            value = [value stringByReplacingOccurrencesOfString:@"#" withString:@""];

            NSArray *colorComponents = [self colorComponentsForHex:value];

            CGFloat components[] = {[[colorComponents objectAtIndex:0] floatValue],
                                    [[colorComponents objectAtIndex:1] floatValue],
                                    [[colorComponents objectAtIndex:2] floatValue],
                                    [[colorComponents objectAtIndex:3] floatValue]};

            CGColorRef color = CGColorCreate(rgbColorSpace, components);
            CFAttributedStringSetAttribute(text, CFRangeMake(position, length),kCTUnderlineColorAttributeName, color);
            CGColorRelease(color);
            CGColorSpaceRelease(rgbColorSpace);
        }
    }
}

#pragma mark - Link interaction handling

- (void)linkTouchDown:(id)sender
{
	MDHTMLLabelButton *button = (MDHTMLLabelButton *)sender;
    self.selectedLinkComponentIndex = button.componentIndex;

	[self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)linkTouchUpOutside:(id)sender
{
	self.selectedLinkComponentIndex = -1;

	[self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

- (void)linkPressed:(id)sender
{
	MDHTMLLabelButton *button = (MDHTMLLabelButton *)sender;
    self.selectedLinkComponentIndex = -1;

	[self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];

	if ([_delegate respondsToSelector:@selector(HTMLLabel:didSelectLinkWithURL:)])
	{
		[_delegate HTMLLabel:self didSelectLinkWithURL:button.URL];
	}
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        MDHTMLLabelButton *button = (MDHTMLLabelButton *)sender.view;
        self.selectedLinkComponentIndex = -1;

        [self setNeedsDisplay];
        [self invalidateIntrinsicContentSize];

        if ([_delegate respondsToSelector:@selector(HTMLLabel:didHoldLinkWithURL:)])
        {
            [_delegate HTMLLabel:self didHoldLinkWithURL:button.URL];
        }
    }
}

#pragma mark - Style methods

- (MDHTMLExtractedStyle *)extractStyleFromText:(NSString *)data
{
    // Replace html entities for angle brackets
    data = [data stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    data = [data stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];

	NSMutableArray *components = [NSMutableArray array];
    NSInteger last_position = 0;
    NSString *text = nil;
	NSString *htmlTag = nil;

    NSScanner *scanner = [NSScanner scannerWithString:data];

    while (!scanner.isAtEnd)
    {
        int tagStartPosition = scanner.scanLocation;

        // Capture tag text
		[scanner scanUpToString:@"<" intoString:NULL];
		[scanner scanUpToString:@">" intoString:&text];

		NSString *fullTag = [NSString stringWithFormat:@"%@>", text];

        NSInteger position = [data rangeOfString:fullTag].location;
		if (position != NSNotFound)
		{
            // Remove tag from text and replace occurences of paragraph tags
			if ([fullTag rangeOfString:@"<p"].location == 0 && tagStartPosition != 0)
			{
				data = [data stringByReplacingOccurrencesOfString:fullTag
                                                       withString:@"\n"
                                                          options:NSCaseInsensitiveSearch
                                                            range:NSMakeRange(last_position, position + fullTag.length - last_position)];
			}
			else
			{
				data = [data stringByReplacingOccurrencesOfString:fullTag
                                                       withString:@""
                                                          options:NSCaseInsensitiveSearch
                                                            range:NSMakeRange(last_position, position + fullTag.length - last_position)];
			}
		}

        // Found closing tag
		if ([text rangeOfString:@"</"].location == 0)
		{
            // Get just the html tag value
			htmlTag = [text substringFromIndex:2];

			if (position != NSNotFound)
			{
                // Find the the corresponding component for the closing tag
				for (NSInteger i = components.count - 1; i >= 0; i--)
				{
					MDHTMLComponent *component = components[i];
					if (component.text == nil && [component.htmlTag isEqualToString:htmlTag])
					{
						NSString *componentText = [data substringWithRange:NSMakeRange(component.position, position - component.position)];
						component.text = componentText;
						break;
					}
				}
			}
		}
		else
		{
            // Get text components without the opening '<'
			NSArray *textComponents = [[text substringFromIndex:1] componentsSeparatedByString:@" "];

            // Capture html tag for later
            htmlTag = textComponents[0];

            // Capture the tag's attributes
			NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
			for (NSUInteger i = 1; i < textComponents.count; i++)
			{
				NSArray *pair = [[textComponents objectAtIndex:i] componentsSeparatedByString:@"="];
				if (pair.count > 0)
                {
					NSString *key = [[pair objectAtIndex:0] lowercaseString];

					if (pair.count >= 2)
                    {
						NSString *value = [[pair subarrayWithRange:NSMakeRange(1, [pair count] - 1)] componentsJoinedByString:@"="];
						value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, 1)];
						value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange([value length]-1, 1)];

						[attributes setObject:value forKey:key];
					}
                    else if (pair.count == 1)
                    {
						[attributes setObject:key forKey:key];
					}
				}
			}

            // Create component from tag and attributes, we'll know the text once we reach the closing tag
            MDHTMLComponent *component = [[MDHTMLComponent alloc] initWithString:nil htmlTag:htmlTag attributes:attributes];
			component.position = position;

			[components addObject:component];
		}

		last_position = position;
	}

    return [[MDHTMLExtractedStyle alloc] initWithStyleComponents:components plainText:data];
}

@end

