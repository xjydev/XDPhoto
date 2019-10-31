//
//  XDPhotoBrowerViewController.m
//  Pods-XDPhoto_Example
//
//  Created by XiaoDev on 2018/11/26.
//

#import "XDPhotoBrowerViewController.h"
#import "XDPhotoBrowerCoCell.h"
#define  cellId @"photobrowercell"
@interface XDPhotoBrowerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *mainCollectionView;
@end

@implementation XDPhotoBrowerViewController
#pragma mark - property
- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //下面空一像素的线
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
//        
//        layout.estimatedItemSize = CGSizeMake(kScreenWidth, kScreenHeight);
//        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
//        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44 + kStatusBarHeight, kScreenWidth, kScreenHeight -44 - 44 - kStatusBarHeight - kBottomBarHeight) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerClass:[XDPhotoBrowerCoCell class] forCellWithReuseIdentifier:cellId];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
    }
    return _mainCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark --CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(xdNumberOfAllPhotos)]) {
        return [self.delegate xdNumberOfAllPhotos];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XDPhotoBrowerCoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
