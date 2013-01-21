//
//  DSTViewController.m
//  PreCompiler
//
//  Created by Daniel Steinberg on 1/7/13.
//  Copyright (c) 2013 Dim Sum Thinking. All rights reserved.
//

#import "DSTViewController.h"
#import "DSTInputViewController.h"

// Setup Lambda
typedef void(^ButtonThing)(UIButton *button, NSUInteger ids, BOOL *stop);

@interface DSTViewController ()
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtons;
// Declare with Lambda
@property (copy, nonatomic) ButtonThing enableButtons;

@end

@implementation DSTViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender {
    if([segue.identifier isEqualToString:@"showInput"])
    {
        DSTInputViewController *inputVC = segue.destinationViewController;
        inputVC.backgroundColor = self.helloLabel.textColor;
    }
}

- (IBAction)greenButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor greenColor];
    [self disableButton:sender];
}
- (IBAction)yellowButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor yellowColor];
    [self disableButton:sender];

}
- (IBAction)redButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor redColor];
    [self disableButton:sender];

}

- (void)disableButton:(UIButton *)tappedButton{

    [self enableButtons:nil];
    tappedButton.enabled = NO;
}

- (void)enableButtons:(UIButton *)tappedButton{
    
    /** This was the way he wanted it **/
    [self.colorButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        // do something
        button.enabled = YES;
    }];
    
    
    /** Using the Lambda (DOESN'T WORK) **/
//    [self.colorButtons enumerateObjectsUsingBlock:self.enableButtons];
    
}

- (void)disableButton:(UIButton *)tappedButton
            afterWait:(double)timePeriod {
    // do something
}

- (IBAction)cancelInput:(UIStoryboardSegue *)segue{}

- (IBAction)completeInput:(UIStoryboardSegue *)segue{
    DSTInputViewController *inputVC = segue.sourceViewController;
    self.helloLabel.text = inputVC.signInName;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
