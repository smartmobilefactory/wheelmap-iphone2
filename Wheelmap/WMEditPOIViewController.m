//
//  WMEditPOIViewController.m
//  Wheelmap
//
//  Created by Andrea Gerlach on 04.12.12.
//  Copyright (c) 2012 Sozialhelden e.V. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WMEditPOIViewController.h"
#import "WMWheelchairStatusViewController.h"
#import "WMDetailViewController.h"
#import "WMSetMarkerViewController.h"
#import "NodeType.h"
#import "WMCategoryTableViewController.h"
#import "WMNodeTypeTableViewController.h"
#import "WMDataManagerDelegate.h"
#import "WMCategory.h"
#import "Node.h"
#import "NodeType.h"
#import "WMRootViewController_iPad.h"
#import "WMDetailNavigationController.h"

@interface WMEditPOIViewController ()

@end

@implementation WMEditPOIViewController {
    
    BOOL hasCoordinate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.scrollsToTop = YES;

    self.scrollView.backgroundColor = [UIColor wmGreyColor];
    
    self.dataManager = [[WMDataManager alloc] init];
    self.dataManager.useForTemporaryObjects = !self.editView;
    self.dataManager.delegate = self;
    
	// Do any additional setup after loading the view.
    self.currentCategory = self.node.node_type.category;
    self.currentNodeType = self.node.node_type;
    self.currentWheelchairStatus = self.node.wheelchair;
    self.nameTextField.delegate = self;
    self.infoTextView.delegate = self;
    self.streetTextField.delegate = self;
    self.housenumberTextField.delegate = self;
    self.postcodeTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.websiteTextField.delegate = self;
    self.phoneTextField.delegate = self;
	self.infoPlaceholderTextView.placeholder = NSLocalizedString(@"DetailsView4ButtonViewInfoLabel", @"");
    self.streetTextField.placeholder = NSLocalizedString(@"EditPOIViewStreet", @"");
    self.streetTextField.placeholder = NSLocalizedString(@"EditPOIViewHousenumber", @"");
    self.streetTextField.placeholder = NSLocalizedString(@"EditPOIViewPostcode", @"");
    self.streetTextField.placeholder = NSLocalizedString(@"EditPOIViewCity", @"");
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    
    // WHEEL ACCESS
    self.wheelAccessButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.wheelAccessButton.titleLabel.textColor = [UIColor whiteColor];
    [self.wheelAccessButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.wheelAccessButton setContentEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    
    self.nameLabel.text = NSLocalizedString(@"EditPOIViewNameLabel", @"");
    self.nodeTypeLabel.text = NSLocalizedString(@"EditPOIViewNodeTypeLabel", @"");
    self.categoryLabel.text = NSLocalizedString(@"EditPOIViewCategoryLabel", @"");
    self.infoLabel.text = NSLocalizedString(@"DetailsView4ButtonViewInfoLabel", @"");
    self.addressLabel.text = NSLocalizedString(@"EditPOIViewAddressLabel", @"");
    self.websiteLabel.text = NSLocalizedString(@"EditPOIViewWebsiteLabel", @"");
    self.phoneLabel.text = NSLocalizedString(@"EditPOIViewPhoneLabel", @"");
    
    self.streetTextField.placeholder = NSLocalizedString(@"Street Placeholder", nil);
    self.housenumberTextField.placeholder = NSLocalizedString(@"Housenumber Placeholder", nil);
    self.postcodeTextField.placeholder = NSLocalizedString(@"Postcode Placeholder", nil);
    self.cityTextField.placeholder = NSLocalizedString(@"City Placeholder", nil);
    
    if (self.editView) {
        hasCoordinate = YES;
        [self.setMarkerButton setTitle:NSLocalizedString(@"EditPOIViewSetMarkerButtonDisabled", @"") forState:UIControlStateNormal];
        self.setMarkerButton.enabled = NO;
    } else {
        self.node = [self.dataManager createNode];
        hasCoordinate = NO;
        [self.setMarkerButton setTitle:NSLocalizedString(@"EditPOIViewSetMarkerButton", @"") forState:UIControlStateNormal];
        [self.setMarkerButton addTarget:self action:@selector(pushToSetMarkerView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setWheelAccessButton];
    
    
    [self styleInputView:self.nameInputView];
    [self styleInputView:self.nodeTypeInputView];
    [self styleInputView:self.categoryInputView];
    [self styleInputView:self.positionInputView];
    [self styleInputView:self.infoInputView];
    [self styleInputView:self.addressInputView];
    [self styleInputView:self.websiteInputView];
    [self styleInputView:self.phoneInputView];

    // progress wheel
    progressWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    progressWheel.frame = CGRectMake(0, 0, 50, 50);
    progressWheel.backgroundColor = [UIColor blackColor];
    progressWheel.center = CGPointMake(self.view.center.x, self.view.center.y-40);
    progressWheel.hidden = YES;
    progressWheel.layer.cornerRadius = 5.0;
    progressWheel.layer.masksToBounds = YES;
    [self.view addSubview:progressWheel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"NavBarTitleEdit", nil);
    self.navigationBarTitle = self.title;
    
    [(WMDetailNavigationController *)self.navigationController changeScreenStatusFor:self];

    [self updateFields];

	// Update the scroll view constrians
	self.scrollViewContentWidthConstraint.constant = self.view.frame.size.width;
	self.scrollViewContentHeightConstraint.constant = self.phoneInputView.frame.origin.y + self.phoneInputView.frame.size.height + self.phoneInputViewBottomConstraint.constant;
	[self.scrollView layoutIfNeeded];
}

- (void) updateFields {
    self.nameTextField.text = self.node.name;
    [self.setNodeTypeButton setTitle:self.currentNodeType.localized_name forState:UIControlStateNormal];
    [self.setCategoryButton setTitle:self.currentCategory.localized_name forState:UIControlStateNormal];
    [self setWheelAccessButton];
    self.infoTextView.text = self.node.wheelchair_description;
	// Show the infoTextView if no info is set.
	self.infoPlaceholderTextView.hidden = !(self.infoTextView.text == nil || self.infoTextView.text.length == 0);
    self.streetTextField.text = self.node.street;
    self.housenumberTextField.text = self.node.housenumber;
    self.postcodeTextField.text = self.node.postcode;
    self.cityTextField.text = self.node.city;
    self.websiteTextField.text = self.node.website;
    self.phoneTextField.text = self.node.phone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    
    [self setSetCategoryButton:nil];
    [self setNodeTypeInputView:nil];
    [self setNodeTypeLabel:nil];
    [self setSetNodeTypeButton:nil];
    [super viewDidUnload];
    [self setScrollView:nil];
    [self setNameInputView:nil];
    [self setCategoryInputView:nil];
    [self setPositionInputView:nil];
    [self setInfoInputView:nil];
    [self setAddressInputView:nil];
    [self setAddressInputView:nil];
    [self setWebsiteInputView:nil];
    [self setWebsiteInputView:nil];
    [self setPhoneInputView:nil];
    [self setWheelAccessButton:nil];
    [self setNameTextField:nil];
    [self setWebsiteTextField:nil];
    [self setPhoneTextField:nil];
    [self setNameLabel:nil];
    [self setCategoryLabel:nil];
    [self setPosition:nil];
    [self setInfoLabel:nil];
    [self setWebsiteLabel:nil];
    [self setPhoneLabel:nil];
    [self setAddressLabel:nil];
    [self setStreetTextField:nil];
    [self setHousenumberTextField:nil];
    [self setPostcodeTextField:nil];
    [self setCityTextField:nil];
    [self setSetMarkerButton:nil];
    [self setInfoTextView:nil];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)setWheelAccessButton {
    
    if ([self.currentWheelchairStatus isEqualToString:K_WHEELCHAIR_STATE_YES]) {
        self.accessImage = [UIImage imageNamed:@"details_btn-status-yes.png"];
        self.wheelchairAccess = NSLocalizedString(@"WheelchairAccessYes", @"");
    } else if ([self.currentWheelchairStatus isEqualToString:K_WHEELCHAIR_STATE_NO]) {
        self.accessImage = [UIImage imageNamed:@"details_btn-status-no.png"];
        self.wheelchairAccess = NSLocalizedString(@"WheelchairAccessNo", @"");
    } else if ([self.currentWheelchairStatus isEqualToString:K_WHEELCHAIR_STATE_LIMITED]) {
        self.accessImage = [UIImage imageNamed:@"details_btn-status-limited.png"];
        self.wheelchairAccess = NSLocalizedString(@"WheelchairAccessLimited", @"");
    } else if ([self.currentWheelchairStatus isEqualToString:K_WHEELCHAIR_STATE_UNKNOWN]) {
        self.accessImage = [UIImage imageNamed:@"details_btn-status-unknown.png"];
        self.wheelchairAccess = NSLocalizedString(@"WheelchairAccessUnknown", @"");
    } else {
        self.accessImage = [UIImage imageNamed:@"details_btn-status-unknown.png"];
        self.wheelchairAccess = NSLocalizedString(@"WheelchairAccessUnknown", @"");
    }
    
    [self.wheelAccessButton setBackgroundImage: self.accessImage forState: UIControlStateNormal];
    [self.wheelAccessButton setTitle:self.wheelchairAccess forState:UIControlStateNormal];
    [self.wheelAccessButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    
}

- (void) styleInputView: (UIView*) inputView {
    [inputView.layer setCornerRadius:5.0f];
    [inputView.layer setMasksToBounds:YES];
    inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    inputView.layer.borderWidth = 1.0f;
    
}


- (void)accessButtonPressed:(NSString*)wheelchairAccess {
    self.currentWheelchairStatus = wheelchairAccess;
    [self setWheelAccessButton];
}

- (void)categoryChosen:(WMCategory *)category {
    self.currentCategory = category;
    BOOL nodeTypeStillValid = NO;
    NodeType* fallBackNodeType = nil;
    for (NodeType *nt in self.currentCategory.nodeType) {
        if (!fallBackNodeType) {
            fallBackNodeType = nt;
        }
        if ([nt isEqual:self.currentNodeType]) {
            nodeTypeStillValid = YES;
        }
    }
    if (!nodeTypeStillValid) {
        self.currentNodeType = fallBackNodeType;
        
    }
    
    NSLog(@"NODE TYPE = %@", self.currentNodeType);
}

- (void)nodeTypeChosen:(NodeType*)nodeType {
    self.currentNodeType= nodeType;
    
    NSLog(@"NODE TYPE = %@", self.currentNodeType);
    
    [self.setNodeTypeButton setTitle:self.currentNodeType.localized_name forState:UIControlStateNormal];
}

- (void)markerSet:(CLLocationCoordinate2D)coord {
    hasCoordinate = YES;
    self.currentCoordinate = coord;
    self.node.lat = [NSNumber numberWithDouble:coord.latitude];
    self.node.lon = [NSNumber numberWithDouble:coord.longitude];
    
    [self.setMarkerButton setTitle:[NSString stringWithFormat:@"(%0.5f, %0.5f)", coord.latitude, coord.longitude] forState:UIControlStateNormal];
    [self saveCurrentEntriesToCurrentNode];
}

- (IBAction)showAccessOptions:(id)sender {
    [self buttonPressed];
    
    WMWheelchairStatusViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WMWheelchairStatusViewController"];
    vc.hideSaveButton = YES;
    vc.title = NSLocalizedString(@"WheelAccessStatusViewHeadline", nil);
    vc.navigationBarTitle = vc.title;
    vc.delegate = self;
    vc.node = self.node;
    vc.useCase = kWMWheelChairStatusViewControllerUseCasePutNode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setNodeType:(id)sender {
    [self buttonPressed];
    
    WMNodeTypeTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WMNodeTypeTableViewController"];
    vc.title =  NSLocalizedString(@"NavBarTitleSetNodeType", nil);
    vc.navigationBarTitle = vc.title;
    vc.delegate = self;
    vc.nodeArray = [self.currentCategory sortedNodeTypes];
    vc.currentNodeType = self.currentNodeType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setCategory:(id)sender {
    [self buttonPressed];
    
    WMCategoryTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WMCategoryTableViewController"];
    vc.title = NSLocalizedString(@"EditPOIViewCategoryLabel", @"");
    vc.navigationBarTitle = vc.title;
    vc.delegate = self;
    vc.categoryArray = self.dataManager.categories;
    vc.currentCategory = self.currentCategory;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) buttonPressed {
    [self.nameTextField resignFirstResponder];
    [self.infoTextView resignFirstResponder];
    [self.streetTextField resignFirstResponder];
    [self.housenumberTextField resignFirstResponder];
    [self.postcodeTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.websiteTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
}

- (void) pushToSetMarkerView {
    [self.nameTextField resignFirstResponder];
    [self.infoTextView resignFirstResponder];
    [self.streetTextField resignFirstResponder];
    [self.housenumberTextField resignFirstResponder];
    [self.postcodeTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.websiteTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
    WMSetMarkerViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WMSetMarkerViewController"];
    vc.node = self.node;
    vc.delegate = self;
    vc.currentCoordinate = self.currentCoordinate;
    vc.initialCoordinate = self.initialCoordinate;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)saveCurrentEntriesToCurrentNode {
    
    self.node.name = self.nameTextField.text;
    self.node.node_type = self.currentNodeType;
    self.node.wheelchair = self.currentWheelchairStatus;
    self.node.wheelchair_description = self.infoTextView.text;
    self.node.street = self.streetTextField.text;
    self.node.housenumber = self.housenumberTextField.text;
    self.node.postcode = self.postcodeTextField.text;
    self.node.city = self.cityTextField.text;
    self.node.website = self.websiteTextField.text;
    self.node.phone = self.phoneTextField.text;
    if ((!self.editView) && (hasCoordinate)) {
        self.node.lat = [NSNumber numberWithDouble:self.currentCoordinate.latitude];
        self.node.lon = [NSNumber numberWithDouble:self.currentCoordinate.longitude];
    }
}

- (void) saveEditedData {
    
    NSLog(@"Node: %@ %@", self.node.lat, self.node.lon);
    
    if (!self.node.lat || !self.node.lon) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PleaseSetMarker", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self saveCurrentEntriesToCurrentNode];
    
    if (!self.editView && (self.node.name == nil || self.node.name.length < 1)) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NodeNoNameSet", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (self.currentCategory == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NodeNoCategorySet", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self.dataManager updateNode:self.node];
    
    progressWheel.hidden = NO;
    [progressWheel startAnimating];
}

- (void) dataManager:(WMDataManager *)dataManager didUpdateNode:(Node *)node {
    progressWheel.hidden = YES;
    [progressWheel stopAnimating];
    NSLog(@"XXXXXXXX FINISHED");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES];
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"SaveSucess", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) dataManager:(WMDataManager *)dataManager updateNode:(Node *)node failedWithError:(NSError *)error {
    NSLog(@"XXXXXXXX Failed %@", error);
    progressWheel.hidden = YES;
    [progressWheel stopAnimating];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SaveNodeFailed", nil) message:error.wheelmapErrorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    
    [alert show];
    
}

- (void)dealloc {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField == self.streetTextField) {
        [self.housenumberTextField becomeFirstResponder];
    } else if (textField == self.housenumberTextField) {
        [self.postcodeTextField becomeFirstResponder];
        
    } else if (textField == self.postcodeTextField) {
        [self.cityTextField becomeFirstResponder];
        
    }
    
    [self saveCurrentEntriesToCurrentNode];
    
    return YES;
}


- (BOOL)textViewShouldReturn:(UITextView *)textView{
    
    [textView resignFirstResponder];
    [self saveCurrentEntriesToCurrentNode];
    return YES;
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText {
    
    NSString* newText = [self.infoTextView.text stringByReplacingCharactersInRange:aRange withString:aText];
    
    if (aTextView == self.infoTextView) {

		self.infoInputViewHeightConstraint.constant = self.infoTextView.contentSize.height + (2 * self.infoTextViewTopConstraint.constant);

		[UIView animateWithDuration:K_ANIMATION_DURATION_SHORT animations:^{
			[self.view layoutIfNeeded];
		}];

		self.infoPlaceholderTextView.hidden = (newText.length > 0);
    }
    
    if([aText isEqualToString:@"\n"]) {
        [aTextView resignFirstResponder];
        return NO;
    }
    
    if([newText length] > 255) {
        return NO; // can't enter more text
    } else {
        return YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[self keyboardDidMove:notification];
    }

	self.keyboardIsShown = NO;

    [self saveCurrentEntriesToCurrentNode];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        
        if (self.keyboardIsShown) {
            return;
        }

		[self keyboardDidMove:notification];
    }
    
    self.keyboardIsShown = YES;
}

- (void)keyboardDidMove:(NSNotification *)notification {
	// Adjust the keyboard bottom spacing to match the keyboard position
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	[UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
	[UIView setAnimationBeginsFromCurrentState:YES];

	BOOL isOpening = ([notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y > [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y);

	UIEdgeInsets contentInset = self.scrollView.contentInset;
	contentInset.bottom = (isOpening ? [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0);
	self.scrollView.contentInset = contentInset;
	self.scrollView.scrollIndicatorInsets = contentInset;
	[self.scrollView layoutIfNeeded];

	[UIView commitAnimations];
}

@end