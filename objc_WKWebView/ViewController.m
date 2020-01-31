#import "ViewController.h"
#import "YDNavDel.h"
#import "YDUIDel.h"

@interface WKViewController ()

@property (nonatomic) WKWebView *webView;
@property (nonatomic) YDNavDel *customNavDel;
@property (nonatomic) YDUIDel *customUIDel;
@end

@implementation WKViewController

NSString static *RequestURL = @"https://www.apple.com/";

#pragma mark - LifeCycle Methods
- (void)viewDidLoad {
    NSLog(@"🍭viewDidLoad");
    [super viewDidLoad];
    [self setURL: RequestURL];
}

- (IBAction)refresh:(id)sender {
    NSLog(@"🍭refresh");
    [self.webView reload];
}

-(void)loadView{

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *prefs = [[WKPreferences alloc] init];
    WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
    config.websiteDataStore = dataStore;
    config.preferences = prefs;
    
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: config];

    self.webView.allowsBackForwardNavigationGestures = YES;

    self.customNavDel = [[YDNavDel alloc] init];
    self.customUIDel = [[YDUIDel alloc] init];
    
    self.webView.navigationDelegate = self.customNavDel;
    self.webView.UIDelegate = self.customUIDel;
    
    if([self.webView.navigationDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        NSLog(@"🍭navigationDelegate setup");
    }
    
    self.view = self.webView;


    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
}

#pragma mark - Private Methods

- (void)setURL:(NSString *)requestURLString {
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 5];
    [self.webView loadRequest: request];
}

@end
