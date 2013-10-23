//
//  TagInputView.h
//  TagInput
//
//  Created by Zhang Peng on 13-9-9.
//  Copyright (c) 2013年 Zhang Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface tagLayer : CALayer
{
    UILabel * tagLabel;
    int       currentFontSize;
    NSString * tagText;
}

@property (retain,nonatomic) NSString * tagText;

- (void) setText:(NSString * )text;
- (BOOL) isDeleteTouch:(CGPoint)touchLocation;
@end

@interface TagInputView : UIView <UITextFieldDelegate>
{
    UIScrollView     * bgScrollView;
    
    NSMutableArray   * tagLayerArray;
    UITextField      * tagInput;
}
@property (retain,nonatomic) UITextField      * tagInput;

- (void) insertTags:(NSArray *) tagsArray;
- (NSArray *) currentTags;

- (void) cleanUp;

@end
