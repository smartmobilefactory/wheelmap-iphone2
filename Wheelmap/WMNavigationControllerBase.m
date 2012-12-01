//
//  WMNavigationControllerBaseViewController.m
//  Wheelmap
//
//  Created by Dorian Roy on 07.11.12.
//  Copyright (c) 2012 Sozialhelden e.V. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "WMNavigationControllerBase.h"
#import "WMDataManager.h"
#import "WMDetailViewController.h"
#import "Node.h"


@implementation WMNavigationControllerBase
{
    NSArray *nodes;
    WMDataManager *dataManager;
    CLLocationManager *locationManager;
    
    WMWheelChairStatusFilterPopoverView* wheelChairFilterPopover;
    WMCateogryFilterPopoverView* categporyFilterPopover;
    
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    dataManager = [[WMDataManager alloc] init];
    dataManager.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 50.0f;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // hide standard navigation bar
    self.navigationBar.hidden = YES;
    
    // configure initial vc from storyboard
    if ([self.topViewController conformsToProtocol:@protocol(WMNodeListView)]) {
        id<WMNodeListView> initialNodeListView = (id<WMNodeListView>)self.topViewController;
        initialNodeListView.dataSource = self;
        initialNodeListView.delegate = self;
    }
    
    
    
    // set custom nagivation and tool bars
    self.customNavigationBar = [[WMNavigationBar alloc] initWithSize:CGSizeMake(self.view.frame.size.width, 50)];
    self.customNavigationBar.delegate = self;
    [self.view addSubview:self.customNavigationBar];
    
    self.customToolBar = [[WMToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-62, self.view.frame.size.width, 62)];
    self.customToolBar.delegate = self;
    [self.view addSubview:self.customToolBar];
    
    // set filter popovers.
    wheelChairFilterPopover = [[WMWheelChairStatusFilterPopoverView alloc] initWithOrigin:CGPointMake(self.customToolBar.middlePointOfWheelchairFilterButton-170, self.customToolBar.frame.origin.y-60)];
    wheelChairFilterPopover.hidden = YES;
    wheelChairFilterPopover.delegate = self;
    [self.view addSubview:wheelChairFilterPopover];
    
    categporyFilterPopover = [[WMCateogryFilterPopoverView alloc] initWithRefPoint:CGPointMake(self.customToolBar.middlePointOfCategoryFilterButton, self.customToolBar.frame.origin.y)];
    categporyFilterPopover.hidden = YES;
    [self.view addSubview:categporyFilterPopover];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; // TODO: prevent upside down on iphone
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Data Manager Delegate

- (void) dataManager:(WMDataManager *)dataManager didReceiveNodes:(NSArray *)nodesParam
{
    nodes = nodesParam;
    
    [self refreshNodeList];
}

- (void) refreshNodeList
{
    if ([self.topViewController conformsToProtocol:@protocol(WMNodeListView)]) {
        [(id<WMNodeListView>)self.topViewController nodeListDidChange];
    }
}

-(void)dataManager:(WMDataManager *)dataManager fetchNodesFailedWithError:(NSError *)error
{
    NSLog(@"error %@", error.localizedDescription);
}

- (void)dataManagerDidFinishSyncingResources:(WMDataManager *)dataManager
{
    NSLog(@"dataManagerDidFinishSyncingResources");
}

-(void)dataManager:(WMDataManager *)dataManager syncResourcesFailedWithError:(NSError *)error
{
    NSLog(@"syncResourcesFailedWithError");
}


#pragma mark - Node List Data Source

- (NSArray*) nodeList
{
    return nodes;
}


#pragma mark - Node List Delegate

/**
 * Called only on the iPhone
 */
- (void)nodeListView:(id<WMNodeListView>)nodeListView didSelectNode:(Node *)node
{
    // we don"t want to push a detail view when selecting a node on the map view, so
    // we check if this message comes from a table view
    if (node && [nodeListView isKindOfClass:[UITableViewController class]]) {
        [self pushDetailsViewControllerForNode:node];
    }
}

/**
 * Called only on the iPhone
 */
- (void) nodeListView:(id<WMNodeListView>)nodeListView didSelectDetailsForNode:(Node *)node
{
    if (node) {
        [self pushDetailsViewControllerForNode:node];
    }
}

- (void) pushDetailsViewControllerForNode:(Node*)node
{
    WMDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"WMDetailView" bundle:nil] instantiateInitialViewController];
    detailViewController.node = node;
    [self pushViewController:detailViewController animated:YES];
}


