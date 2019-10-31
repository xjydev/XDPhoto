//
//  XDPhotoBrowerCoCell.m
//  JSONModel
//
//  Created by XiaoDev on 2018/12/19.
//

#import "XDPhotoBrowerCoCell.h"
@interface XDPhotoBrowerCoCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *backScrollView;
@property (nonatomic, strong)UIImageView  *imageView;
@property (nonatomic, strong)UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, strong)UIPinchGestureRecognizer *pinchGR;
@end
@implementation XDPhotoBrowerCoCell
- (void)setCellImage:(UIImage *)image {
    [self.backScrollView setZoomScale:1.0 animated:NO];
    [self.imageView setImage:image];
    [self.imageView sizeThatFits:self.backScrollView.frame.size];
}
- (id)init {
    self = [super init];
    if (self) {
        [self addSubview:self.backScrollView];
    }
    return self;
}
- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] init];
        _backScrollView.bouncesZoom = YES;
        _backScrollView.maximumZoomScale = 2.5;
        _backScrollView.minimumZoomScale = 1.0;
        _backScrollView.multipleTouchEnabled = YES;
        _backScrollView.delegate = self;
        _backScrollView.scrollsToTop = YES;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = YES;
        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backScrollView.delaysContentTouches = NO;
        _backScrollView.canCancelContentTouches = YES;
        _backScrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            _backScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_backScrollView addSubview:self.imageView];
    }
    return _backScrollView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageView addGestureRecognizer:self.longPressGR];
//        [_imageView addGestureRecognizer:self.pinchGR];
    }
    return _imageView;
}
- (UILongPressGestureRecognizer *)longPressGR {
    if (!_longPressGR) {
        _longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGRAction:)];
        _longPressGR.delegate = self;
    }
    return _longPressGR;
}

//- (UIPinchGestureRecognizer *)pinchGR {
//    if (!_pinchGR) {
//        _pinchGR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGRAction:)];
//        _pinchGR.delegate = self;
//    }
//    return _pinchGR;
//}
- (void)longPressGRAction:(UILongPressGestureRecognizer *)ges {
    
}
- (void)pinchGRAction:(UIPinchGestureRecognizer *)pin {
    CGFloat scale = pin.scale;
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.contentSize.width *(1.0+scale), self.backScrollView.contentSize.height *(1.0+scale));
    pin.scale = 1.0;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backScrollView.frame = self.bounds;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
