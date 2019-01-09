//
//  XDPhotoPickerViewController.m
//  Pods-XDPhoto_Example
//
//  Created by XiaoDev on 2018/11/26.
//

#import "XDPhotoPickerViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <XDTools/XDTools.h>
#import <XDTools/UIView+Border.h>
#import <XDTools/UIColor+Hex.h>
#import "XDPhotoPickerCoCell.h"
#import "NSString+XDPhoto.h"
#import "UIImage+XDPhoto.h"
#import "XDSelectItemViewController.h"

#define cellId @"xdPhotoPickercellid"
@interface XDPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate> {
    
    UIBarButtonItem *_rightBarButton;
    
}

@property (nonatomic, strong)UICollectionView *mainCollectionView;
@property (nonatomic, strong)UIButton         *topTitleButton;
@property (nonatomic, strong)UIView           *footerView;
@property (nonatomic, strong)UIButton         *allSelectButton;//全选
@property (nonatomic, strong)UIButton         *previewButton;//预览
@property (nonatomic, strong)UIButton         *improtButton;//导入
@property (nonatomic, strong)NSMutableArray *libraryImagesArray;
@property (nonatomic, strong)NSMutableArray *selectedArray;
@property (nonatomic, strong)NSMutableArray *assetArray;//相册集


@end

@implementation XDPhotoPickerViewController
#pragma mark - property
- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //下面空一像素的线
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat width = kScreenWidth/4;
        layout.estimatedItemSize = CGSizeMake(width, width);
        layout.itemSize = CGSizeMake(width, width);
