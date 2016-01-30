//
//  WikifSharingActivity.h
//  Wikify
//
//  Created by Alex Nazaroff on 30.01.16.
//  Copyright © 2016 Ololo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kWKFavoritesActivityDidFinishNotification;

@interface WikifyAddToFavoritesActivity : UIActivity
@property (nonatomic, copy) NSString *URLString;
@end