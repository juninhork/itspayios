//
//  HighlightsView.swift
//  Itspay
//
//  Created by Arthur Augusto Sousa Marques on 12/20/16.
//  Copyright © 2016 Compilab. All rights reserved.
//

import UIKit

class HighlightsView: UICollectionViewController {
    var arrayProductPartner = [ProductPartner]()
    var arrayProducts = [Produtos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionViewLayout()
        
        searchHighlightedProducts()
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: SCREEN_WIDTH/2, height: 220)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView!.collectionViewLayout = layout
    }
    
    func searchHighlightedProducts() {
        let url = MarketPlaceController.createProductPartnerURLPath()
        
        Connection.request(url, method: .get, parameters: nil) { (dataResponse) in
            if validateDataResponse(dataResponse, showAlert: false, viewController: self) {
                if let value = dataResponse.result.value as? [Any] {
                    self.arrayProductPartner = [ProductPartner]()
                    self.arrayProducts = [Produtos]()
                    
                    for object in value {
                        let productPartner = ProductPartner(object: object)
                        
                        self.arrayProductPartner.append(productPartner)
                        
                        if let array = productPartner.produtos {
                            self.arrayProducts.append(contentsOf: array)
                        }
                    }
                    
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayProductPartner.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let productPartner = arrayProductPartner[section]
        
        if let array = productPartner.produtos {
            return array.count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightsCellIdentifier", for: indexPath)
        
        let productPartner = arrayProductPartner[indexPath.section]
        
        let product = arrayProducts[indexPath.row]
        
        if let label = cell.viewWithTag(1) as? UILabel, let value = product.nomeProduto {
            label.text = "\(value)"
        }

        if let imageView = cell.viewWithTag(2) as? UIImageView {
            MarketPlaceController.getProductImage(product, in: imageView, showLoading: true)
        }
        
        if let array = product.referencias {
            if let object = array.first {
                if let label = cell.viewWithTag(3) as? UILabel, let value = object.precoDe {
                    label.text = "\(value)".formatToCurrencyReal()
                }
                
                if let label = cell.viewWithTag(4) as? UILabel, let value = object.precoPor {
                    label.text = "\(value)".formatToCurrencyReal()
                }
                
                if let label = cell.viewWithTag(5) as? UILabel, let value = productPartner.quantMaxParcelaSemJuros, let price = object.precoPor {
                    label.text = "\(value)x de \("\(price / Float(value))".formatToCurrencyReal())"
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