//        layout.footerReferenceSize = CGSizeMake(kScreenWidth, 44);
//        if (@available(iOS 9.0, *)) {
//            layout.sectionFootersPinToVisibleBounds = YES;
//        } else {
//            // Fallback on earlier versions
//        }
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44 + kStatusBarHeight, kScreenWidth, kScreenHeight -44 - 44 - kStatusBarHeight - kBottomBarHeight) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerClass:[XDPhotoPickerCoCell class] forCellWithReuseIdentifier:cellId];
//        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
    }
    return _mainCollectionView;
}
- (UIButton *)topTitleButton {
    if (!_topTitleButton) {
        _topTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topTitleButton.frame = CGRectMake(0, 0, 200, 44);
        [_topTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topTitleButton setImage:[UIImage imageXDNamed:@"photo_down"] forState:UIControlStateNormal];
        [_topTitleButton setImage:[UIImage imageXDNamed:@"photo_up"] forState:UIControlStateSelected];
        [_topTitleButton addTarget:self action:@selector(topTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topTitleButton;
}
- (void)topTitleButtonAction:(UIButton *)button {
    button.selected = YES;
    XDSelectItemViewController *sItemVC = [[XDSelectItemViewController alloc]init];
    sItemVC.modalPresentationStyle = UIModalPresentationPopover;
    sItemVC.preferredContentSize = CGSizeMake(200, MIN(44*self.assetArray.count, 240));
    sItemVC.popoverPresentationController.sourceView = button;
    sItemVC.popoverPresentationController.sourceRect = CGRectMake(button.center.x, button.center.y, 10, 10);
    //    setV.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    sItemVC.popoverPresentationController.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    sItemVC.popoverPresentationController.delegate = self;
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:self.assetArray.count];
    for (PHAssetCollection *assetCollection in self.assetArray) {
        [titleArr addObject:assetCollection.localizedTitle];
    }
    sItemVC.itemsArray = titleArr;
    @weakify(self);
    sItemVC.didSelectedComplete = ^(NSInteger index, NSString * _Nonnull str) {
        button.selected = NO;
        @strongify(self);
        [self.topTitleButton setTitle:XDLocalizedString(str, @"") forState:UIControlStateNormal];
        PHAssetCollection * assetc = self.assetArray[index];
        [self enumerateAssetsInAssetCollection:assetc original:YES];
    };
    [self presentViewController:sItemVC animated:YES completion:^{
        
    }];
}
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}
- (NSMutableArray *)libraryImagesArray {
    if (!_libraryImagesArray) {
        _libraryImagesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _libraryImagesArray;
}
- (UIButton *)allSelectButton {
    if (!_allSelectButton) {
        _allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allSelectButton.frame = CGRectMake(20, 0, 44, 44);
        [_allSelectButton setImage:[UIImage imageXDNamed:@"photo_unselect_b"] forState:UIControlStateNormal];
        [_allSelectButton setImage:[UIImage imageXDNamed:@"photo_selected"] forState:UIControlStateSelected];
        [_allSelectButton addTarget:self action:@selector(allSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectButton;
}
- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.frame = CGRectMake(84, 0, 120, 44);
        _previewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_previewButton setTitle:XDLocalizedString(@"Preview", @"") forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        _previewButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_previewButton addTarget:self action:@selector(previewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.enabled = NO;//进来默认不可点击
    }
    return _previewButton;
}
- (UIButton *)improtButton {
    if (!_improtButton) {
        _improtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _improtButton.frame = CGRectMake(kScreenWidth - 80, 0, 60, 44);
        [_improtButton setTitle:XDLocalizedString(@"import", @"") forState:UIControlStateNormal];
        [_improtButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_improtButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        _improtButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_improtButton addTarget:self action:@selector(improtButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _improtButton.enabled = NO;//进来默认不可点击
    }
    return _improtButton;
}
//全部导入
- (void)allSelectButtonAction:(UIButton *)button {
    if (self.selectedArray.count == self.libraryImagesArray.count) {
        [self.selectedArray removeAllObjects];
    }
    else
    {
        [self.selectedArray removeAllObjects];
        [self.libraryImagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            [self.selectedArray addObject:dict[@"asset"]];
        }];
    }
    [self reloadBottomStatus];
    [self.mainCollectionView reloadData];
}
//预览选中的
- (void)previewButtonAction:(UIButton *)button {
    
}
//导入
- (void)improtButtonAction:(UIButton *)button {
    [XDTOOLS showAlertTitle:@"确定导入图片" message:[NSString stringWithFormat:@"确定导入应用中已选择的%@张相册图片？",@(self.selectedArray.count)] buttonTitles:@[@"取消",@"确定"] completionHandler:^(NSInteger num) {
        if (num == 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(xdPhotoPickerDidFinishPickerArray:)]) {
                [self.delegate xdPhotoPickerDidFinishPickerArray:self.selectedArray];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight - 44 - kBottomBarHeight , kScreenWidth, 44+kBottomBarHeight)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView setBoarderWithType:XDViewBoarderTypeTop boarderColor:[UIColor ora_colorWithHex:0xeeeeee] boarderWidth:0.5];
        [_footerView addSubview:self.allSelectButton];
        [_footerView addSubview:self.previewButton];
        [_footerView addSubview:self.improtButton];
        
    }
    return _footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册导入";
    _rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
    
    [self.view addSubview:self.mainCollectionView];
    [self.view addSubview:self.footerView];
    
    self.navigationItem.titleView = self.topTitleButton;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status)
        {
            case PHAuthorizationStatusNotDetermined:
            {
                
            }
                break;
            case PHAuthorizationStatusRestricted:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已锁定访问相册权限" message:@"家长控制已锁定悦览播放器访问相册的权限，如若访问，请获取家长控制权限。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }
                break;
            case PHAuthorizationStatusDenied:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未打开访问相册权限" message:@"您未打开悦览播放器访问相册的权限，你可以在设置中打开。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancleAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    } else {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                    
                }];
                [alert addAction:cancleAction];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                
            }
                break;
            case PHAuthorizationStatusAuthorized:
            {
                // 用户已经授权使用
                [self getLibraryImageArray];
                
            }
                break;
        }
        
    }];
}
- (void)rightBarButtonAction:(UIBarButtonItem *)item {
    if (self.selectedArray.count == 0) {
       [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self improtButtonAction:self.improtButton];
    }
    
}

#pragma mark -- 获取相册信息。
- (void)getLibraryImageArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XDTOOLS showLoading:@"正在加载"];
       
    });
   
    // 获得所有的自定义相簿
   
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        // 获得相机胶卷
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        self.assetArray = [NSMutableArray arrayWithCapacity:assetCollections.count +1];
        [self.assetArray addObject:cameraRoll];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
