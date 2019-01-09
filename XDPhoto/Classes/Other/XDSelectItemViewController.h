//
//  XDSelectItemViewController.h
//  JSONModel
//
//  Created by XiaoDev on 2019/1/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDSelectItemViewController : UIViewController
@property (nonatomic, copy)void (^didSelectedComplete)(NSInteger index,NSString *str);
@property (nonatomic, strong)NSArray<NSString *> *itemsArray;
@end

NS_ASSUME_NONNULL_END
