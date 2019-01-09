//
//  UIImage+XDPhoto.m
//  JSONModel
//
//  Created by XiaoDev on 2019/1/2.
//

#import "UIImage+XDPhoto.h"
#import "XDPhoto.h"
@implementation UIImage (XDPhoto)
+ (UIImage *)imageXDNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XDPhoto class]]pathForResource:@"XDPhoto"
                                                 ofType:@"bundle"]];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}
@end
