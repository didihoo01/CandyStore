//
//  CandyChatTableViewController.m
//  Candy Store
//
//  Created by Jiahe Kuang on 9/22/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import "CandyChatTableViewController.h"

@interface CandyChatTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation CandyChatTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatTextField.delegate = self;
    
    self.chats = [[NSMutableArray alloc] init];
    
    //load chats from server
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.22:3000/candyChat"];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [getRequest setHTTPMethod:@"GET"];
    
    
    NSURLSessionDataTask *chatDownLoadTask = [urlSession dataTaskWithRequest:getRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        //if loaded, then display on the table view
        if (responseStatusCode == 200 && data)
        {
            
            NSError *error = nil;
            
            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0 error:&error];
            
            if (error) {
                NSLog(@"Error");
            }

                for (int i = 0; i < [downloadedJSON count]; i++)
                {
                    [self.chats addObject:downloadedJSON[i][@"candyChat"]];
                }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        }
        
        else {
            // error handling
        }
        
    }];
    
    [chatDownLoadTask resume];

}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat" forIndexPath:indexPath];
    
    cell.textLabel.text = self.chats[indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.chatTextField) {
        return YES;
    }
    
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDictionary *chatDictionary = [NSDictionary dictionaryWithObject:self.chatTextField.text forKey:@"candyChat"];
    
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.22:3000/candyChat"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chatDictionary options:0 error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionUploadTask *chatUploadTask = [urlSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode == 200)
        {
            NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            [getRequest setHTTPMethod:@"GET"];
            NSURLSessionDataTask *chatDownLoadTask = [urlSession dataTaskWithRequest:getRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                NSInteger responseStatusCode = [httpResponse statusCode];
                
                if (responseStatusCode == 200 && data)
                {
                    NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:0 error:nil];
                
                    [self.chats removeAllObjects];
                    
                    for (int i = 0; i < [downloadedJSON count]; i++)
                    {
                        [self.chats addObject:downloadedJSON[i][@"candyChat"]];
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        
                        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.chats count] - 1) inSection:0];
                        [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        
                    });
                }
                
                else {
                    // error handling
                }
                
            }];
            
            [chatDownLoadTask resume];
        }
        
        else
        {
            NSLog(@"data not received");

        }

    }];
    
    [chatUploadTask resume];
    _chatTextField.text = @"";
    return YES;
}

@end
