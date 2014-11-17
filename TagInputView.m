//
//  TagInputView.m
//  TagInput
//
//  Created by Zhang Peng on 13-9-9.
//  Copyright (c) 2013年 Zhang Peng. All rights reserved.
//

#import "TagInputView.h"

#define TAG_BORDER_TOP_PAD 0.05
#define TAG_LABEL_TOP_PAD 0.1

#define TAG_BORDER_LEFT_PAD 0.05
#define TAG_LABEL_LEFT_PAD 0.1

#define TAG_BORER_BOTTOM_PAD 0.05
#define TAG_LABEL_BOTTOM_PAD 0.1

#define TAG_BORDER_RIGHT_PAD 0.05
#define TAG_LABEL_RIGHT_PAD 0.8  // multi to height

#define MIN_FONT_SIZE 12
#define MIN_TEXT_INPUT_WIDTH  30
#define MAX_TAG_CHARACTER 10

@implementation tagLayer
@synthesize tagText;

- (id)init
{
    self = [super init];
    if (self) {
        tagLabel = [[UILabel alloc]init];
        [self addSublayer:tagLabel.layer];
        
        tagText = @"";
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor].CGColor;
        currentFontSize = MIN_FONT_SIZE;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    
    tagLabel.frame = CGRectMake(width*TAG_LABEL_LEFT_PAD,
                                height*TAG_LABEL_TOP_PAD,
                                width*(1-TAG_LABEL_LEFT_PAD-TAG_BORDER_RIGHT_PAD)-TAG_LABEL_RIGHT_PAD* height,
                                height*(1-TAG_LABEL_TOP_PAD - TAG_LABEL_BOTTOM_PAD));
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.font = [UIFont systemFontOfSize:currentFontSize];
                                
}

