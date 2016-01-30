//
//  WikifSharingActivity.m
//  Wikify
//
//  Created by Alex Nazaroff on 30.01.16.
//  Copyright © 2016 Ololo. All rights reserved.
//

#import "WikifyAddToFavoritesActivity.h"

NSString * const kWKFavoritesActivityDidFinishNotification = @"kWKFavoritesActivityDidFinishNotification";

static NSString * const kWKActivityType = @"com.org.wikify.Fav";

@implementation WikifyAddToFavoritesActivity

- (NSString *)activityType {
    return kWKActivityType;
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Add to Favourites", @"Title of Favorites button");
}

- (UIImage *)activityImage {
//    // Note: These images need to have a transparent background and I recommend these sizes:
//    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
//    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController {
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWKFavoritesActivityDidFinishNotification object:self.URLString];
    [self activityDidFinish:YES];
}

@end