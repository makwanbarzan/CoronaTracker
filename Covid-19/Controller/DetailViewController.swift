//
//  DetailViewController.swift
//  Covid-19
//
//  Created by Makwan BK on 3/15/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var lastupdateLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var country : String?
    var caseNumbers: String?
    var deathNumbers: String?
    var recoveredNumbers: String?
    var numberofAlives: Int?
    var countryImg: String?
    var lastupdate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        //Navigation bar customizing:
        title = country
        navigationItem.largeTitleDisplayMode = .never

        countryName.text = country
        countryImage.image = UIImage(named: countryImg!)
        lastupdateLabel.text = lastupdate ?? "0"
        
        //Add a button to the navigation bar:
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButton))
        
    }
    

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        
        let caseNums = Int(caseNumbers!)!
        let deathNums = Int(deathNumbers!)!
        let recoversNums = Int(recoveredNumbers!) ?? 0
        
        
        cell.backgroundColor = .clear
        cell.cellBC.layer.cornerRadius = 15
        
        if indexPath.row == 0 {
            
            //Singular and plular words:
            if caseNums > 1 {
                cell.detailLabel.text = "\(caseNums) Persons Were Infected."

            } else {
                cell.detailLabel.text = "\(caseNums) Person Was Infected."
            }
            
            //Customize label and view:
            cell.detailLabel.textColor = .white
            cell.cellBC.backgroundColor = UIColor(cgColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
            
        } else if indexPath.row == 1 {
            
            //Singular and plular words:
            if deathNums > 1 {
                cell.detailLabel.text = "\(deathNums) Persons Were Died."
            } else {
                cell.detailLabel.text = "\(deathNums) Person Was Died."
            }
            
            //Customize label and view:
            cell.detailLabel.textColor = .white
            cell.cellBC.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            
        } else if indexPath.row == 2 {
            
            //Singular and plular words:
            if recoversNums > 1 {
                cell.detailLabel.text = "\(recoversNums) Persons Were Recovered."
            } else {
                cell.detailLabel.text = "\(recoversNums) Person Was Recovered."
            }

            //Customize label and view:
            cell.cellBC.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.1424642458, green: 0.8822802786, blue: 0.268921905, alpha: 1))
            
        } else {
            
            //Singular and plular words:
            if numberofAlives! > 1 {
                cell.detailLabel.text = "\(numberofAlives!) Active Cases."
            } else {
                cell.detailLabel.text = "\(numberofAlives!) Active Case."
            }
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    //Share button on navigation bar:
    @objc func shareButton() {
        
        let texts = "COVID-19 recorded cases in \(country ?? "Not Available"):\nTotal Cases: \(caseNumbers ?? "Not Available").\nDeaths: \(deathNumbers ?? "Not Available").\nRecovers: \(recoveredNumbers ?? "Not Available").\nActive Cases: \(numberofAlives ?? 0).\n\(lastupdate ?? "Not Available")."
        
        let ac = UIActivityViewController(activityItems: [texts], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
    }
    
    
}
