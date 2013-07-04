//
//  BrowserViewController.h
//  WebBrowser
//
//  Created by Alok on 31/05/13.
//  Copyright (c) 2013 Alok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>
{
    UIWebView *webPageView;
    UITextField *addressBar;
    NSString *urlString;
    UIButton *backButton;
    UIButton *forwardButton;
    UIButton *reloadbutton;
    UIButton *stopButton;
    UIActivityIndicatorView *activityIndicator;
    UIView *buttonView;
}

@end