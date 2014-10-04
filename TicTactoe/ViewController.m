//
//  ViewController.m
//  TicTacToe
//
//  Created by Bradley Walker on 10/2/14.
//  Copyright (c) 2014 BlackSummerVentures. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
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
@property NSMutableArray *myArray;
@property NSMutableArray *totalPointsArray;
@property NSString *winner;
@property UIAlertView *alertOne;
@property UIAlertView *alertTwo;
@property UIAlertView *timerAlertView;
@property (strong, nonatomic) IBOutlet UILabel *draggableLabel;
@property NSInteger *timerValue;
@property (weak, nonatomic) IBOutlet UILabel *gameTimerLabel;

@property NSTimer *titleTimer;
@property NSTimer *totalTimer;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tic Tac Toe";
    
    //Create array of squares
    self.myArray = [NSMutableArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];
    
    //Alert Views
    self.alertOne = [[UIAlertView alloc] initWithTitle:@"You Won!!" message:@"X is the Winner!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [self.alertOne addButtonWithTitle:@"New Game"];
    self.alertTwo = [[UIAlertView alloc] initWithTitle:@"You Won!!" message:@"O is the Winner!!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [self.alertTwo addButtonWithTitle:@"New Game"];
    
    //An array of points for all the square labels on the board.
    self.totalPointsArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    //Clear all label text
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *labelMark = self.myArray[i];
        labelMark.text = @"";
    }
    
    
    self.gameTimerLabel.text = @"10";
    self.playerNumber = 1;
    [self titleTimers];
    
    

}

-(void)viewDidAppear:(BOOL)animated {
    self.originalCenter = self.draggableLabel.center;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self newGame:self];
    }
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    
    CGPoint point = [tapGesture locationInView:self.view];
    
    
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *label = self.myArray[i];
        CGRect labelFrameRect = CGRectFromString(NSStringFromCGRect(label.frame));

        
        if (CGRectContainsPoint(labelFrameRect, point)) {
            UILabel *labelMark = self.myArray[i];
            if ([labelMark.text  isEqualToString: @""]) {
                if (self.playerNumber % 2 == 0) {
                    labelMark.backgroundColor = [UIColor redColor];
                    labelMark.text = @"O";
                    self.playerNumber++;
                    self.gameTimerLabel.text = @"10";
                } else {
                    labelMark.backgroundColor = [UIColor blueColor];
                    labelMark.text = @"X";
                    self.playerNumber++;
                }
            }
        }
    }
    
    [self whoWon];
    [self determineDragableLabelValue];
    
}


- (IBAction)newGame:(id)sender {
    self.playerNumber = 0;
    
    //Turns all squares to green colors
    for (int i = 0; i < self.myArray.count; i++) {
        UILabel *labelMark = self.myArray[i];
        labelMark.backgroundColor = [UIColor greenColor];
        labelMark.text = @"";
    }
    [self whoWon];
    
    for (int i = 0; i < self.myArray.count; i++){
        [self.totalPointsArray insertObject:@"" atIndex:i];
    }
    NSLog(@"New Game Created");
    
    self.playerNumber = 0;
    self.gameTimerLabel.text = @"10";

}

- (void)whoWon{
    NSString *point;
    //for (UILabel *label in self.myArray)
    NSMutableArray *pointsArray = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i = 0; i < self.myArray.count; i++){
        UILabel *labelMark = self.myArray[i];
        if ([labelMark.text isEqualToString: @"X"]){
                point = @"1";
                [pointsArray insertObject:point atIndex:i];
            } else if ([labelMark.text isEqualToString:@"O"]){
                point = @"-1";
                [pointsArray insertObject:point atIndex:i];
            } else {
                point = @"0";
                [pointsArray insertObject:point atIndex:i];
            }
    }
    self.totalPointsArray = pointsArray;
    NSLog(@"%@\n",self.totalPointsArray);
    [self findWinner];
}

-(void)findWinnerTimer{
    float count_down = 0.1;
    self.totalTimer = [NSTimer scheduledTimerWithTimeInterval: count_down target: self
                                                        selector: @selector(findWinner) userInfo: nil repeats: YES];
}