#pragma mark - Location Manager Delegate

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Loc Error Title", @"")
                                                        message:NSLocalizedString(@"No Loc Error Message", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
	[alertView show];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [dataManager fetchNodesNear:newLocation.coordinate];
}


#pragma mark - Application Notifications

- (void) applicationDidBecomeActive:(NSNotification*)notification
{
    if (locationManager) {
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)applicationWillResignActive:(NSNotification*)notification
{
	[locationManager stopUpdatingLocation];
}

#pragma mark - Push/Pop ViewControllers
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController conformsToProtocol:@protocol(WMNodeListView)]) {
        id<WMNodeListView> nodeListViewController = (id<WMNodeListView>)viewController;
        nodeListViewController.dataSource = self;
        nodeListViewController.delegate = self;
    }
    
    [super pushViewController:viewController animated:animated];
    [self changeScreenStatusFor:viewController];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* lastViewController = [super popViewControllerAnimated:animated];
    [self changeScreenStatusFor:[self.viewControllers lastObject]];
    
    return lastViewController;
}

-(NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray* lastViewControllers = [super popToRootViewControllerAnimated:animated];
    [self changeScreenStatusFor:[self.viewControllers lastObject]];
    
    return lastViewControllers;
}

-(NSArray*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray* lastViewControllers = [super popToViewController:viewController animated:animated];
    [self changeScreenStatusFor:[self.viewControllers lastObject]];
    
    return lastViewControllers;
}

-(void)changeScreenStatusFor:(UIViewController*)vc
{
    // show/hide navigation bar. only hide it on the dashboard!
    [self.customNavigationBar showNavigationBar];
    
    // if the current navigation stack size is 2,then we always show DashboardButton on the left
    WMNavigationBarLeftButtonStyle leftButtonStyle;
    WMNavigationBarRightButtonStyle rightButtonStyle;
    NSString* navigationTitle = nil;
    
    if (self.viewControllers.count == 1) {  // THIS SHOULD BE CHANGED AFTER IMPLEMENTING DASHBOARD!
        leftButtonStyle = kWMNavigationBarLeftButtonStyleDashboardButton;
    } else {
        // otherwise, default left button is BackButton. This will be changed according to the current screen later
        leftButtonStyle = kWMNavigationBarLeftButtonStyleBackButton;
        
    }
    
    // special left buttons and right button should be set according to the current screen
    
    if ([vc isKindOfClass:[WMMapViewController class]]) {
        if (self.viewControllers.count == 2) {
            leftButtonStyle = kWMNavigationBarLeftButtonStyleDashboardButton;   // single exception. this is the first level!
            navigationTitle = @"Orte in deiner Nähe";
        }
        rightButtonStyle = kWMNavigationBarRightButtonStyleContributeButton;
        [self.customToolBar showToolbar];
    } else if ([vc isKindOfClass:[WMNodeListViewController class]]) {
        if (self.viewControllers.count == 1) {
            navigationTitle = @"Orte in deiner Nähe";
        }
        rightButtonStyle = kWMNavigationBarRightButtonStyleContributeButton;
        [self.customToolBar showToolbar];
    } else if ([vc isKindOfClass:[WMDetailViewController class]]) {
        rightButtonStyle = kWMNavigationBarRightButtonStyleEditButton;
        navigationTitle = @"Details";
        [self hidePopover:wheelChairFilterPopover];
        [self hidePopover:categporyFilterPopover];
        [self.customToolBar hideToolbar];
        
    } else if ([vc isKindOfClass:[WMWheelchairStatusViewController class]]) {
        rightButtonStyle = kWMNavigationBarRightButtonStyleSaveButton;
        leftButtonStyle = kWMNavigationBarLeftButtonStyleCancelButton;
        navigationTitle = @"Bearbeiten";
        [self hidePopover:wheelChairFilterPopover];
        [self hidePopover:categporyFilterPopover];
        [self.customToolBar hideToolbar];
    }
    
    self.customNavigationBar.leftButtonStyle = leftButtonStyle;
    self.customNavigationBar.rightButtonStyle = rightButtonStyle;
    self.customNavigationBar.title = navigationTitle;
}

