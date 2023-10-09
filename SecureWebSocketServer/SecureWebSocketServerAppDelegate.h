#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class HTTPServer;

@interface SecureWebSocketServerAppDelegate : NSObject <NSApplicationDelegate, WKUIDelegate, WKNavigationDelegate> {
@private
	HTTPServer *httpServer;
	NSWindow *__unsafe_unretained window;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;

@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSTextField *adressTextField;

- (IBAction)homePage:(id)sender;
- (IBAction)goToPage:(id)sender;
- (IBAction)goBackPage:(id)sender;
- (IBAction)goForwardPage:(id)sender;

- (BOOL)validateUrl:(NSString*)url;
- (void)loadPage:(NSString*)url;

@end
