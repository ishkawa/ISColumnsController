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
    self.columnsController.navigationItem.leftBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithTitle:@"PushNext"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(pushNextViewController)] autorelease];
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
    ISViewController *redViewController = [[[ISViewController alloc] init] autorelease];
    redViewController.view.backgroundColor = [UIColor redColor];
    redViewController.navigationItem.title = @"Red";
    
    ISViewController *greenViewController = [[[ISViewController alloc] init] autorelease];
    greenViewController.view.backgroundColor = [UIColor greenColor];
    greenViewController.navigationItem.title = @"Green";
    
    ISViewController *blueViewController = [[[ISViewController alloc] init] autorelease];
    blueViewController.view.backgroundColor = [UIColor blueColor];
    blueViewController.navigationItem.title = @"Blue";
    
    self.columnsController.viewControllers = [NSArray arrayWithObjects:
                                              redViewController,
                                              greenViewController,
                                              blueViewController, nil];
}

- (void)pushNextViewController
{
    UIViewController *viewController = [[[UIViewController alloc] init] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
