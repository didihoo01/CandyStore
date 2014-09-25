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
@property(strong, nonatomic)NSMutableArray *chats;
@end

@implementation CandyChatTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _chatTextField.delegate = self;
    
    _chats = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://10.0.17.254:3000/candyChat"];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [getRequest setHTTPMethod:@"GET"];
    
    
    NSURLSessionDataTask *chatDownLoadTask = [urlSession dataTaskWithRequest:getRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
    
        if (responseStatusCode == 200 && data)
        {
            
            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0 error:nil];
            NSLog(@"%d items received", [downloadedJSON count]);
            

                for (int i = 0; i < [downloadedJSON count]; i++)
                {
                    [_chats addObject:downloadedJSON[i][@"candyChat"]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chats count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat" forIndexPath:indexPath];
    
    cell.textLabel.text = _chats[indexPath.row];
    
    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
//    [_chats addObject:_chatTextField.text];
    
    NSDictionary *chatDictionary = [NSDictionary dictionaryWithObject:_chatTextField.text forKey:@"candyChat"];
    
    
    NSURL *url = [NSURL URLWithString:@"http://10.0.17.254:3000/candyChat"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chatDictionary options:0 error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
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
                    NSLog(@"%d items received", [downloadedJSON count]);
                    
                    
                    if ([_chats count] == 0) {
                        for (int i = 0; i < [downloadedJSON count]; i++)
                        {
                            [_chats addObject:downloadedJSON[i][@"candyChat"]];
                        }
                    }
                    
                    else
                    {
                        for (int i = 0; i < ([downloadedJSON count] - [_chats count]); i++)
                        {
                            [_chats addObject:downloadedJSON[[_chats count]][@"candyChat"]];
                        }
                    }

                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        
                        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([_chats count] - 1) inSection:0];
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
  
//    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    
//    [getRequest setHTTPMethod:@"GET"];
//    
//    
//    NSURLSessionDataTask *chatDownLoadTask = [urlSession dataTaskWithRequest:getRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//        NSInteger responseStatusCode = [httpResponse statusCode];
//        
//        
//        
//        
//        if (responseStatusCode == 200 && data)
//        {
//            
//            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data
//                                                                      options:0 error:nil];
//            NSLog(@"%d items received", [downloadedJSON count]);
//
//
//            for (int i = 0; i < [downloadedJSON count]; i++)
//            {
//                NSLog(@"%@", downloadedJSON[0][@"candyChat"]);
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//            
//            
//        }
//        
//        else {
//            // error handling
//        }
//        
//        
//    }];
//    
//    
//    [chatDownLoadTask resume];
    
    
    _chatTextField.text = @"";
    
//    [textField resignFirstResponder];
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.chats removeObjectAtIndex:indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

//+(NSString*) candyChatWithJSONDictionary:(NSDictionary *)dictionary
//{
//    return dictionary[@"candyChat"];;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
