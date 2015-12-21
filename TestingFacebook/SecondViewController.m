//
//  SecondViewController.m
//  TestingFacebook
//
//  Created by Nipuna H Herath on 12/21/15.
//  Copyright © 2015 Nipuna H Herath. All rights reserved.
//

#import "SecondViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UIView *fbView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;


@end
UIButton *myLoginButton;
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([FBSDKAccessToken currentAccessToken]){
        [myLoginButton setTitle:@"Log Out" forState:UIControlStateNormal];
        [self setDetails];
    }
    else{
        [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
        
    }
    
    // Do any additional setup after loading the view.
    
    // Add a custom login button to your app
    myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor blueColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    //[myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    
    if([FBSDKAccessToken currentAccessToken]){
        [myLoginButton setTitle:@"Log Out" forState:UIControlStateNormal];
        [self setDetails];
    }
    else{
        [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    }
    
    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];

}

-(void)loginButtonClicked
{
    if(![FBSDKAccessToken currentAccessToken]){
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        [login
         logInWithReadPermissions: @[@"public_profile"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 [myLoginButton setTitle:@"Log Out" forState:UIControlStateNormal];
                 NSLog(@"Logged in");
                 [self setDetails];
             }
         }];
        }
        else{
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            _imageView.image = NULL;
            self.lblName.text = NULL;
            [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    }
}

- (IBAction)sampleButton:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        [self setDetails];
    }
    
}

-(void)setDetails{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture.type(large), email, name, id, gender"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
             
             NSArray *fbDetails;
             fbDetails= result;
             NSString *pictureURL = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
             self.lblName.text = [result objectForKey:@"name"];
             NSLog(@"HAHAHA : %@",pictureURL);
             NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
             _imageView.image = [UIImage imageWithData:data];
         }
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
