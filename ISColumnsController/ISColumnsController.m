#import "ISColumnsController.h"
#import <QuartzCore/QuartzCore.h>

@interface ISColumnsController ()

- (void)reloadChildViewControllers;
- (void)enableScrollsToTop;
- (void)disableScrollsToTop;

@end

@implementation ISColumnsController

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self) {
        [self view];
        [self addObserver:self
               forKeyPath:@"viewControllers"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.scrollView = [[[UIScrollView alloc] init] autorelease];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.scrollView];
    
    CALayer *topShadowLayer = [CALayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-10, -10, 10000, 13)];
    topShadowLayer.frame = CGRectMake(-320, 0, 10000, 20);
    topShadowLayer.masksToBounds = YES;
    topShadowLayer.shadowOffset = CGSizeMake(2.5, 2.5);
    topShadowLayer.shadowOpacity = 0.5;
    topShadowLayer.shadowPath = [path CGPath];
    [self.scrollView.layer addSublayer:topShadowLayer];

    CALayer *bottomShadowLayer = [CALayer layer];
    path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 10, 10000, 13)];
    bottomShadowLayer.frame = CGRectMake(-320, self.scrollView.frame.size.height-58, 10000, 20);
    bottomShadowLayer.masksToBounds = YES;
    bottomShadowLayer.shadowOffset = CGSizeMake(-2.5, -2.5);
    bottomShadowLayer.shadowOpacity = 0.5;
    bottomShadowLayer.shadowPath = [path CGPath];
    [self.scrollView.layer addSublayer:bottomShadowLayer];
    
    UIView *titleView = [[[UIView alloc] init] autorelease];
    titleView.frame = CGRectMake(0, 0, 150, 44);
    
    self.pageControl = [[[UIPageControl alloc] init] autorelease];
    self.pageControl.numberOfPages = 3;
    self.pageControl.frame = CGRectMake(0, 27, 150, 14);
    [titleView addSubview:self.pageControl];
    
    self.titleLabel = [[[UILabel alloc] init] autorelease];
    self.titleLabel.frame = CGRectMake(0, 7, 150, 20);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowColor = [UIColor darkGrayColor];
    [titleView addSubview:self.titleLabel];
    
    self.navigationItem.titleView = titleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup
    [self.pageControl addTarget:self action:@selector(didTapPageControl:) forControlEvents:UIControlEventValueChanged];
    
    
    // refresh
    [self reloadChildViewControllers];

}

- (void)viewDidUnload
{
    self.scrollView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"viewControllers"];
    [_viewControllers release];
    [_scrollView release];
    [_titleLabel release];
    [_pageControl release];
    
    [super dealloc];
}

#pragma mark - key value observation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"viewControllers"]) {
        [self reloadChildViewControllers];
        [self disableScrollsToTop];
    }
}

#pragma mark - page view control
- (void) goToPage:(NSUInteger )newPage{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*newPage, 0) animated:YES];
}
- (void) didTapPageControl:(id) sender{
    UIPageControl *pc = (UIPageControl *)sender;
    [self goToPage:pc.currentPage];
    
}
#pragma mark - action

- (void)reloadChildViewControllers
{
    for (UIViewController *viewController in self.childViewControllers) {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
        // remove transform
        viewController.view.transform = CGAffineTransformIdentity;
        [viewController.view removeFromSuperview];
    }
    for (UIViewController *viewController in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * index,
                                               0,
                                               self.scrollView.frame.size.width,
                                               self.scrollView.frame.size.height);
        
        [self addChildViewController:viewController];
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        if (index == self.pageControl.currentPage) {
            self.titleLabel.text = viewController.navigationItem.title;
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.viewControllers count], 1);
    // go to the right page
    [self goToPage:self.pageControl.currentPage];
    
    for (UIViewController *viewController in self.childViewControllers) {
        CALayer *layer = viewController.view.layer;
        layer.shadowOpacity = .5f;
        layer.shadowOffset = CGSizeMake(10, 10);
        layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.view.bounds].CGPath;
    }
}

- (void)enableScrollsToTop
{
    // FIXME: this code affects all scroll view
    for (UIViewController *viewController in self.viewControllers) {
        for (UIView *subview in [viewController.view subviews]) {
            if ([subview respondsToSelector:@selector(scrollsToTop)]) {
                [(UIScrollView *)subview setScrollsToTop:YES];
            }
        }
    }
}

- (void)disableScrollsToTop
{
    for (UIViewController *viewController in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        if (index != self.pageControl.currentPage) {
            for (UIView *subview in [viewController.view subviews]) {
                if ([subview respondsToSelector:@selector(scrollsToTop)]) {
                    [(UIScrollView *)subview setScrollsToTop:NO];
                }
            }
        }
    }
}

#pragma mark - current page, viewcontroller properties
- (NSUInteger ) currentPage{
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat width = self.scrollView.frame.size.width;
    NSInteger currentPage = (offset+(width/2))/width;
    return currentPage;
}

- (UIViewController <ISColumnsControllerChild> *) currentViewController{
    return [self.viewControllers objectAtIndex:self.currentPage];
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self enableScrollsToTop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.titleLabel.text = self.currentViewController.navigationItem.title;
    self.pageControl.currentPage = self.currentPage;
    [self disableScrollsToTop];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    NSUInteger currentPage = self.currentPage;
    if (currentPage != self.pageControl.currentPage && currentPage < [self.viewControllers count]) {
        // Question - do not understand why previousViewController code here is the same index as currentVieWController? JC
        UIViewController <ISColumnsControllerChild> *previousViewController = [self.viewControllers objectAtIndex:self.pageControl.currentPage];
        if ([previousViewController respondsToSelector:@selector(didResignActive)]) {
            [previousViewController didResignActive];
        }
        
        UIViewController <ISColumnsControllerChild> *currentViewController = self.currentViewController;
        if ([currentViewController respondsToSelector:@selector(didBecomeActive)]) {
            [currentViewController didBecomeActive];
        }
    }
    
    for (UIViewController *viewController in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat y = index * width;
        CGFloat value = (offset-y)/width;
        CGFloat scale = 1.f-fabs(value);
        if (scale > 1.f) scale = 1.f;
        if (scale < .8f) scale = .8f;
        
        viewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    }

    for (UIViewController *viewController in self.childViewControllers) {
        CALayer *layer = viewController.view.layer;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.view.bounds].CGPath;
    }
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self reloadChildViewControllers];
}

@end
