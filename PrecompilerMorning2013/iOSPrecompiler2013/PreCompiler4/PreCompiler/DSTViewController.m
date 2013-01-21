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

@end

@implementation DSTViewController
- (IBAction)redButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor redColor];
}
- (IBAction)yellowButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor yellowColor];
}
- (IBAction)greenButtonTapped:(UIButton *)sender {
    self.helloLabel.textColor = [UIColor greenColor];
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
