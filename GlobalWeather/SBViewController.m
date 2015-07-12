//
//  SBViewController.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "SBViewController.h"

@interface SBViewController ()
{
    CityRequest *userCityChoiseForForecast;
}
@end

@implementation SBViewController



- (void) receiveCityList: (NSNotification *) notification
{
    [myTableView reloadData];
    [sbvcActivityIndicator stopAnimating];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *userCityRequest = mySearchBar.text;
    [[AppCore sharedInstance] getNewCityListWithRequest:userCityRequest];
    [sbvcActivityIndicator startAnimating];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppCore sharedInstance] fetchCityList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    CityRequest *currentCityRequest = [[[AppCore sharedInstance] fetchCityList] objectAtIndex:indexPath.row];
    cell.textLabel.text = currentCityRequest.cityName;
    cell.detailTextLabel.text = currentCityRequest.region;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userCityChoiseForForecast = [[[AppCore sharedInstance] fetchCityList] objectAtIndex:indexPath.row];
    [[AppCore sharedInstance] getForecastWithRequest:userCityChoiseForForecast];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCityList:) name:@"cityList" object:nil];
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
