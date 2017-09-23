//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UIScrollViewDelegate, FiltersViewControllerDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    var searchController: UISearchController!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    var filteredBusinesses: [Business]!
    var filterSettings = Filters()
    var resultsCounter: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 120
        resultsCounter = 0
        
        filterSettings.deals = false
        filterSettings.sort = YelpSortMode.bestMatched
        filterSettings.categories = []
        filterSettings.distance = nil
        
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true, distance: 8047) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.text = "Restaurants"
        // updateSearchResults(for: searchController)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: resultsTableView.contentSize.height, width: resultsTableView.contentSize.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        resultsTableView.addSubview(loadingMoreView!)
        
        var insets = resultsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        resultsTableView.contentInset = insets
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let displayBusinesses = filteredBusinesses else {
            return 0
        }
        
        return displayBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        if let displayBusinesses = filteredBusinesses {
            cell.business = displayBusinesses[indexPath.row]
        }

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = resultsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - resultsTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting more data
            if(scrollView.contentOffset.y > scrollOffsetThreshold && resultsTableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: resultsTableView.contentSize.height, width: resultsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreResults()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let deals = filterSettings.deals ?? false
        let sort = filterSettings.sort ?? YelpSortMode.bestMatched
        let categories = filterSettings.categories ?? []
        let distance = filterSettings.distance ?? nil
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            Business.searchWithTerm(term: searchText, sort: sort, categories: categories, deals: deals, distance: distance, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
                    print("filtered search")
                    self.filteredBusinesses = resultBusinesses
                    self.resultsCounter = self.filteredBusinesses.count
                    self.resultsTableView.reloadData()
                }
                )
            } else if let searchText = searchController.searchBar.text, searchText.isEmpty {
            Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
                print("default search with filters \(sort), \(deals), \(categories)")
                self.filteredBusinesses = resultBusinesses
                self.resultsCounter = self.filteredBusinesses.count
                self.resultsTableView.reloadData()
            }
            )
        }
        
    }
    
    func loadMoreResults() {
        let deals = filterSettings.deals ?? false
        let sort = filterSettings.sort ?? YelpSortMode.bestMatched
        let categories = filterSettings.categories ?? []
        let distance = filterSettings.distance ?? nil
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            Business.searchWithTerm(term: searchText, sort: sort, categories: categories, deals: deals, distance: distance, offset: resultsCounter, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                if let newBusineses = resultBusinesses {
                    self.filteredBusinesses.append(contentsOf: newBusineses)
                    self.resultsCounter = self.filteredBusinesses.count
                }
                self.resultsTableView.reloadData()
            }
            )
        } else if let searchText = searchController.searchBar.text, searchText.isEmpty {
            Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, offset: resultsCounter, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
                print("default search with filters \(sort), \(deals), \(categories)")
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                if let newBusineses = resultBusinesses {
                    self.filteredBusinesses.append(contentsOf: newBusineses)
                    self.resultsCounter = self.filteredBusinesses.count
                }
                self.resultsTableView.reloadData()
            }
            )
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    internal func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters) {
        print("dismissing")
        filtersViewController.dismiss(animated: true, completion: nil)
        filterSettings.sort = filters.sort
        filterSettings.deals = filters.deals
        filterSettings.categories = filters.categories
        filterSettings.distance = filters.distance
        updateSearchResults(for: searchController)
    }
    
}
