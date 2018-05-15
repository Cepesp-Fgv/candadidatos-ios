//
//  CandidatoTableViewController.swift
//  CepespApp
//
//  Created by abraao barros lacerda on 07/03/2018.
//  Copyright © 2018 urbbox. All rights reserved.
//

import UIKit
import Alamofire

class CandidatoTableViewController: UITableViewController {
    
    public var can:Candidato?
    public var candidatos:[Candidato] = []
    public var scope:Int = 0
    
    let url:[String] = ["https://cepesp-app.herokuapp.com/api/dim/candidato","https://cepesp-app.herokuapp.com/api/dim/candidato"]
    let param:[String] = ["ID_DIM_CANDIDATO","ID_DIM_CANDIDATO"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = can?.NOME_CANDIDATO
        Alamofire.request("https://cepesp-app.herokuapp.com/api/candidatos",
                          method:.get,
                          parameters:[param[scope]:can?.ID])
            .responseJSON { (response) in
                do {
                    debugPrint(response)
                    let result = try JSONDecoder().decode(ApiResponse<[Candidato]>.self, from: response.data!)
                    self.candidatos = result.data!
                    self.tableView.reloadData()
                    self.hideActivityIndicatory()
                } catch let err {
                    print(err)
                    self.hideActivityIndicatory()
                    self.showToast(message: "Algum problema no servidor")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidatos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CandidatoCell", for: indexPath) as! CandidatoTableViewCell
        print(candidatos[indexPath.row].propertyNames())
        cell.nome_urna.text = candidatos[indexPath.row].NOME_URNA_CANDIDATO
        cell.ano.text = "\(candidatos[indexPath.row].ANO_ELEICAO ?? "") - \(candidatos[indexPath.row].DESCRICAO_CARGO ?? "") - \(candidatos[indexPath.row].NUM_TURNO ?? "") Turno"
        cell.sigla_ue.text = "\(candidatos[indexPath.row].SIGLA_UE ?? "BR")"
        cell.votos.text = "\(candidatos[indexPath.row].TOTAL_VOTACAO ?? "#NE#") votos"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CandidatoDetailSegue" {
            let vc =  segue.destination as! CandidatoDetailTableViewController
            vc.candidato = candidatos[tableView.indexPathForSelectedRow!.row]
        }
    }
    
   
}


class CandidatoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var votos: UILabel!

    @IBOutlet weak var nome_urna: UILabel!
    @IBOutlet weak var ano: UILabel!

    @IBOutlet weak var sigla_ue: UILabel!

}
