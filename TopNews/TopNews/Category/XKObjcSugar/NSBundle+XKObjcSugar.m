//
//  NSBundle+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSBundle+XKObjcSugar.h"
#import "CNFeedbackViewController.h"


@implementation NSBundle (XKObjcSugar)

+ (NSString *)xk_currentVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (UIImage *)xk_launchImage {
    
    NSArray *launchImages = [NSBundle mainBundle].infoDictionary[@"UILaunchImages"];
    
    NSString *sizeString = NSStringFromCGSize([UIScreen mainScreen].bounds.size);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UILaunchImageOrientation = 'Portrait' AND UILaunchImageSize = %@", sizeString];
    NSArray *result = [launchImages filteredArrayUsingPredicate:predicate];
    
    NSString *imageName = result.lastObject[@"UILaunchImageName"];
    
    return [UIImage imageNamed:imageName];
}
+ (NSBundle *)feedbackBundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        NSBundle *classBundle = [NSBundle bundleForClass:[CNFeedbackViewController class]];
        NSURL *bundleURL = [classBundle URLForResource:@"CNFeedback" withExtension:@"bundle"];
        
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        } else {
            bundle = [NSBundle mainBundle];
        }
    });
    
    return bundle;
}
@end
