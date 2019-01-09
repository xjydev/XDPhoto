//
//  XDPhotoPickerCoCell.m
//  JSONModel
//
//  Created by XiaoDev on 2018/12/19.
//

#import "XDPhotoPickerCoCell.h"
#import "UIImage+XDPhoto.h"
@implementation XDPhotoPickerCoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bImageView.frame = self.contentView.bounds;
        self.centerImageView.frame = self.contentView.bounds;
       
        [self.contentView addSubview:self.bImageView];
        [self.contentView addSubview:self.centerImageView];
        
    }
    return self;
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_selectButton) {
       _selectButton.selected = isSelected;
    }
    if (isSelected) {
        self.centerImageView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    }
    else
    {
        self.centerImageView.backgroundColor = [UIColor clearColor];
    }
}

- (UIImageView *)bImageView {
    if (!_bImageView) {
        _bImageView = [[UIImageView alloc]init];
        _bImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bImageView.layer.masksToBounds = YES;
    }
    return _bImageView;
}
- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init];
    }
    return _centerImageView;
}

- (void)setCenterImage:(UIImage *)image withType:(NSInteger)type{
    [self.bImageView setImage:image];
    if (type == 2) {
        [self.centerImageView setImage:[UIImage imageXDNamed:@"image_video"]];
    }
    else
    {
       [self.centerImageView setImage:nil];
    }
}
- (void)cellActionWithIndex:(NSIndexPath *)index actionHandler:(CellActionHandler)hanler {
    if (!_longPressGes) {
        _longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesAction:)];
        [self addGestureRecognizer:_longPressGes];
    }
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageXDNamed:@"photo_unselect"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageXDNamed:@"photo_selected"] forState:UIControlStateSelected];
        _selectButton.frame = CGRectMake(self.contentView.frame.size.width - 40, 0, 40, 40);
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
    }
    self.cellActionBlock = hanler;
    _index = index;
}
- (void)selectButtonAction:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        if (self.cellActionBlock) {
            self.cellActionBlock(_index,XDPhotoCellActionTypeUnselect);
        }
    }
    else
    {
        button.selected = YES;
        if (self.cellActionBlock) {
            self.cellActionBlock(_index,XDPhotoCellActionTypeSelected);
        }
    }
}
- (void)longPressGesAction:(UILongPressGestureRecognizer *)longPressGes {
    
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        if (self.cellActionBlock) {
            self.cellActionBlock(_index,XDPhotoCellActionTypeDetail);
        }
//        if (![UIMenuController sharedMenuController].menuVisible) {
//            UIMenuItem *detailLink = [[UIMenuItem alloc]initWithTitle:@"详情" action:@selector(DetailAction:)];
//            [[UIMenuController sharedMenuController]setMenuItems:[NSArray arrayWithObjects:detailLink, nil]];
//            [[UIMenuController sharedMenuController]setTargetRect:CGRectMake(CGRectGetMidX(self.contentView.frame), CGRectGetMidY(self.contentView.frame), 20, 20) inView:[UIApplication sharedApplication].keyWindow];
//            [[UIMenuController sharedMenuController]setMenuVisible:YES animated:YES];
//        }
    }
}
- (void)DetailAction:(id)sender {
    
}
@end
