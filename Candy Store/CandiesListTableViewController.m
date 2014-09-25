//
//  CandiesListTableViewController.m
//  Candy Store
//
//  Created by Jiahe Kuang on 9/16/14.
//  Copyright (c) 2014 Jiahe Kuang. All rights reserved.
//

#import "CandiesListTableViewController.h"
#import "Candy.h"
#import "CandyViewController.h"
#import "NewCandyViewController.h"
#import "AppDelegate.h"

@interface CandiesListTableViewController ()

@property (nonatomic, strong) NSMutableArray *candies;

@end

@implementation CandiesListTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.candies count];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder])
    {
        
        //Create an array for storing our candies
        _candies = [NSMutableArray array];
        
        //Get the managedObjectContect from the signleton UIApplication delegate
        NSManagedObjectContext *candyContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        //Create an NSEntity using the Candy class and the context object we obtained from our App delegate
        NSEntityDescription *candyEntity = [NSEntityDescription entityForName:@"Candy" inManagedObjectContext:candyContext];
        
        //Create a new fecth request
        NSFetchRequest *candiesFetchRequest = [[NSFetchRequest alloc] init];
        
        //Assign the candyEntity to our request
        [candiesFetchRequest setEntity:candyEntity];
        
        //Assign nil to error
        NSError *error = nil;
        
        //Execute the fetch request and dereference the error pointer
        NSArray *candyList = [candyContext executeFetchRequest:candiesFetchRequest error: &error];
        
        _candies = [candyList mutableCopy];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandiesCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.candies[indexPath.row] name];
    cell.imageView.image = [UIImage imageWithData: [self.candies[indexPath.row] candyImage]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSManagedObjectContext *candyContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    if ([segue.identifier isEqualToString:@"showCandy"])
    {
        CandyViewController *candyViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        candyViewController.candy = self.candies[selectedIndexPath.row];
    
    }
    
    else if ([segue.identifier isEqualToString:@"addCandy"])
    {
        Candy *candy = [NSEntityDescription insertNewObjectForEntityForName:@"Candy" inManagedObjectContext:(NSManagedObjectContext *)candyContext];
        
        [self.candies addObject:candy];
        NewCandyViewController* newCandyViewController = [segue destinationViewController];
        newCandyViewController.candy = candy;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *candyContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    
    [candyContext deleteObject: self.candies[indexPath.row]];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];

    
    [self.candies removeObjectAtIndex:indexPath.row];
     
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
}


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
