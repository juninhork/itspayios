//
//  CardsView.swift
//  Itspay
//
//  Created by Arthur Augusto Sousa Marques on 12/12/16.
//  Copyright © 2016 Compilab. All rights reserved.
//

import UIKit

class CardsView: UITableViewController {
    var arrayVirtualCards = [Credenciais]()
    
    var selectedVirtualCard : Credenciais!
    
    var messageErrorView : MessageErrorView!
    
    var countServiceCallTimes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVirtualCards()
        
        self.refreshControl = UIRefreshControl(frame: CGRect.zero)
        
        self.refreshControl?.addTarget(self, action: #selector(self.getVirtualCards), for: .valueChanged)
        
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func getVirtualCards() {
        if Repository.isMockOn() {
            arrayVirtualCards = [Credenciais]()
            
            for i in 1...4 {
                let virtualCardsJSON = Repository.getPListValue(.mocks, key: "virtualCards\(i)")
                
                let credenciais = Credenciais(object: virtualCardsJSON)
                
                credenciais.saldo = Int(arc4random_uniform(100000) + 1)
                credenciais.nomeImpresso = "Virtual Card \(i)"
                credenciais.urlImagemProduto = "Card\(i)"
                
                arrayVirtualCards.append(credenciais)
            }
            
            self.tableView.reloadData()
        } else {
            let url = CardsController.createVirtualCardsURLPath()
            
            Connection.request(url, method: .get, parameters: nil, dataResponseJSON: { (dataResponse) in
                self.refreshControl?.endRefreshing()
                
                if validateDataResponse(dataResponse, showAlert: false, viewController: self) {
                    if let value = dataResponse.result.value as? NSDictionary {
                        if let array = value["credenciais"] as? [Any] {
                            self.countServiceCallTimes = 0
                            
                            self.arrayVirtualCards = [Credenciais]()
                            
                            for object in array {
                                let credenciais = Credenciais(object: object)
                            
                                self.arrayVirtualCards.append(credenciais)
                            }
                            
                            if self.arrayVirtualCards.count == 0 {
                                self.messageErrorView.updateView("Nenhum cartão encontrado.")
                            } else {
                                self.messageErrorView.updateView("")
                            }
                        } else {
                            if self.countServiceCallTimes < 3 {
                                self.getVirtualCards()
                            }
                            
                            self.countServiceCallTimes += 1
                        }
                        
                        self.tableView.reloadData()
                    }
                } else {
                    self.messageErrorView.updateView(getDataResponseMessage(dataResponse))
                }
            })
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayVirtualCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardsCellIdentifier", for: indexPath)

        let virtualCard = arrayVirtualCards[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            if Repository.isMockOn() {
                imageView.image = UIImage(named: "Card\(indexPath.row+1)")
            } else {
                CardsController.openPlastics(virtualCard, in: imageView, showLoading: true)
            }
        }
        
        if let label = cell.viewWithTag(2) as? UILabel, let value = virtualCard.saldo {
            label.text = "\(value)".formatToCurrencyReal()
            
            label.layer.shadowOffset = CGSize(width: 0, height: 0)
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 6
        }
        
        if let label = cell.viewWithTag(3) as? UILabel, let value = virtualCard.nomeImpresso {
            label.text = "\(value)"
            
            label.layer.shadowOffset = CGSize(width: 0, height: 0)
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 6
        }
        
        if let label = cell.viewWithTag(4) as? UILabel, let value = virtualCard.credencialMascarada {
            label.text = "\(value)"
            
            label.layer.shadowOffset = CGSize(width: 0, height: 0)
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 6
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVirtualCard = arrayVirtualCards[indexPath.row]
        
        self.performSegue(withIdentifier: "DetailCardsSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailCardsSegue" {
            let viewController = segue.destination as! DetailCardsView
            viewController.virtualCard = selectedVirtualCard
        } else if segue.identifier == "MessageErrorSegue" {
            messageErrorView = segue.destination as! MessageErrorView
        }
    }
}
