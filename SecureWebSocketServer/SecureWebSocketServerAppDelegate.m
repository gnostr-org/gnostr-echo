#import "SecureWebSocketServerAppDelegate.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;


@implementation SecureWebSocketServerAppDelegate

@synthesize window;




- (void)awakeFromNib
{
    [self homePage:self];
}

#pragma mark Action methods

- (IBAction)homePage:(id)sender
{
    [self loadPage:@"https://localhost:12345"];
}

- (IBAction)goToPage:(id)sender
{
    NSString * url = [NSString stringWithFormat:@"%@%@", @"https://", [_adressTextField stringValue]];
    
    if (![self validateUrl:url])
    {
        return;
    }
    
    [self loadPage:url];
}

- (IBAction)goBackPage:(id)sender
{
    if (![_webView canGoBack])
    {
        return;
    }
    
    [_webView goBack];
}

- (IBAction)goForwardPage:(id)sender
{
    if (![_webView canGoForward])
    {
        return;
    }
    
    [_webView goForward];
}

#pragma mark Helper methods

- (BOOL)validateUrl:(NSString*)url;
{
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}

- (void)loadPage:(NSString*)url
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}











- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	// Create server using our custom MyHTTPServer class
	httpServer = [[HTTPServer alloc] init];
	
	// Tell server to use our custom MyHTTPConnection class.
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[httpServer setType:@"_http._tcp."];
	
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
	   [httpServer setPort:12345];
	
	// Serve files from our embedded Web folder
	NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
	DDLogInfo(@"Setting document root: %@", webPath);
	
	[httpServer setDocumentRoot:webPath];
	
	// Start the server (and check for problems)
	
	NSError *error;
	if(![httpServer start:&error])
	{
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
}

@end
