//
//  MasterViewController
//  SearchControllerDemo
//
//  Created by webwerks on 20/08/17.
//  Copyright © 2017 smart. All rights reserved.
//


import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchFooter: SearchFooter!
  
  var detailViewController: DetailViewController? = nil
  var employees = [Employee]()
  var filteredEmployees = [Employee]()
  let searchController = UISearchController(searchResultsController: nil)
  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    tableView.tableHeaderView = searchController.searchBar
    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    
    // Setup the Scope Bar
    searchController.searchBar.scopeButtonTitles = ["All", "iOS", "Android", "Other"]
    searchController.searchBar.delegate = self
    
    // Setup the search footer
    tableView.tableFooterView = searchFooter
    
    employees = [
      Employee(department:"iOS", name:"Mukesh"),
      Employee(department:"iOS", name:"Mukesh"),
      Employee(department:"iOS", name:"Mukesh"),
      Employee(department:"Android", name:"Ajinkya"),
      Employee(department:"Android", name:"Ajinkya"),
      Employee(department:"Android", name:"Ajinkya"),
      Employee(department:"Other", name:"Sharayu"),
      Employee(department:"Other", name:"Sharayu"),
      Employee(department:"Other", name:"Sharayu"),
      Employee(department:"Other", name:"Sharayu"),
      Employee(department:"iOS", name:"Manjusha"),
      Employee(department:"iOS", name:"Priyanka"),
      Employee(department:"Other", name:"Neelam"),
      Employee(department:"Other", name:"Sweety"),
      Employee(department:"Android", name:"Akshit")]
    
    if let splitViewController = splitViewController {
      let controllers = splitViewController.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if splitViewController!.isCollapsed {
      if let selectionIndexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: selectionIndexPath, animated: animated)
      }
    }
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table View
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      searchFooter.setIsFilteringToShow(filteredItemCount: filteredEmployees.count, of: employees.count)
      return filteredEmployees.count
    }
    
    searchFooter.setNotFiltering()
    return employees.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let employee: Employee
    if isFiltering() {
      employee = filteredEmployees[indexPath.row]
    } else {
      employee = employees[indexPath.row]
    }
    cell.textLabel!.text = employee.name
    cell.detailTextLabel!.text = employee.department
    return cell
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let employee: Employee
        if isFiltering() {
          employee = filteredEmployees[indexPath.row]
        } else {
          employee = employees[indexPath.row]
        }
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.detailEmployee = employee
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
  // MARK: - Private instance methods
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    filteredEmployees = employees.filter({( employee : Employee) -> Bool in
      let doesCategoryMatch = (scope == "All") || (employee.department == scope)
      
      if searchBarIsEmpty() {
        return doesCategoryMatch
      } else {
        return doesCategoryMatch && employee.name.lowercased().contains(searchText.lowercased())
      }
    })
    tableView.reloadData()
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func isFiltering() -> Bool {
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
  }
}

extension MasterViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}

extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
}