- (void) setText:(NSString * )text
{
    tagText = text;
    tagLabel.text = text;
    
    CGFloat height = self.frame.size.height;
    
    // calculate the length
    CGSize requireSize = [text sizeWithFont:tagLabel.font constrainedToSize:CGSizeMake(10000, tagLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    
    while (requireSize.height < height*0.8) {
        currentFontSize = currentFontSize +1;
        tagLabel.font = [UIFont systemFontOfSize:currentFontSize];
        requireSize = [text sizeWithFont:tagLabel.font constrainedToSize:CGSizeMake(10000, tagLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    }
    

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (requireSize.width+ TAG_LABEL_RIGHT_PAD* height)/(1-TAG_LABEL_LEFT_PAD-TAG_BORDER_RIGHT_PAD) , height);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // draw out round rect and x
    CGContextSaveGState(ctx);
    
    CGRect drawRect = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    CGPathRef strokeRect = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:drawRect.size.height*0.5].CGPath;

    CGContextAddPath(ctx, strokeRect);
    CGContextClosePath(ctx);

    CGContextSetRGBFillColor(ctx, 0.894, 0.535, 0.378, 1.0);
    CGContextFillPath(ctx);
    
    CGSize selfSize = self.frame.size;
    CGFloat xyWidth = selfSize.height * 0.3;
    CGFloat leftGap = TAG_LABEL_RIGHT_PAD* selfSize.height * 0.3;
    CGFloat topGap = selfSize.height * 0.4;
    CGFloat leftBorder = tagLabel.frame.origin.x + tagLabel.frame.size.width;
    
    CGContextMoveToPoint(ctx, leftBorder + leftGap, topGap);
    CGContextAddLineToPoint(ctx, leftBorder + leftGap + xyWidth, topGap + xyWidth);
    
    CGContextMoveToPoint(ctx, leftBorder + leftGap + xyWidth, topGap);
    CGContextAddLineToPoint(ctx, leftBorder + leftGap, topGap + xyWidth);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (BOOL) isDeleteTouch:(CGPoint)touchLocation
{
    CGFloat leftBorder = tagLabel.frame.origin.x + tagLabel.frame.size.width;
    
    if (touchLocation.x > leftBorder && touchLocation.x < self.frame.size.width &&
        touchLocation.y > 0 && touchLocation.y < self.frame.size.height) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end

@implementation TagInputView
@synthesize tagInput;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:tapGes];
        
        bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:bgScrollView];
        
        tagLayerArray = [[NSMutableArray alloc]init];
        tagInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tagInput.delegate = self;
        tagInput.backgroundColor = [UIColor clearColor];
        [bgScrollView addSubview:tagInput];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    bgScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    // check out a font size
    
    
    
    [self rePosition:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) rePosition: (BOOL) keepPosition
{
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat oldOffSet = bgScrollView.contentOffset.x;
        CGFloat oldWidth = bgScrollView.contentSize.width;
        
        CGFloat currentWidth =0;
        for (int i=0; i< [tagLayerArray count]; i++)
        {
            tagLayer * tmpTagL = [tagLayerArray objectAtIndex:i];
            tmpTagL.frame = CGRectMake(currentWidth, 0, tmpTagL.frame.size.width, self.frame.size.height);
            currentWidth = currentWidth + tmpTagL.frame.size.width;
            [tmpTagL setNeedsDisplay];
        }
        
        if (self.frame.size.width - currentWidth > MIN_TEXT_INPUT_WIDTH)
        {
            tagInput.frame = CGRectMake(currentWidth, 0, self.frame.size.width - currentWidth, self.frame.size.height);
            
            currentWidth = currentWidth + tagInput.frame.size.width;
        }
        else
        {
            tagInput.frame = CGRectMake(currentWidth, 0, MIN_TEXT_INPUT_WIDTH, self.frame.size.height);
            currentWidth = currentWidth + MIN_TEXT_INPUT_WIDTH;
        }
        bgScrollView.contentSize = CGSizeMake(currentWidth, self.frame.size.height);
        
        // set offset to show the input
        
        if (keepPosition) {
            if (oldOffSet < currentWidth)
            {
                CGFloat changeOffset = currentWidth - oldWidth;
                if (changeOffset < 0) {
                    changeOffset =  0;
                }
                bgScrollView.contentOffset = CGPointMake(oldOffSet + changeOffset, 0);
            }
            else
            {
                bgScrollView.contentOffset = CGPointMake(currentWidth - self.frame.size.width, 0);
            }
        }
        else
        {
            bgScrollView.contentOffset = CGPointMake(currentWidth - self.frame.size.width, 0);
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void) enlargeTextInput
{
    [UIView animateWithDuration:0.4 animations:^{
        if (tagInput.frame.size.width < self.frame.size.width * 0.5) {
            CGFloat increaseW = self.frame.size.width * 0.5 - tagInput.frame.size.width;
            
            tagInput.frame = CGRectMake(tagInput.frame.origin.x, 0, tagInput.frame.size.width + increaseW, tagInput.frame.size.height);
            bgScrollView.contentSize = CGSizeMake(bgScrollView.contentSize.width + increaseW, bgScrollView.contentSize.height);
            bgScrollView.contentOffset = CGPointMake(bgScrollView.contentOffset.x
                                                     + increaseW, 0);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void) tapHandler: (UITapGestureRecognizer*)tapGes
{
    CGPoint tapLocation = [tapGes locationInView:self];
    
    BOOL handled = NO;
    // check if any tag label owns it
    for (int i=0; i<[tagLayerArray count]; i++) {
        tagLayer * tmpLayer = [tagLayerArray objectAtIndex:i];
        CGPoint tmpPoint = [tmpLayer convertPoint:tapLocation fromLayer:self.layer];
        if ([tmpLayer containsPoint:tmpPoint]) {
            
            if ([tmpLayer isDeleteTouch:tmpPoint]) {
                [tmpLayer removeFromSuperlayer];
                [tagLayerArray removeObjectAtIndex:i];
                [self rePosition:YES];
            }
            
            handled = YES;
            break;
        }
    }
    
    if (!handled) {
        CGPoint tmpPoint = [tagInput.layer convertPoint:tapLocation fromLayer:self.layer];
        
        if( [tagInput.layer containsPoint:tmpPoint])
        {
            [self enlargeTextInput];
            [tagInput becomeFirstResponder];
        }
    }
}

# pragma mark tagInputView APIs

- (void) insertTags:(NSArray *) tagsArray
{
    for (int i=0; i< [tagsArray count]; i++) {
        NSString * tmpTag = [tagsArray objectAtIndex:i];
        
        if ([tagLayerArray count]>0)
        {
            tagLayer * tmpLayer = [tagLayerArray objectAtIndex:([tagLayerArray count]-1)];
            tagLayer * newLayer = [[tagLayer alloc]init];
            
            newLayer.frame = CGRectMake(tmpLayer.frame.origin.x + tmpLayer.frame.size.width, 0, 100, tmpLayer.frame.size.height);
            [newLayer setText:tmpTag];
            [tagLayerArray addObject:newLayer];
            [bgScrollView.layer addSublayer:newLayer];
            [self rePosition:NO];
        }
        else
        {
            tagLayer * newLayer = [[tagLayer alloc]init];
            
            newLayer.frame = CGRectMake(0, 0, 100, self.frame.size.height);
            [newLayer setText:tmpTag];
            [tagLayerArray addObject:newLayer];
            [bgScrollView.layer addSublayer:newLayer];
            [self rePosition:NO];
        }
    }

}

- (NSArray *) currentTags
{
    // TODO TODO TODO
    NSMutableArray * resultArray = [[NSMutableArray alloc]init];
    for (int i=0; i< [tagLayerArray count]; i++) {
        tagLayer * tmpTagL = [tagLayerArray objectAtIndex:i];
        [resultArray addObject:tmpTagL.tagText];
    }
    return [NSArray arrayWithArray:resultArray];
}

- (void) cleanUp
{
    for (int i=0; i< [tagLayerArray count]; i++) {
        tagLayer * tmpTagL = [tagLayerArray objectAtIndex:i];
        [tmpTagL removeFromSuperlayer];
    }
    tagLayerArray = [[NSMutableArray alloc]init];
    
    tagInput.text = @"";
    
    [self rePosition:NO];
}

#pragma mark UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self enlargeTextInput];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * inputText = textField.text;
    
    if (inputText.length > 0) {
        NSArray * newArray = [NSArray arrayWithObject:inputText];
        [self insertTags:newArray];
        
        textField.text = @"";
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int increaseCount = string.length - range.length;
    int finalCOunt = textField.text.length + increaseCount;
    if (finalCOunt <= MAX_TAG_CHARACTER) {
        
        if ([string isEqualToString:@" "]) {
            [textField resignFirstResponder];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
