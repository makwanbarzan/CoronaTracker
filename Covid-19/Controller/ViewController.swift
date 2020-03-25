//
//  ViewController.swift
//  Covid-19
//
//  Created by Makwan BK on 3/15/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var updateLabel: UILabel!
    
    var worldwide : World?
    var details = [Country]()
    var searchFilter = [Country]()
    var date : String?
    
    var isSearching = false
    
    //Sorting proccess:
    enum Sort {
        case mostCase
        case leastCase
        case mostDeath
        case leastDeath
        case mostRecover
        case leastRecover
        case name
    }
    
    var sorting = Sort.mostCase
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true

        fetchData()
        
        //Navigation bar buttons:
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButton))
        let sortBtn = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"), landscapeImagePhone: UIImage(systemName: "arrow.up.arrow.down.circle"), style: .plain, target: self, action: #selector(sortButton))
        let aboutBtn = UIBarButtonItem(image: UIImage(systemName: "info.circle"), landscapeImagePhone: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(infoButton))
                
        navigationItem.rightBarButtonItems = [refreshBtn, sortBtn]
        navigationItem.leftBarButtonItems = [aboutBtn]
        
        //Navigation bar customizing:
        title = "CoronaTracker"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        //Add search bar to navigation bar:
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        navigationItem.searchController = searchController
    
    }
    
    //Fetch the data from internet:
    func fetchData() {
        
        let url = URL(string:"https://bing.com/covid/data")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                
                if let response = try? JSONDecoder().decode(World.self, from: data) {
                    DispatchQueue.main.async {
                        
                        self.worldwide = response
                        self.details = response.areas
                        self.searchFilter = response.areas

                        self.date = response.lastUpdated

                        self.isSearching = false

                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        

                    }
                } else {
                    print(error?.localizedDescription)
                }
            
                self.details = []

                
            } else {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error while loading data", message: "We couldn't get the data due to internet connection interrupt. Please check your connection and tab the Restart button.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (action) in
                        self.fetchData()
                        
                    }))
                    self.present(ac, animated: true)
                }
            }
            
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //This is the first cell on the table view (apologize for identifier name):
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "SecondCell") as? SecondTableViewCell else {fatalError("second cell error")}

        //This is the second cell on the table view (apologize for identifier name):
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell") as? HomeTableViewCell else {fatalError("first cell error")}

        //Put the search results in the second cell:
        if isSearching {

            cell2.countryLabel.text = searchFilter[indexPath.row].detail.name
            cell2.caseNums.text = "\(searchFilter[indexPath.row].detail.cases)"
            cell2.deathNums.text = "\(searchFilter[indexPath.row].detail.deaths)"
            cell2.recoveryNums.text = "\(searchFilter[indexPath.row].detail.recovers)"
            cell2.countryImage.image = UIImage(named: searchFilter[indexPath.row].detail.name)

            cell1.isHidden = true

        } else {
            if indexPath.section == 0 {

                cell1.countryLabel.text = "Overall"
                cell1.caseNums.text = "\(worldwide?.totalConfirmed ?? 0)"
                cell1.deathNums.text = "\(worldwide?.totalDeaths ?? 0)"
                cell1.recoveryNums.text = "\(worldwide?.totalRecovered ?? 0)"
                cell1.countryImage.image = UIImage(named: "Overall")

                //Labels background customize:
                cell1.caseBC.layer.cornerRadius = 7
                cell1.deathBC.layer.cornerRadius = 7
                cell1.recoveryBC.layer.cornerRadius = 7

                return cell1

            } else {

                cell2.countryLabel.text = details[indexPath.row].detail.name
                cell2.caseNums.text = "\(details[indexPath.row].detail.cases)"
                cell2.deathNums.text = "\(details[indexPath.row].detail.deaths)"
                cell2.recoveryNums.text = "\(details[indexPath.row].detail.recovers)"

                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = UITableView.automaticDimension
                
            }

            //Singular and plular words:
            if details[indexPath.row].detail.cases == 0 || details[indexPath.row].detail.cases == 1 {
                cell2.caseLabel.text = "Case"
            } else {
                cell2.caseLabel.text = "Cases"
            }

            if details[indexPath.row].detail.cases == 0 || details[indexPath.row].detail.cases == 1 {
                cell2.deathLabel.text = "Death"
            } else {
                cell2.deathLabel.text = "Deaths"
            }

            if details[indexPath.row].detail.cases == 0 || details[indexPath.row].detail.cases == 1 {
                cell2.recoverLabel.text = "Recover"
            } else {
                cell2.recoverLabel.text = "Recovers"
            }


            //Labels background customize:
            cell2.caseBC.layer.cornerRadius = 7
            cell2.deathBC.layer.cornerRadius = 7
            cell2.recoveryBC.layer.cornerRadius = 7

            //Put the country flag currectly:
            let imageName = cell2.countryLabel.text
            cell2.countryImage.image = UIImage(named: imageName!)

            return cell2
        }

        return cell2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isSearching {
            return searchFilter.count
        } else {
            if section == 0 {
                return 1
            } else {

                switch sorting {
                case .mostCase:
                    details.sort {$0.detail.cases > $1.detail.cases}
                case .leastCase:
                    details.sort {$0.detail.cases < $1.detail.cases}
                case .mostDeath:
                    details.sort {$0.detail.deaths > $1.detail.deaths}
                case .leastDeath:
                    details.sort {$0.detail.deaths < $1.detail.deaths}
                case .mostRecover:
                    details.sort {$0.detail.recovers > $1.detail.recovers}
                case .leastRecover:
                    details.sort {$0.detail.recovers < $1.detail.recovers}
                default:
                    details.sort {$0.detail.name < $1.detail.name}
                }

                return details.count
            }
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return 2
        }

    }
