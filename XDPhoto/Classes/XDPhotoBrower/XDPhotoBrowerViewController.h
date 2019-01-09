//
//  XDPhotoBrowerViewController.h
//  Pods-XDPhoto_Example
//
//  Created by XiaoDev on 2018/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XDPhotoBrowerDelegate <NSObject>

- (NSInteger)xdNumberOfAllPhotos;
- (UIImage *)xdPhotoAtIndex:(NSInteger)index;

@optional

- (UIImage *)xdThumbnailPhotoAtIndex:(NSInteger)index;
- (BOOL)xdPhotoSelectedAtIndex:(NSInteger)index;
- (NSString *)xdPhotoPahtAtIndex:(NSInteger)index;
- (void)xdDeletePhotoAtIndex:(NSInteger)index;
- (void)xdSelectedPhotoAtIndex:(NSInteger)index;
- (NSMutableString *)xdTopTitleAtIndex:(NSInteger)index;

@end

@interface XDPhotoBrowerViewController : UIViewController

@property (nonatomic, assign)BOOL   canDelete;
@property (nonatomic, assign)BOOL   canSelect;
@property (nonatomic, weak)id<XDPhotoBrowerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