-(void) findWinner {
    NSString *squareOne = self.totalPointsArray[0];
    NSString *squareTwo = self.totalPointsArray[1];
    NSString *squareThree = self.totalPointsArray[2];
    NSString *squareFour = self.totalPointsArray[3];
    NSString *squareFive = self.totalPointsArray[4];
    NSString *squareSix = self.totalPointsArray[5];
    NSString *squareSeven = self.totalPointsArray[6];
    NSString *squareEight = self.totalPointsArray[7];
    NSString *squareNine = self.totalPointsArray[8];
    
    NSInteger rowOne = squareOne.integerValue + squareTwo.integerValue + squareThree.integerValue;
    NSInteger rowTwo = squareFour.integerValue + squareFive.integerValue + squareSix.integerValue;
    NSInteger rowThree = squareSeven.integerValue + squareEight.integerValue + squareNine.integerValue;
    NSInteger columnOne = squareOne.integerValue + squareFour.integerValue + squareSeven.integerValue;
    NSInteger columnTwo = squareTwo.integerValue + squareFive.integerValue + squareEight.integerValue;
    NSInteger columnThree = squareThree.integerValue + squareSix.integerValue + squareNine.integerValue;
    NSInteger diaganolOne = squareOne.integerValue + squareFive.integerValue + squareNine.integerValue;
    NSInteger diagonalTwo = squareThree.integerValue + squareFive.integerValue + squareSeven.integerValue;
    
    if (rowOne == -3 ) {
        self.winner = @"O";
        [self.alertTwo show];
        }else if (rowOne == 3){
            self.winner = @"X";
            [self.alertOne show];
    }
    if (rowTwo == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }else if (rowTwo == 3){
            self.winner = @"X";
            [self.alertOne show];
    }
    if (rowThree == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }else if (rowThree == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    if (columnOne == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }else if (columnOne== 3) {
        self.winner = @"X";
        [self.alertOne show];
    }
    if (columnTwo == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }
    else if (columnTwo == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    
    if (columnThree == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }
    else if (columnThree == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    if (diaganolOne == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }
    else if (diaganolOne ==3){
        self.winner = @"X";
        [self.alertOne show];
        
    }
    if (diagonalTwo == -3) {
        self.winner = @"O";
        [self.alertTwo show];
    }
    else if (diagonalTwo == 3){
        self.winner = @"X";
        [self.alertOne show];
    }
    
    NSLog(@"Row One: %ld", (long)rowOne);
    [self determineDragableLabelValue];
    
}


- (IBAction)draggableLabel:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint point = [panGesture locationInView:self.view];
    self.draggableLabel.center = point;

    for (int i = 0; i < self.myArray.count; i++) {
        
        UILabel *labelMarkTwo = self.myArray[i];
        CGRect labelFrameRect = CGRectFromString(NSStringFromCGRect(labelMarkTwo.frame));
        
        if ([labelMarkTwo.text  isEqualToString: @""]) {
            if (CGRectContainsPoint(labelFrameRect, point) && panGesture.state == UIGestureRecognizerStateEnded) {
                if (self.playerNumber % 2 == 0) {
                    labelMarkTwo.backgroundColor = [UIColor redColor];
                    labelMarkTwo.text = @"O";
                    self.playerNumber++;
                    self.gameTimerLabel.text = @"10";
                } else {
                    labelMarkTwo.backgroundColor = [UIColor blueColor];
                    labelMarkTwo.text = @"X";
                    self.playerNumber++;
                    self.gameTimerLabel.text = @"10";
                }
            }
        }
    }

    [self whoWon];
    [self findWinner];
    
}



-(void) determineDragableLabelValue {
    if (self.playerNumber % 2 == 0) {
        self.draggableLabel.text = @"O";
    } else {
        self.draggableLabel.text = @"X";
    }
}


-(void)titleTimers{
    float count_down = 1.0;
    self.titleTimer = [NSTimer scheduledTimerWithTimeInterval: count_down target: self
                                                     selector: @selector(modifyTitle) userInfo: nil repeats: YES];
}
-(void)modifyTitle{
    if (self.gameTimerLabel.text.integerValue > 1) {
        NSInteger time = self.gameTimerLabel.text.integerValue;
        time--;
        self.gameTimerLabel.text = [NSString stringWithFormat:@"%ld",(long)time];
    } else {
        self.gameTimerLabel.text = @"10";
        self.playerNumber++;
        [self determineDragableLabelValue];
    }
    NSLog(@"The player number value is: %ld", (long)self.playerNumber);
}

@end
