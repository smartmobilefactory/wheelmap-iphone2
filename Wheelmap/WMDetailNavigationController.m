//
//  WMDetailNavigationController.m
//  Wheelmap
//
//  Created by Michael Thomas on 23.01.13.
//  Copyright (c) 2013 Sozialhelden e.V. All rights reserved.
//

#import "WMDetailNavigationController.h"
#import "WMDetailViewController.h"
#import "WMEditPOIViewController.h"
#import "WMLoginViewController.h"
#import "WMWheelchairStatusViewController.h"
#import "WMCommentViewController.h"
#import "WMRootViewController_iPad.h"
#import "WMNodeListViewController.h"

@interface WMDetailNavigationController ()

@end

@implementation WMDetailNavigationController {
    WMDataManager *dataManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dataManager = [[WMDataManager alloc] init];
        
        // set custom nagivation and tool bars
        self.navigationBar.frame = CGRectMake(0, self.navigationBar.frame.origin.y, self.view.frame.size.width, 50);
        
        self.customNavigationBar = [[WMNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationBar.frame.size.width, 50)];
        [self.customNavigationBar adjustButtonsToPopoverPresentation];
        self.customNavigationBar.delegate = self;
        [self.navigationBar addSubview:self.customNavigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pressedBackButton:(WMNavigationBar*)navigationBar {
    [self popViewControllerAnimated:YES];
}
-(void)pressedDashboardButton:(WMNavigationBar*)navigationBar {}

-(void)pressedEditButton:(WMNavigationBar*)navigationBar {
    if (![dataManager userIsAuthenticated]) {
        [self presentLoginScreenWithButtonFrame:CGRectZero];
        return;
    }
    
    if ([self.topViewController isKindOfClass:[WMDetailViewController class]]) {
        
        WMEditPOIViewController* vc = [[UIStoryboard storyboardWithName:@"WMDetailView" bundle:nil] instantiateViewControllerWithIdentifier:@"WMEditPOIViewController"];
        vc.node = ((WMDetailViewController *)self.topViewController).node;
        vc.editView = YES;
        vc.title = self.title = NSLocalizedString(@"EditPOIViewHeadline", @"");
        [self pushViewController:vc animated:YES];
    } else {
        NSLog(@"ERROR! Pushing Edit screen from sth different than Detail screen");
    }
}

-(void)pressedCancelButton:(WMNavigationBar*)navigationBar {
    [self popViewControllerAnimated:YES];
}

-(void)pressedSaveButton:(WMNavigationBar*)navigationBar {
    WMViewController* currentViewController = [self.viewControllers lastObject];
    if ([currentViewController isKindOfClass:[WMWheelchairStatusViewController class]]) {
        [(WMWheelchairStatusViewController*)currentViewController saveAccessStatus];
    }
    if ([currentViewController isKindOfClass:[WMEditPOIViewController class]]) {
        [(WMEditPOIViewController*)currentViewController saveEditedData];
    }
    if ([currentViewController isKindOfClass:[WMCommentViewController class]]) {
        [(WMCommentViewController*)currentViewController saveEditedData];
    }
}

-(void)pressedContributeButton:(WMNavigationBar*)navigationBar {}
-(void)pressedSearchCancelButton:(WMNavigationBar *)navigationBar {}
-(void)pressedSearchButton:(BOOL)selected {}

-(void)searchStringIsGiven:(NSString*)query {}

-(void)presentLoginScreenWithButtonFrame:(CGRect)frame;
{
    WMLoginViewController* vc = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"WMLoginViewController"];
    vc.popoverButtonFrame = frame;
    [self pushViewController:vc animated:YES];
}

#pragma mark - NavigationController stack

- (void)changeScreenStatusFor:(UIViewController *)viewController {
        
    if ([viewController isKindOfClass:[WMDetailViewController class]]) {
        self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleNone;
        self.customNavigationBar.rightButtonStyle = kWMNavigationBarRightButtonStyleEditButton;
    } else if ([viewController isKindOfClass:[WMEditPOIViewController class]]) {
        if ([self.viewControllers count] < 1) {
            self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleNone;
        } else {
            self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleBackButton;
        }
        self.customNavigationBar.rightButtonStyle = kWMNavigationBarRightButtonStyleSaveButton;
    } else if ([viewController isKindOfClass:[WMLoginViewController class]]) {
        self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleNone;
        self.customNavigationBar.rightButtonStyle = kWMNavigationBarRightButtonStyleCancelButton;
    } else if ([viewController isKindOfClass:[WMCommentViewController class]]) {
        self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleBackButton;
        self.customNavigationBar.rightButtonStyle = kWMNavigationBarRightButtonStyleSaveButton;
    } else if ([viewController isKindOfClass:[WMWheelchairStatusViewController class]]) {
        self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleBackButton;
        self.customNavigationBar.rightButtonStyle = kWMNavigationBarRightButtonStyleSaveButton;
    } else {
        self.customNavigationBar.leftButtonStyle = kWMNavigationBarLeftButtonStyleBackButton;
        self.customNavigationBar.rightButtonStyle = kWMNavigationBarRightButtonStyleNone;
    }

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self changeScreenStatusFor:viewController];
    
    [super pushViewController:viewController animated:animated];
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

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    [self changeScreenStatusFor:[viewControllers lastObject]];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self dismissModalViewControllerAnimated:NO];
        if ([modalViewController isKindOfClass:[WMLoginViewController class]]) {
            ((WMLoginViewController *)modalViewController).popover = [[UIPopoverController alloc]
                                                                 initWithContentViewController:modalViewController];
            ((WMLoginViewController *)modalViewController).baseController = self;
            [((WMLoginViewController *)modalViewController).popover presentPopoverFromRect:((WMLoginViewController *)modalViewController).popoverButtonFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
        }
    } else {
        [super presentModalViewController:modalViewController animated:animated];
    }
}

- (void) showLoadingWheel {
    [self.listViewController.controllerBase showLoadingWheel];
}

- (void)hideLoadingWheel {
    [self.listViewController.controllerBase hideLoadingWheel];
}

@end
