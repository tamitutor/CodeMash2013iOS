//
//  DSTInputViewController.m
//  PreCompiler
//
//  Created by Daniel Steinberg on 1/7/13.
//  Copyright (c) 2013 Dim Sum Thinking. All rights reserved.
//

#import "DSTInputViewController.h"

@interface DSTInputViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@end

@implementation DSTInputViewController
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self performSegueWithIdentifier:@"completeInput"
                            sender:self];
    return YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender {
    if ([segue.identifier isEqualToString:@"completeInput"]) {
        self.signInString = self.inputField.text;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputField becomeFirstResponder];
    if (self.backgroundColor) {
        self.view.backgroundColor = self.backgroundColor;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
