//
//  CandidatoDetailTableViewController.swift
//  CepespApp
//
//  Created by abraao barros lacerda on 20/03/2018.
//  Copyright © 2018 urbbox. All rights reserved.
//

import UIKit

class CandidatoDetailTableViewController: UITableViewController {
    
    public var candidato:Candidato?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (candidato?.propertyNames().count)!
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = candidato?.propertyNames()[indexPath.row]
        if(candidato?.propertyValues()[indexPath.row] is Int64){
            cell.detailTextLabel?.text = "\(candidato?.propertyValues()[indexPath.row] ?? 0)"
        }else{
            cell.detailTextLabel?.text = "\(candidato?.propertyValues()[indexPath.row] as? String ?? "#NE#")"
        }
        return cell
    }
}
