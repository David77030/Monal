//
//  MLPasswordChangeTableViewController.m
//  Monal
//
//  Created by Anurodh Pokharel on 5/22/19.
//  Copyright © 2019 Monal.im. All rights reserved.
//

#import "MLPasswordChangeTableViewController.h"
#import "MLXMPPManager.h"


@interface MLPasswordChangeTableViewController ()
@property (nonatomic, weak)  UITextField* password;
@end

@implementation MLPasswordChangeTableViewController

-(void) closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) changePress:(id)sender
{
    if(!self.xmppAccount)
    {
        UIAlertController *messageAlert =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"No connected accounts",@"") message:NSLocalizedString(@"Please make sure you are connected before changing your password.",@"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"Close",@ "") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [messageAlert addAction:closeAction];
        
        [self presentViewController:messageAlert animated:YES completion:nil];
    }
    else
    {
        if(self.password.text.length>0)
        {
            [self.xmppAccount changePassword:self.password.text withCompletion:^(BOOL success, NSString *message) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *title =NSLocalizedString(@"Error",@ "");
                    NSString *displayMessage =message;
                    if(success) {
                        title=NSLocalizedString(@"Success",@ "");
                        displayMessage=NSLocalizedString(@"The password has been changed",@ "");
               
                       [[MLXMPPManager sharedInstance] updatePassword:self.password.text forAccount:self.xmppAccount.accountNo];
                    } else  {
                        if(displayMessage.length==0) displayMessage=NSLocalizedString(@"Could not change the password",@ "");
                    }
                    
                    UIAlertController *messageAlert =[UIAlertController alertControllerWithTitle:title message:displayMessage preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"Close",@ "") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }];
                    [messageAlert addAction:closeAction];
                    
                    [self presentViewController:messageAlert animated:YES completion:nil];
                });
            }];
        }
        else
        {
            UIAlertController *messageAlert =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error",@ "") message:NSLocalizedString(@"Password cannot be empty",@ "") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"Close",@ "") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [messageAlert addAction:closeAction];
            
            [self presentViewController:messageAlert animated:YES completion:nil];
            
        }
        
    }
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}


#pragma mark View life cycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"Change Password", @"");
    [self.tableView registerNib:[UINib nibWithNibName:@"MLTextInputCell"
                                               bundle:[NSBundle mainBundle]]
                               forCellReuseIdentifier:@"TextCell"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

#pragma mark tableview datasource delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return NSLocalizedString(@"Enter your new password. Passwords may not be empty. They may also be governed by server or company policies.",@ "");
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger toreturn =0;
    switch (section) {
        case 0:
            toreturn =1;
            break;
        case 1:
            toreturn=1;
            break;
            
        default:
            break;
    }
    
    return toreturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        MLTextInputCell *textCell =[tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        if(indexPath.row == 0)
        {
            self.password =textCell.textInput;
            self.password.placeholder = NSLocalizedString(@"New Password", @"");
            self.password.delegate=self;
            self.password.secureTextEntry=YES;
        }
        return textCell;
    }
    else
        return [tableView dequeueReusableCellWithIdentifier:@"addButton"];
}

#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




@end
