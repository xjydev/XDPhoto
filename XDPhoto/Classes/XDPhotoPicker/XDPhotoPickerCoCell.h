//
//  XDPhotoPickerCoCell.h
//  JSONModel
//
//  Created by XiaoDev on 2018/12/19.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XDPhotoCellActionType) {
    XDPhotoCellActionTypeDetail,//详情
    XDPhotoCellActionTypeSelected,//选择
    XDPhotoCellActionTypeUnselect,//未选择
};
NS_ASSUME_NONNULL_BEGIN
typedef void (^CellActionHandler)(NSIndexPath *index,XDPhotoCellActionType type);

@interface XDPhotoPickerCoCell : UICollectionViewCell
{
    UILongPressGestureRecognizer *_longPressGes;
    UIButton                     *_selectButton;
    NSIndexPath                  *_index;
}
@property (nonatomic, copy)CellActionHandler cellActionBlock;
@property (nonatomic, strong)UIImageView *bImageView;
@property (nonatomic, strong)UIButton    *selectButton;
@property (nonatomic, strong)UIImageView *centerImageView;
@property (nonatomic, assign)BOOL isSelected;
- (void)setCenterImage:(UIImage *)image withType:(NSInteger)type;

- (void)cellActionWithIndex:(NSIndexPath *)index actionHandler:(CellActionHandler)hanler;

@end

NS_ASSUME_NONNULL_END