#pragma mark - WMNavigationBar Delegate
-(void)pressedDashboardButton:(WMNavigationBar *)navigationBar
{
    // In the future, the dashboard would be the root VC.
    [self popToRootViewControllerAnimated:YES];
}

-(void)pressedBackButton:(WMNavigationBar *)navigationBar
{
    [self popViewControllerAnimated:YES];
    
}

-(void)pressedCancelButton:(WMNavigationBar *)navigationBar
{
    [self popViewControllerAnimated:YES];
    
}

-(void)pressedContributeButton:(WMNavigationBar *)navigationBar
{
    NSLog(@"[NavigationControllerBase] pressed contribute button!");
}

-(void)pressedEditButton:(WMNavigationBar *)navigationBar
{
    NSLog(@"[NavigationControllerBase] pressed edit button!");
}

-(void)pressedSaveButton:(WMNavigationBar *)navigationBar
{
    NSLog(@"[NavigationControllerBase] pressed save button!");
}
#pragma mark - WMToolBar Delegate
-(void)pressedToggleButton:(WMButton *)sender
{
    if ([self.topViewController isKindOfClass:[WMNodeListViewController class]]) {
        //  the node list view is on the screen. push the map view controller
        WMMapViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WMMapViewController"];
        [self pushViewController:vc animated:YES];
        
    } else if ([self.topViewController isKindOfClass:[WMMapViewController class]]) {
        //  the map view is on the screen. pop the map view controller
        [self popViewControllerAnimated:YES];
    }
    
}

-(void)pressedCurrentLocationButton:(WMToolBar *)toolBar
{
    NSLog(@"[ToolBar] update current location button is pressed!");
    
}
-(void)pressedSearchButton:(WMToolBar *)toolBar
{
    NSLog(@"[ToolBar] global search button is pressed!");
}

-(void)pressedWheelChairStatusFilterButton:(WMToolBar *)toolBar
{
    NSLog(@"[ToolBar] wheelchair status filter buttton is pressed!");
    if (!categporyFilterPopover.hidden) {
        [self hidePopover:categporyFilterPopover];
    }
    
    if (wheelChairFilterPopover.hidden) {
        [self showPopover:wheelChairFilterPopover];
    } else {
        [self hidePopover:wheelChairFilterPopover];
    }
}

-(void)pressedCategoryFilterButton:(WMToolBar *)toolBar
{
    NSLog(@"[ToolBar] category filter button is pressed!");
    
    if (!wheelChairFilterPopover.hidden) {
        [self hidePopover:wheelChairFilterPopover];
    }
    
    if (categporyFilterPopover.hidden) {
        [self showPopover:categporyFilterPopover];
    } else {
        [self hidePopover:categporyFilterPopover];
    }
}

#pragma mark - Popover Management
-(void)showPopover:(UIView*)popover
{
    if (popover.hidden == NO)
        return;
    
    popover.alpha = 0.0;
    popover.transform = CGAffineTransformMakeTranslation(0, 10);
    popover.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         popover.alpha = 1.0;
         popover.transform = CGAffineTransformMakeTranslation(0, 0);
     }
                     completion:^(BOOL finished)
     {
         
     }
     ];
}

-(void)hidePopover:(UIView*)popover
{
    if (popover.hidden == YES)
        return;
    
    popover.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         popover.alpha = 0.0;
         popover.transform = CGAffineTransformMakeTranslation(0, 10);
     }
                     completion:^(BOOL finished)
     {
         popover.hidden = YES;
         popover.transform = CGAffineTransformMakeTranslation(0, 0);
         
     }
     ];
}

#pragma mark - WMWheelchairStatusFilter Delegate
-(void)pressedButtonOfDotType:(DotType)type selected:(BOOL)selected
{
    switch (type) {
        case kDotTypeGreen:
            self.customToolBar.wheelChairStatusFilterButton.selectedGreenDot = selected;
            break;
            
        case kDotTypeYellow:
            self.customToolBar.wheelChairStatusFilterButton.selectedYellowDot = selected;
            break;
            
        case kDotTypeRed:
            self.customToolBar.wheelChairStatusFilterButton.selectedRedDot = selected;
            break;
            
        case kDotTypeNone:
            self.customToolBar.wheelChairStatusFilterButton.selectedNoneDot = selected;
            break;
            
        default:
            break;
    }
}
@end




