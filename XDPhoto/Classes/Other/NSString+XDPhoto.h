//
//  NSString+XDPhoto.h
//  JSONModel
//
//  Created by XiaoDev on 2019/1/2.
//

#import <Foundation/Foundation.h>
#define XDLocalizedString(key, comment) [NSString xdLocalizableString:(key) value:(comment)]


@interface NSString (XDPhoto)
+ (nullable NSString *)xdLocalizableString:(NSString *)key value:(NSString *)value;
@end


