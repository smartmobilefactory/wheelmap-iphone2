//
//  WMWheelchairStatusViewController.m
//  Wheelmap
//
//  Created by Dorian Roy on 26.11.12.
//  Copyright (c) 2012 Sozialhelden e.V. All rights reserved.
//

#import "WMWheelchairStatusViewController.h"


@interface WMWheelchairStatusViewController ()

@end

@implementation WMWheelchairStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.noButton.titleLabel.text = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UIImage  *statusYesImage = [UIImage imageNamed:@"details_label-yes.png"];

    int startY = 10;
    
    self.yesButton = [WMButton buttonWithType:UIButtonTypeCustom];
    self.yesButton.frame = CGRectMake(10, startY, statusYesImage.size.width, statusYesImage.size.height);
    self.yesButton.tag = 0;
    [self.yesButton addTarget:self action:@selector(accessButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *yesButtonView = [self createButtonViewWithHealine:NSLocalizedString(@"WheelchairAccessYes", @"") image:[UIImage imageNamed:@"details_label-yes.png"] andString:NSLocalizedString(@"WheelchairAccessContentYes", @"")];
     [self.yesButton setView:yesButtonView forControlState:UIControlStateNormal];
    self.yesCheckMarkImageView = [self createCheckMarkImageView];
    [self.yesButton addSubview:self.yesCheckMarkImageView];
  
    
    startY += self.yesButton.frame.size.height+10;
    
    self.limitedButton = [WMButton buttonWithType:UIButtonTypeCustom];
    self.limitedButton.frame = CGRectMake(10, startY, statusYesImage.size.width, statusYesImage.size.height);
    self.limitedButton.tag = 1;
    [self.limitedButton addTarget:self action:@selector(accessButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *limitedButtonView = [self createButtonViewWithHealine:NSLocalizedString(@"WheelchairAccessLimited", @"") image:[UIImage imageNamed:@"details_label-limited.png"] andString:NSLocalizedString(@"WheelchairAccessContentLimited", @"")];
    [self.limitedButton setView:limitedButtonView forControlState:UIControlStateNormal];
    self.limitedCheckMarkImageView = [self createCheckMarkImageView];
    [self.limitedButton addSubview:self.limitedCheckMarkImageView];
    
    startY += self.limitedButton.frame.size.height+10;
    
    self.noButton = [WMButton buttonWithType:UIButtonTypeCustom];
    self.noButton.frame = CGRectMake(10, startY, statusYesImage.size.width, statusYesImage.size.height);
    self.noButton.tag = 2;
    [self.noButton addTarget:self action:@selector(accessButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *noButtonView = [self createButtonViewWithHealine:NSLocalizedString(@"WheelchairAccessNo", @"") image:[UIImage imageNamed:@"details_label-no.png"] andString:NSLocalizedString(@"WheelchairAccessContentNo", @"")];
    [self.noButton setView:noButtonView forControlState:UIControlStateNormal];
    self.noCheckMarkImageView = [self createCheckMarkImageView];
    [self.noButton addSubview:self.noCheckMarkImageView];
    
    [self.scrollView addSubview:self.yesButton];
    [self.scrollView addSubview:self.limitedButton];
    [self.scrollView addSubview:self.noButton];

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.noButton.frame.origin.y + self.noButton.frame.size.height + 20.0f);
    
    [self.view addSubview:self.scrollView];
 
}

- (void) viewWillAppear:(BOOL)animated {
    self.wheelchairAccess = self.node.wheelchair;
    [self updateCheckMarks];
}


- (void) updateCheckMarks {
    
    if ([self.wheelchairAccess isEqualToString:@"yes"]) {
        self.yesCheckMarkImageView.hidden = NO;
        self.limitedCheckMarkImageView.hidden = YES;
        self.noCheckMarkImageView.hidden = YES;
    } else if ([self.wheelchairAccess isEqualToString:@"limited"]) {
        self.yesCheckMarkImageView.hidden = YES;
        self.limitedCheckMarkImageView.hidden = NO;
        self.noCheckMarkImageView.hidden = YES;
    } else if ([self.wheelchairAccess isEqualToString:@"no"]) {
        self.yesCheckMarkImageView.hidden = YES;
        self.limitedCheckMarkImageView.hidden = YES;
        self.noCheckMarkImageView.hidden = NO;
    }  else if ([self.wheelchairAccess isEqualToString:@"unknown"]) {
        self.yesCheckMarkImageView.hidden = YES;
        self.limitedCheckMarkImageView.hidden = YES;
        self.noCheckMarkImageView.hidden = YES;
    }
}

- (UIImageView*) createButtonViewWithHealine: (NSString*) headline image: (UIImage*) image andString: (NSString*) contentString {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:50];

    WMLabel *headlineLabel = [[WMLabel alloc] initWithFrame:CGRectMake(40, 10, 220, 22)];
    [headlineLabel setText:headline];
    //headlineLabel.backgroundColor = [UIColor orangeColor];
    headlineLabel.font = [UIFont boldSystemFontOfSize:16];
    headlineLabel.textColor = [UIColor whiteColor];
    headlineLabel.textAlignment = UITextAlignmentLeft;
    [imageView addSubview:headlineLabel];
    
   WMLabel *contentTextField = [[WMLabel alloc] initWithFrame:CGRectMake(10, headlineLabel.frame.origin.y + headlineLabel.frame.size.height + 5, 280, 80)];
  //  contentTextField.backgroundColor = [UIColor blueColor];
    contentTextField.font = [UIFont systemFontOfSize:15];
    contentTextField.textColor = [UIColor whiteColor];
    contentTextField.numberOfLines = 0;
    contentTextField.textAlignment = NSTextAlignmentLeft;
    [contentTextField setText:contentString];
    [imageView addSubview:contentTextField];
    [contentTextField adjustHeightToContent];
    
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y,
                                 imageView.frame.size.width, MAX(image.size.height, headlineLabel.frame.size.height + contentTextField.frame.size.height + 25.0f));
    
    return imageView;
}

- (UIImageView*) createCheckMarkImageView {
    UIImage *checkMark = [UIImage imageNamed:@"details_label-checked.png"];
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 8, checkMark.size.width, checkMark.size.height)];
    checkMarkView.image = checkMark;

    return checkMarkView;
}
                            
                            
/* Set a fixed size for view in popovers */

