//
//  PortConfigCell.m
//  FlightGearMap
//
//  Created by Jason Crane on 22/03/2015.
//
//

#import "PortConfigCell.h"

@implementation PortConfigCell

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    for (int x=0;x<[string length];x++) {
        char c = [string characterAtIndex:x];
        
        if (c < '0' || c > '9') {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    [_portUpdater updatePort:[[textField text] integerValue]];
    return YES;
}



@end
