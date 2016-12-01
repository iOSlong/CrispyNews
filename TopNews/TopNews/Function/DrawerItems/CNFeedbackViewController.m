//
//  CNFeedbackViewController.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/8.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNFeedbackViewController.h"



@interface CNFeedbackViewController ()

@end

@implementation CNFeedbackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - send email


#pragma mark - MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    //    void (^completion)(void) = ^{
    //        if (self.presentingViewController.presentedViewController) {
    //            [self dismissViewControllerAnimated:YES completion:nil];
    //        } else {
    //            [self.navigationController popViewControllerAnimated:YES];
    //        }
    //    };
    
    if (result == MFMailComposeResultCancelled) {
        //        completion = nil;
        [self dismissViewControllerAnimated:YES completion:nil];

    } else if (result == MFMailComposeResultFailed && error) {
        if ([UIAlertController class]) {
            UIAlertController *alert= [UIAlertController alertControllerWithTitle:CTFBLocalizedString(@"Error")
                                                                          message:error.localizedDescription
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *dismiss = [UIAlertAction actionWithTitle:CTFBLocalizedString(@"Dismiss")
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action) {
                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alert addAction:dismiss];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CTFBLocalizedString(@"Error")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:CTFBLocalizedString(@"Dismiss")
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else if (result == MFMailComposeResultSaved) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        //     MFMailComposeResultSent,
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