- (CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320, 480);
}



- (void)viewDidUnload {
    [self setYesButton:nil];
    [self setLimitedButton:nil];
    [self setNoButton:nil];
    [super viewDidUnload];
}

- (void) accessButtonPressed:(id)sender {
    
    UIButton *button = (UIButton*) sender;
    if (button.tag == 0) {
        self.wheelchairAccess = @"yes";
    } else if (button.tag == 1) {
        self.wheelchairAccess = @"limited";
    } else if (button.tag == 2) {
        self.wheelchairAccess = @"no";
    }
    [self updateCheckMarks];
}

- (void) saveAccessStatus {
    [self.delegate accessButtonPressed:self.wheelchairAccess];
    //[self.navigationController popViewControllerAnimated:YES];
    dataManager = [[WMDataManager alloc] init];
    dataManager.delegate = self;
    [dataManager putNode:self.node];
    
}

#pragma mark WMDataManager Delegate
-(void)dataManager:(WMDataManager *)dataManager didFinishPuttingWheelChairStatusWithMsg:(NSString *)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PUT_METHOD_SUCESS", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    NSLog(@"PUT NODE WHEELCHAIR STATUS SUCCEED. MSG FROM BACKEND: %@", msg);
    [alert show];
}

-(void)dataManager:(WMDataManager *)dataManager failedPuttingWheelChairStatusWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PUT_METHOD_FAILED", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"PUT THE NODE WHELLCHAIR STATUS FAILED! %@", error);
}

@end