//            [self enumerateAssetsInAssetCollection:assetCollection original:YES];
            [self.assetArray addObject:assetCollection];
        }
        
        
        // 遍历相机胶卷,获取大图
        NSLog(@"视频==%@",cameraRoll.localizedTitle);
        [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
    
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.topTitleButton setTitle:XDLocalizedString(assetCollection.localizedTitle, nil) forState:UIControlStateNormal];
        [XDTOOLS showLoading:@"正在加载"];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.libraryImagesArray removeAllObjects];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        // 获得某个相簿中的所有PHAsset对象
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        for (PHAsset *asset in assets) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
            
            //缩略图
            CGSize thuSize = CGSizeMake(200, 200);
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:thuSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [dict setValue:result forKey:@"Thumbnails"];
                [dict setValue:asset forKey:@"asset"];
                NSLog(@"sub ==%@ == %@",info, result);
            }];
            [self.libraryImagesArray addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [XDTOOLS hideLoading];
            [self.mainCollectionView reloadData];
        });
    });
   
}

#pragma mark --CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.libraryImagesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XDPhotoPickerCoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *dict = self.libraryImagesArray[indexPath.row];
    PHAsset *asset = dict[@"asset"];
    [cell setCenterImage:dict[@"Thumbnails"]withType:asset.mediaType];
    @weakify(self);
    [cell cellActionWithIndex:indexPath actionHandler:^(NSIndexPath * _Nonnull index, XDPhotoCellActionType type) {
        @strongify(self);
        if (type == XDPhotoCellActionTypeSelected) {
            [self didSelectItemAtIndexPath:indexPath];
        }
        else
            if (type == XDPhotoCellActionTypeUnselect) {
                [self didUnSelectItemAtIndexPath:indexPath];
            }
        else
            if (type == XDPhotoCellActionTypeDetail) {
                
            }
    }];
    cell.isSelected = [self.selectedArray containsObject:asset];
    return cell;
}
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDPhotoPickerCoCell *cell = (XDPhotoPickerCoCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = _libraryImagesArray[indexPath.row];
    PHAsset *asset = [dict objectForKey:@"asset"];
    if (![self.selectedArray containsObject:asset]) {
        [self.selectedArray addObject:asset];
        [self reloadBottomStatus];
        cell.isSelected = YES;
    }
}
- (void)didUnSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDPhotoPickerCoCell *cell = (XDPhotoPickerCoCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = _libraryImagesArray[indexPath.row];
    PHAsset *asset = [dict objectForKey:@"asset"];
    if ([self.selectedArray containsObject:asset]) {
        [self.selectedArray removeObject:asset];
        [self reloadBottomStatus];
        cell.isSelected = NO;
    }
}
//底部按钮的状态
- (void)reloadBottomStatus {
    NSString *previewStr = [NSString stringWithFormat:@"预览（%@）",@(self.selectedArray.count)];
    [self.previewButton setTitle:previewStr forState:UIControlStateNormal];
    if (self.selectedArray.count == self.libraryImagesArray.count) {
        self.allSelectButton.selected = YES;
    }
    else
    {
        self.allSelectButton.selected = NO;
    }
    if (self.selectedArray.count == 0) {
        [_rightBarButton setTitle:@"取消"];
        self.improtButton.enabled = NO;
        self.previewButton.enabled = NO;
    }
    else
    {
        [_rightBarButton setTitle:@"导入"];
        self.improtButton.enabled = YES;
        self.previewButton.enabled = YES;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",XDLocalizedString(@"Back", @""));
}

//- (IBAction)previewButtonAction:(id)sender {
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
//
//    [self.navigationController pushViewController:browser animated:YES];
//
//}
//- (IBAction)allSelectButtonAction:(UIButton *)sender {
//    sender.userInteractionEnabled = NO;
//    if (_selectedArray.count == _libraryImagesArray.count) {
//        [_selectedArray removeAllObjects];
//        [sender setTitle:@"全选" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_selectedArray removeAllObjects];
//        [_libraryImagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *dict = obj;
//            [self->_selectedArray addObject:dict[@"asset"]];
//        }];
//        //        for (NSDictionary* dict in _libraryImagesArray) {
//        //
//        //            [_selectedArray addObject:];
//        //
//        //        }
//        [sender setTitle:@"全部取消" forState:UIControlStateNormal];
//    }
//    _selectedLabel.text = [NSString stringWithFormat:@"已选择%d项",(int)_selectedArray.count];
//    [_mainCollectionView reloadData];
//    sender.userInteractionEnabled = YES;
//}
//写入到应用中
//- (void)writeToDocument {
//    [XTOOLS showLoading:@"导入中"];
//    _mainCollectionView.userInteractionEnabled = NO;
//
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_async(group, queue, ^{
//        self->_nameNum = [kUSerD integerForKey:@"userdNameNum"];
//
//        for ( int i=0;i< self->_selectedArray.count;i++) {
//
//            @autoreleasepool {
//                PHAsset *phAsset = self->_selectedArray[i];
//
//                if (phAsset.mediaType == PHAssetMediaTypeVideo) {
//                    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
//                    options.networkAccessAllowed = YES;
//                    [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
//
//                        if ([asset isKindOfClass:[AVURLAsset class]]) {
//                            NSURL *pathUrl = ((AVURLAsset *)asset).URL;
//                            //                        asset.availableChapterLocales
//                            NSString *name =[pathUrl.absoluteString lastPathComponent];
//                            if (!name) {
//                                self->_nameNum++;
//                                name =[NSString stringWithFormat:@"相册视频%d.mov",(int)self->_nameNum];
//                            }
//                            NSError *error;
//                            NSData *moveData = [NSData dataWithContentsOfURL:pathUrl];
//                            [moveData writeToFile:[KDocumentP stringByAppendingPathComponent:name] atomically:YES];
//                            //                            [NSString stringWithFormat:@"%@/%@",KDocumentP,name]
//                            moveData = nil;
//
//                            if(error){
//                                NSLog(@"error == %@",error);
//                            }
//
//
//                        } else {
//
//                        }
//
//                    }];
//
//
//                }
//                else
//                {
//
//
//                    PHImageRequestOptions *options = [PHImageRequestOptions new];
//                    options.networkAccessAllowed = YES;
//                    options.resizeMode = PHImageRequestOptionsResizeModeFast;
//                    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//                    options.synchronous = YES;
//                    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//                        //                        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                        //                                              [NSNumber numberWithDouble: progress], @"progress",
//                        //                                              self, @"photo", nil];
//                        //                        NSLog(@"progress == %@",dict);
//
//                    };
//
//                    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
//                        NSData *imageData ;
//                        NSString *imageType;
//                        if (UIImagePNGRepresentation(result)) {
//                            imageData = UIImagePNGRepresentation(result);
//                            imageType = @".png";
//                        }
//                        else
//                        {
//                            imageData = UIImageJPEGRepresentation(result, 1.0);
//                            imageType = @".jpg";
//                        }
//                        self->_nameNum++;
//                        NSString *imagePath = [NSString stringWithFormat:@"%@/相册%d%@",KDocumentP,(int)self->_nameNum,imageType];
//                        [imageData writeToFile:imagePath  atomically:YES];
//                        imageData = nil;
//                    }];
//
//                }
//
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [XTOOLS showLoading:[NSString stringWithFormat:@"%d/%d",i,(int)self->_selectedArray.count]];
//            });
//        }
//        //结束后就保存以前的相册名称序列，防止以后的重名，然后刷新。
//
//        [self->_selectedArray removeAllObjects];
//        if (self->_nameNum > 999999) {
//            self->_nameNum = 0;
//        }
//        [kUSerD setInteger:self->_nameNum forKey:@"userdNameNum"];
//        [kUSerD synchronize];
//
//    });
//
//    //完成后通知
//    dispatch_group_notify(group, queue, ^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//
//            [XTOOLS hiddenLoading];
//            [XTOOLS showAlertTitle:@"完成" message:@"选择的资源已经导入到应用中，可以在文件列表中查看。" buttonTitles:@[@"知道了"] completionHandler:^(NSInteger num) {
//
//            }];
//
//            if (self->_mainCollectionView) {
//                self->_mainCollectionView.userInteractionEnabled = YES;
//                [self->_mainCollectionView reloadData];
//                self->_selectedLabel.text = @"已选择（0）";
//            }
//        });
//    });
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.topTitleButton.selected = NO;
    return YES;
}
@end
