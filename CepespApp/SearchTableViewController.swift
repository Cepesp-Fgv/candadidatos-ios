//
//  SearchTableViewController.swift
//  CepespApp
//
//  Created by abraao barros lacerda on 06/03/2018.
//  Copyright © 2018 urbbox. All rights reserved.
//

import UIKit
import Alamofire

class Candidato: Codable {
    var ID:Int64?
    var NOME_CANDIDATO:String?
    var NOME_URNA_CANDIDATO:String?
    var CPF_CANDIDATO:String?
    var NUM_TITULO_ELEITORAL_CANDIDATO:String?
    var DATA_GERACAO:String?
    var HORA_GERACAO:String?
    var ANO_ELEICAO:String?
    var NUM_TURNO:String?
    var DESCRICAO_ELEICAO:String?
    var SIGLA_UF:String?
    var SIGLA_UE:String?
    var DESCRICAO_UE:String?
    var CODIGO_CARGO:String?
    var DESCRICAO_CARGO:String?
    var SEQUENCIAL_CANDIDATO:String?
    var NUMERO_CANDIDATO:String?
    var COD_SITUACAO_CANDIDATURA:String?
    var DES_SITUACAO_CANDIDATURA:String?
    var NUMERO_PARTIDO:String?
    var SIGLA_PARTIDO:String?
    var NOME_PARTIDO:String?
    var CODIGO_LEGENDA:String?
    var SIGLA_LEGENDA:String?
    var COMPOSICAO_LEGENDA:String?
    var NOME_COLIGACAO:String?
    var CODIGO_OCUPACAO:String?
    var DESCRICAO_OCUPACAO:String?
    var DATA_NASCIMENTO:String?
    var IDADE_DATA_ELEICAO:String?
    var CODIGO_SEXO:String?
    var DESCRICAO_SEXO:String?
    var COD_GRAU_INSTRUCAO:String?
    var DESCRICAO_GRAU_INSTRUCAO:String?
    var CODIGO_ESTADO_CIVIL:String?
    var DESCRICAO_ESTADO_CIVIL:String?
    var CODIGO_COR_RACA:String?
    var DESCRICAO_COR_RACA:String?
    var CODIGO_NACIONALIDADE:String?
    var DESCRICAO_NACIONALIDADE:String?
    var SIGLA_UF_NASCIMENTO:String?
    var CODIGO_MUNICIPIO_NASCIMENTO:String?
    var NOME_MUNICIPIO_NASCIMENTO:String?
    var DESPESA_MAX_CAMPANHA:String?
    var COD_SIT_TOT_TURNO:String?
    var DESC_SIT_TOT_TURNO:String?
    var EMAIL_CANDIDATO:String?
    var TOTAL_VOTACAO:String?
    
    public func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
    
    public func propertyValues() -> [Any] {
        return Mirror(reflecting: self).children.flatMap { $0.value }
    }
}

public struct ApiResponse<T:Codable>: Codable {
    public var data: T?
}

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var candidatos:[Candidato] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        load(q:"Lula da silva")
    }
    
    func load(q query:String){
        showActivityIndicatory()
        Alamofire.request(url[scope],
                          method:.get,
                          parameters:[param[scope]:query])
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidatos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CandidatoCell", for: indexPath)
        cell.textLabel?.text = scope == 0 ? candidatos[indexPath.row].NOME_CANDIDATO: candidatos[indexPath.row].NOME_URNA_CANDIDATO
        cell.detailTextLabel?.text = candidatos[indexPath.row].NUM_TITULO_ELEITORAL_CANDIDATO
        return cell
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        load(q: searchBar.text!)
    }
    
    let url:[String] = ["https://cepesp-app.herokuapp.com/api/dim/candidato","https://cepesp-app.herokuapp.com/api/dim/candidato"]
    let param:[String] = ["NOME_CANDIDATO","NOME_URNA_CANDIDATO"]
    var scope:Int = 0
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = selectedScope
        load(q: searchBar.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CandidatoSegue"  {
            let vc = segue.destination as! CandidatoTableViewController
            vc.can = candidatos[(tableView.indexPathForSelectedRow?.row)!]
            vc.scope = scope
        }
    }
}

extension UITableViewController {
    
    func showActivityIndicatory() {
        let activityload: UIActivityIndicatorView = UIActivityIndicatorView()
        activityload.center = self.view.center
        activityload.tag = 120
        activityload.hidesWhenStopped = true
        activityload.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityload.color = UIColor.gray
        self.view.addSubview(activityload)
        activityload.startAnimating()
    }
    
    func hideActivityIndicatory() {
        while let activityload : UIActivityIndicatorView = self.view.viewWithTag(120) as? UIActivityIndicatorView  {
            activityload.stopAnimating()
            activityload.removeFromSuperview()
        }
    }
    
    public func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height/2, width: self.view.frame.size.width - 20, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
