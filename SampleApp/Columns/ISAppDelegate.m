#import "ISAppDelegate.h"
#import "ISViewController.h"
#import "ISColumnsController.h"

@implementation ISAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize columnsController = _columnsController;

- (void)dealloc
{
    [_window release], _window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.columnsController = [[[ISColumnsController alloc] init] autorelease];
    self.columnsController.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Reload"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(reloadViewControllers)] autorelease];
    [self reloadViewControllers];
    
    self.navigationController = [[[UINavigationController alloc] init] autorelease];
    self.navigationController.viewControllers = [NSArray arrayWithObject:self.columnsController];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)reloadViewControllers
{
    ISViewController *viewController1 = [[[ISViewController alloc] init] autorelease];
    viewController1.navigationItem.title = @"ViewController 1";
    
    ISViewController *viewController2 = [[[ISViewController alloc] init] autorelease];
    viewController2.navigationItem.title = @"ViewController 2";
    
    ISViewController *viewController3 = [[[ISViewController alloc] init] autorelease];
    viewController3.navigationItem.title = @"ViewController 3";
    
    self.columnsController.viewControllers = [NSArray arrayWithObjects:
                                              viewController1,
                                              viewController2,
                                              viewController3, nil];
}

@end
