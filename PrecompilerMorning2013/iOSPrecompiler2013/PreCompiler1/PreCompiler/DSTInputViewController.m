//
//  DSTInputViewController.m
//  PreCompiler
//
//  Created by twright on 1/9/13.
//  Copyright (c) 2013 Dim Sum Thinking. All rights reserved.
//

#import "DSTInputViewController.h"

@interface DSTInputViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation DSTInputViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"completeInput"
                              sender:self];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"completeInput"])
    {
        self.signInName = self.inputField.text;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.backgroundColor)
    {
        self.view.backgroundColor = self.backgroundColor;
    }
    [self.inputField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
