//
//  BrowserViewController.m
//  WebBrowser
//
//  Created by Alok on 31/05/13.
//  Copyright (c) 2013 Alok. All rights reserved.
//

#import "BrowserViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BrowserViewController ()

@end

@implementation BrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    webPageView = [[UIWebView alloc]init];
    webPageView.delegate = self;

    addressBar = [[UITextField alloc]init];
    buttonView = [[UIView alloc]init];
    buttonView.backgroundColor = [UIColor lightGrayColor];
        
    addressBar.delegate = self;
    addressBar.placeholder = @" Enter the URL";
    addressBar.backgroundColor = [UIColor grayColor];

    UIImage *backImage = [UIImage imageNamed:@"back_icon.png"];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTouchUp:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *forwardImage = [UIImage imageNamed:@"forward_icon.png"];
    forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:forwardImage forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(forwardButtonTouchUp:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *reloadImage = [UIImage imageNamed:@"reload_icon.png"];
    reloadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadbutton setImage:reloadImage forState:UIControlStateNormal];
    [reloadbutton addTarget:self action:@selector(reloadButtonTouchUp:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *stopImage = [UIImage imageNamed:@"stop_icon.gif"];
    stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopButton setImage:stopImage forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopRequest)    forControlEvents:UIControlEventTouchUpInside];

    [self viewFrames];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.autoresizingMask =(UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin);
    [activityIndicator sizeToFit];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.center = webPageView.center;
    buttonView.layer.shadowOpacity = 1.75f;
    buttonView.layer.shadowRadius = 10.0f;
    buttonView.layer.shadowColor = [UIColor blueColor].CGColor;
    forwardButton.enabled = NO;
    backButton.enabled = NO;
    [self.view addSubview:webPageView];
    [webPageView addSubview:activityIndicator];
    [self.view addSubview:addressBar];
    [self.view addSubview:buttonView];
    [buttonView addSubview:backButton];
    [buttonView addSubview:forwardButton];
    [buttonView addSubview:reloadbutton];
   
    
}

/*
 Method to set frame of views
 */
-(void)viewFrames
{
    addressBar.frame = CGRectMake(0, 0, self.view.bounds.size.width , 30);
    webPageView.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-66);
    buttonView.frame = CGRectMake(0, self.view.bounds.size.height-36, self.view.bounds.size.width, 36);
    backButton.frame = CGRectMake(20,5,30,25);
    forwardButton.frame = CGRectMake(80, 5, 30, 25);
    reloadbutton.frame = CGRectMake(buttonView.bounds.size.width-40, 5, 30, 25);
    stopButton.frame = CGRectMake(buttonView.bounds.size.width-40, 5, 30, 25);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Method to render url on webview
 */
-(void)sendRequest
{
    urlString = addressBar.text;
    urlString = [@"http://" stringByAppendingString:urlString];
    [addressBar resignFirstResponder];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webPageView loadRequest:requestObj];
}

/*
 Method to go previous page in webview
 */
- (void)backButtonTouchUp:(id)sender
{
    [webPageView goBack];    
    [self toggleBackForwardButtons];
    
     NSString *history = [webPageView stringByEvaluatingJavaScriptFromString:@"history.length"];
    NSLog(@"%@",history);
}

/*
 Method to go forward page in webview
 */
- (void)forwardButtonTouchUp:(id)sender
{
    [webPageView goForward];
    [self toggleBackForwardButtons];
}

/*
 Method to reload page in webview
 */
- (void)reloadButtonTouchUp:(id)sender
{
    [webPageView reload];
    [self toggleBackForwardButtons];
}

/*
 Method called when webview starts loading
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
    [self toggleBackForwardButtons];
    [reloadbutton removeFromSuperview];
    [buttonView addSubview:stopButton];
}

/*
 Method called when webview finishes loading
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webPageView stringByEvaluatingJavaScriptFromString:@"document.title"];
    addressBar.text = [webPageView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    [activityIndicator stopAnimating];
    [self toggleBackForwardButtons];
    [stopButton removeFromSuperview];
    [buttonView addSubview:reloadbutton];
}

/*
 Method to enable/disable back and forward button
 */
-(void) toggleBackForwardButtons
{
    backButton.enabled = webPageView.canGoBack;
    forwardButton.enabled = webPageView.canGoForward;
}

/*
 Method called when text field begins editing
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    addressBar.returnKeyType = UIReturnKeyGo;
}

/*
 Method called when go button is pressed in keyboard
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:addressBar] && UIReturnKeyGo == textField.returnKeyType)
    {
        [self sendRequest];
    }
    return  YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //To set frames of subviews
    [self viewFrames];
}

/*
 Method called on orientation change
 */
- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self viewFrames];
}

/*
 Method to stop url request
 */
-(void)stopRequest
{
    [webPageView stopLoading];
    [activityIndicator stopAnimating];
    [stopButton removeFromSuperview];
    [buttonView addSubview:reloadbutton];
}
@end