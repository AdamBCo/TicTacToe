//
//  ViewController.m
//  TicTacToe
//
//  Created by Bradley Walker on 10/2/14.
//  Copyright (c) 2014 BlackSummerVentures. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelOne;
@property (strong, nonatomic) IBOutlet UILabel *labelTwo;
@property (strong, nonatomic) IBOutlet UILabel *labelThree;
@property (strong, nonatomic) IBOutlet UILabel *labelFour;
@property (strong, nonatomic) IBOutlet UILabel *labelFive;
@property (strong, nonatomic) IBOutlet UILabel *labelSix;
@property (strong, nonatomic) IBOutlet UILabel *labelSeven;
@property (strong, nonatomic) IBOutlet UILabel *labelEight;
@property (strong, nonatomic) IBOutlet UILabel *labelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property CGPoint originalCenter;
@property NSInteger playerNumber;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.view];
    NSLog(@"X location: %f", point.x);
    NSLog(@"Y Location: %f",point.y);
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    NSMutableArray *labelsArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    for (int i = 0; i < labelsArray.count; i++) {
        UILabel *label = labelsArray[i];
        NSString *labelFrameString = NSStringFromCGRect(label.frame);
        CGRect labelFrameRect = CGRectFromString(labelFrameString);
        //NSLog(@"%@",labelFrameString);
        
        if (CGRectContainsPoint(labelFrameRect, point)) {
            UILabel *labelMark = labelsArray[i];
        
        if (self.playerNumber % 2 == 0) {
            labelMark.backgroundColor = [UIColor redColor];
            labelMark.text = @"O";
            self.playerNumber++;
            NSLog(@"Player One");
        } else {
            labelMark.backgroundColor = [UIColor blueColor];
            labelMark.text = @"X";
            NSLog(@"Player Two");
            self.playerNumber++;
        }
            
            
        }
    }
    
    [self determineWinner];
    
}


- (IBAction)newGame:(id)sender {
    self.playerNumber = 0;
    
    NSMutableArray *labelsArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    //Turns all squares to green colors
    for (int i = 0; i < labelsArray.count; i++) {
        UILabel *labelMark = labelsArray[i];
        labelMark.backgroundColor = [UIColor greenColor];
        labelMark.text = @"";
        self.playerNumber++;
    }
    [self determineWinner];
    NSLog(@"New Game Created");

}

- (void)determineWinner {

    NSMutableArray *labelsArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    NSMutableArray *pointsArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    NSArray *replacedField = [NSArray arrayWithObjects:@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", nil];
    NSArray *replacedFieldTwo = [NSArray arrayWithObjects:@"-1", @"-1", @"-1", @"-1", @"-1", @"-1", @"-1", @"-1", @"-1", nil];
    NSArray *replacedFieldThree = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    for (int i = 0; i < labelsArray.count; i++) {
        UILabel *labelMark = labelsArray[i];
        NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:labelsArray[i],pointsArray[i], nil];

        if ([labelMark.text isEqualToString:@"X"]){
                [myDictionary setObject:[myDictionary objectForKey:[pointsArray objectAtIndex:i]] forKey:[replacedField objectAtIndex:i]];
                [myDictionary removeObjectForKey:[pointsArray objectAtIndex:i]];
            } else if ([labelMark.text isEqualToString:@"O"]){
                [myDictionary setObject:[myDictionary objectForKey:[pointsArray objectAtIndex:i]] forKey:[replacedFieldTwo objectAtIndex:i]];
                [myDictionary removeObjectForKey:[pointsArray objectAtIndex:i]];
            } else {
                [myDictionary setObject:[myDictionary objectForKey:[pointsArray objectAtIndex:i]] forKey:[replacedFieldThree objectAtIndex:i]];
                [myDictionary removeObjectForKey:[pointsArray objectAtIndex:i]];
            }
        
        NSArray *pointsOnPoints = [myDictionary allKeys];
        NSLog(@"%@",pointsOnPoints);
    }

}

- (void) findLabelUsingPoint:(CGPoint) point {
    
}

@end
