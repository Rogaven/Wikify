//
//  ViewController.m
//  Wikify
//
//  Created by Alex Nazaroff on 30.01.16.
//  Copyright © 2016 Ololo. All rights reserved.
//

#import "ViewController.h"
#import "WikifyAddToFavoritesActivity.h"

static NSString * const kWKAPIRandomArticleURL = @"https://en.wikipedia.org/wiki/Special:Random";
static NSString * const kWKConfigsFavsKey = @"favs";

@interface ViewController () <UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSMutableSet<NSString *> *favoriteURLs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.favoriteURLs = [self loadStoredFavs];
    
    [self loadRandomArticle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addURLToFavourites:)
                                                 name:kWKFavoritesActivityDidFinishNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self storeFavs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)loadRandomArticle {
    NSURL *url = [NSURL URLWithString:kWKAPIRandomArticleURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
 
    [self showLoadingActivity];
}

#pragma mark - Fav

- (IBAction)shareCurrentArticle {
    NSURL *urlItem = self.webView.request.URL;
    if (urlItem) {
        WikifyAddToFavoritesActivity *favItem = [[WikifyAddToFavoritesActivity alloc] init];
        favItem.URLString = urlItem.absoluteString;
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[urlItem]
                                                                                         applicationActivities:@[favItem]];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];

            [popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                                      animated:YES];
        } else {
            [self presentViewController:activityController animated:YES completion:nil];
        }
        
    }
}

- (NSMutableSet<NSString *> *)loadStoredFavs {
    NSSet *set = [[NSUserDefaults standardUserDefaults] objectForKey:kWKConfigsFavsKey] ?: [NSSet set];
    return [set mutableCopy];
}

- (void)storeFavs {
    [[NSUserDefaults standardUserDefaults] setObject:self.favoriteURLs forKey:kWKConfigsFavsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addURLToFavourites:(NSNotification *)note {
    [self.favoriteURLs addObject:note.object];
}

#pragma mark - Loading

- (void)showLoadingActivity {
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.color = [UIButton new].tintColor;
    [activity startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)hideLoadingActivity {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          target:self
                                                                                          action:@selector(loadRandomArticle)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - WebView

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoadingActivity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingActivity];
}

@end
