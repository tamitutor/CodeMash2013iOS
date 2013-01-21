//
//  DSTViewController.m
//  PreCompiler
//
//  Created by Daniel Steinberg on 1/7/13.
//  Copyright (c) 2013 Dim Sum Thinking. All rights reserved.
//

#import "DSTViewController.h"

@interface DSTViewController ()
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtons;
@end

@implementation DSTViewController

- (IBAction)redButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor redColor];
    [self disableButton:sender];
}
- (IBAction)yellowButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor yellowColor];
    [self disableButton:sender];
}
- (IBAction)greenButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor greenColor];
    [self disableButton:sender];
}
- (void)disableButton:(UIButton *)tappedButton {
    [self.colorButtons enumerateObjectsUsingBlock:^(UIButton *colorButton, NSUInteger idx, BOOL *stop) {
        colorButton.enabled = YES;
    }];
    tappedButton.enabled = NO;
}
- (IBAction)enableAllButtons:(UISwipeGestureRecognizer *)sender {
    [self disableButton:nil];
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