//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {

            //In case of not searching for anything:
            let detail = details[indexPath.row].detail

            //In case of searching for something:
            let detailFilter = searchFilter[indexPath.row].detail

            if isSearching {

                vc.countryImg = detailFilter.name
                vc.country = detailFilter.name
                vc.caseNumbers = "\(detailFilter.cases)"
                vc.deathNumbers = "\(detailFilter.deaths)"
                vc.recoveredNumbers = "\(detailFilter.recovers)"
                vc.numberofAlives = detailFilter.cases - detailFilter.deaths

                 vc.lastupdate = "Last Update: \(date?.replacingMultipleOccurrences(using: (of: "T", with: " "), (of: "Z", with: " UTC +0")) ?? "Last Update: Not available.")"

            } else {
                if indexPath.section == 0 {

                    vc.countryImg = "Overall"
                    vc.country = "Overall"
                    vc.caseNumbers = "\(worldwide!.totalConfirmed)"
                    vc.deathNumbers = "\(worldwide!.totalDeaths)"
                    vc.recoveredNumbers = "\(worldwide!.totalRecovered)"
                    vc.numberofAlives = worldwide!.totalConfirmed - worldwide!.totalDeaths

                    vc.lastupdate = "Last Update: \(date?.replacingMultipleOccurrences(using: (of: "T", with: " "), (of: "Z", with: " UTC +0")) ?? "Last Update: Not available.")"

                } else {

                    vc.countryImg = detail.name
                    vc.country = detail.name
                    vc.caseNumbers = "\(detail.cases)"
                    vc.deathNumbers = "\(detail.deaths)"
                    vc.recoveredNumbers = "\(detail.recovers)"
                    vc.numberofAlives = detail.cases - detail.recovers

                    vc.lastupdate = "Last Update: \(date?.replacingMultipleOccurrences(using: (of: "T", with: " "), (of: "Z", with: " UTC +0")) ?? "Last Update: Not available.")"

                }
            }

            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        //Put the Last Update detail on the second section:
        if section == 1 {
            return "Last Update: \(date?.replacingMultipleOccurrences(using: (of: "T", with: " "), (of: "Z", with: " UTC +0")) ?? "Last Update: Not available.")"
        }

        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //About button on navigation:
    @objc func infoButton() {
        let ac = UIAlertController(title: "About", message: "This is free, open-sourced, online app for tracking COVID-19 outbreak cases based on countries. All data of this app has provided by Microsoft's Bing and will be updated daily.\nCreated by Makwan BK.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "View Codes", style: .default, handler: { (action) in
            if let url = URL(string: "https://github.com/m1bki0n/CoronaTracker") {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
              } else {
                UIApplication.shared.openURL(url)
              }
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Contact the Creator", style: .default, handler: { (action) in
             let appURL = URL(string: "twitter://user?screen_name=813078582")!
                   let webURL = URL(string: "https://twitter.com/M1bki0n")!
                   
                  if UIApplication.shared.canOpenURL(appURL as URL) {
                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(appURL)
                       } else {
                           UIApplication.shared.openURL(appURL)
                       }
                   } else {
                       //redirect to safari because the user doesn't have Instagram
                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(webURL)
                       } else {
                           UIApplication.shared.openURL(webURL)
                       }
                   }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    //Refresh button on navigation:
    @objc func refreshButton() {
        fetchData()
    }
    
    //Sort button on navigation:
    @objc func sortButton() {
        
        
        let ac = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Sort by Most Case Records", style: .default, handler: { (action) in
            self.sorting = Sort.mostCase
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Sort by Least Case Records", style: .default, handler: { (action) in
            self.sorting = Sort.leastCase
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Sort by Name", style: .default, handler: { (action) in
            self.sorting = Sort.name
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Sort by Most Death Records", style: .default, handler: { (action) in
            self.sorting = Sort.mostDeath
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Sort by Least Death Records", style: .default, handler: { (action) in
            self.sorting = Sort.leastDeath
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Sort by Most Recover Records", style: .default, handler: { (action) in
            self.sorting = Sort.mostRecover
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Sort by Least Recover Records", style: .default, handler: { (action) in
            self.sorting = Sort.leastRecover
            self.tableView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty && searchText != " " && searchText != "  " else {searchFilter = details; return}

        searchFilter = details.filter ({ user -> Bool in
            return user.displayName.contains(searchText)
        })

        isSearching = true
        tableView.reloadData()

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isSearching = false
        searchFilter = details
        tableView.reloadData()
    }

}
