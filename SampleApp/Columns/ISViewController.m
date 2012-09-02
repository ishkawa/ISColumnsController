#import "ISViewController.h"

@implementation ISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super didReceiveMemoryWarning];
}

- (void)viewWillUnload
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewWillUnload];
}

- (void)viewDidUnload
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewDidUnload];
}

- (void)dealloc
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)pushViewController
{
    UIViewController *viewController = [[[UIViewController alloc] init] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
