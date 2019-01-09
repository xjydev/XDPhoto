//
//  NSString+XDPhoto.m
//  JSONModel
//
//  Created by XiaoDev on 2019/1/2.
//

#import "NSString+XDPhoto.h"
#import "XDPhoto.h"
@implementation NSString (XDPhoto)
+ (nullable NSString *)xdLocalizableString:(NSString *)key value:(NSString *)value {
    if (key == nil) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XDPhoto class]]pathForResource:@"XDPhoto"
                                                                                                   ofType:@"bundle"]];
    
    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    NSString * languStr = @"zh";
    if ([languageName hasPrefix:@"en"]) {
        languStr = @"en";
    }
    NSBundle *languBundle = [NSBundle bundleWithPath:[bundle pathForResource:languStr ofType:@"ll"]];
    
  NSString *locLanguages = [languBundle localizedStringForKey:key value:value table:@""];
    NSLog(@"%@ - %@ - %@",appLanguages,languageName,locLanguages);
    if (locLanguages.length == 0) {
        return key;
    }
    return locLanguages;
}
@end
