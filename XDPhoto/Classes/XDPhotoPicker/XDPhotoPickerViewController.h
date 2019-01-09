//
//  XDPhotoPickerViewController.h
//  Pods-XDPhoto_Example
//
//  Created by XiaoDev on 2018/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XDPhotoPickerControllerDelegate <NSObject>

/**
 选择后回调的选择内容

 @param photos 选择后的数组
 */
- (void)xdPhotoPickerDidFinishPickerArray:(NSArray *)photos;

@end


@interface XDPhotoPickerViewController : UIViewController
@property (nonatomic, weak) id<XDPhotoPickerControllerDelegate>delegate;
// 每次选择图片的最小数, 默认或者设置0，可以选择无限。
@property (nonatomic, assign) NSInteger maxCount;
// 记录选中的值
@property (strong, nonatomic) NSArray *selectPickers;
@property (nonatomic, assign) BOOL allowPreview;

@end

NS_ASSUME_NONNULL_END
