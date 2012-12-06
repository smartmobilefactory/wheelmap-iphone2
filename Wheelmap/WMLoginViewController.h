//
//  WMLoginViewController.h
//  Wheelmap
//
//  Created by Michael Thomas on 06.12.12.
//  Copyright (c) 2012 Sozialhelden e.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMLoginViewController : WMViewController <UITextFieldDelegate> {
    
    BOOL keyboardIsShown;
}

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

- (IBAction)loginPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)registerPressed:(id)sender;

@end
