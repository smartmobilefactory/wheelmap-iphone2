//
//  UIStoryboard+Wheelmap.m
//  Breeze
//
//  Created by H. Seiffert on 27.10.15.
//  Copyright (c) 2015 Smart Mobile Factory GmbH. All rights reserved.
//

#import "UIStoryboard+Wheelmap.h"

@implementation UIStoryboard (Wheelmap)

+ (UIStoryboard*)mainStoryboard {
	if (UIDevice.currentDevice.isIPad) {
		return [UIStoryboard mainIPadStoryboard];
	} else {
		return [UIStoryboard mainIPhoneStoryboard];
	}
}

+ (UIStoryboard*)mainIPhoneStoryboard {
	return [UIStoryboard storyboardWithName:@"Main-iPhone" bundle:nil];
}

+ (UIStoryboard*)mainIPadStoryboard {
	return [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
}

+ (UIStoryboard*)poiStoryboard {
	return [UIStoryboard storyboardWithName:@"POI" bundle:nil];
}

+ (UIStoryboard*)introStoryboard {
	return [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
}


#pragma mark - Instantiations

+ (id)instantiatedPOIsListViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMPOIsListViewController"];
}

+ (id)instantiatedEditPOIViewController {
	return [UIStoryboard.poiStoryboard instantiateViewControllerWithIdentifier:@"WMEditPOIViewController"];
}

+ (id)instantiatedRegisterViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMRegisterVC"];
}

+ (id)instantiatedDetailViewController {
	return [UIStoryboard.poiStoryboard instantiateInitialViewController];
}

+ (id)instantiatedAcceptTermsViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"AcceptTermsVC"];
}

+ (id)instantiatedOSMOnboardingViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMOSMOnboardingViewController"];
}

+ (id)instantiatedOSMLogoutViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMOSMLogoutViewController"];
}

+ (id)instantiatedCreditsViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMCreditsViewController"];
}

+ (id)instantiatedDescriptionViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMOSMDescriptionViewController"];
}

+ (id)instantiatedOSMLoginViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMOSMLoginVC"];
}

+ (id)instantiatedIntroViewController {
	return [UIStoryboard.introStoryboard instantiateViewControllerWithIdentifier:@"WMIintroViewController"];
}

+ (id)instantiatedProblemReportViewController {
	return [UIStoryboard.mainIPhoneStoryboard instantiateViewControllerWithIdentifier:@"WMProblemReportViewController"];
}

@end
