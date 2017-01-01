//
//  MarketPlaceController.swift
//  Itspay
//
//  Created by Arthur Augusto Sousa Marques on 12/29/16.
//  Copyright © 2016 Compilab. All rights reserved.
//

import UIKit

class MarketPlaceController {
    static let sharedInstance = MarketPlaceController()
    
    var cartProductsReferences = [Referencias]()
    
    static func createProductPartnerURLPath() -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "productPartner")
        
        url += "/\(ID_PROCESSADORA)/\(ID_INSTITUICAO)"
        
        return url
    }
    
    static func createProductImageURLPath(_ image : String) -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "productImage")
        
        url += "/\(image)"
        
        return url
    }
    
    static func getMainProductImage(_ product : Produtos, in imageView : UIImageView, showLoading : Bool) {
        imageView.image = UIImage(named: "image_placeholder")
        
        if let array = product.imagens {
            var image : Imagens?
            
            for imagem in array {
                if let main = imagem.principal {
                    if main {
                        image = imagem
                    }
                }
            }
            
            if let image = image, let url = image.idImagem {
                let url = MarketPlaceController.createProductImageURLPath("\(url)")
                
                var superview = UIView()
                
                if showLoading {
                    if let view = imageView.superview {
                        superview = view
                    } else {
                        superview = imageView
                    }
                    
                    LoadingProgress.startAnimating(in: superview, isAlphaReduced: false)
                }
                
                Connection.requestData(url, method: .get, parameters: nil, dataResponse: { (dataResponse) in
                    if showLoading {
                        LoadingProgress.stopAnimating(in: superview)
                    }
                    
                    if let data = dataResponse {
                        if let dataImage = Data(base64Encoded: data.base64EncodedString()) {
                            imageView.image = UIImage(data: dataImage)
                        }
                    }
                })
            }
        }
    }
    
    static func getProductImage(_ image : Imagens, in imageView : UIImageView, showLoading : Bool) {
        imageView.image = UIImage(named: "image_placeholder")
        
        if let url = image.idImagem {
            let url = MarketPlaceController.createProductImageURLPath("\(url)")
            
            var superview = UIView()
            
            if showLoading {
                if let view = imageView.superview {
                    superview = view
                } else {
                    superview = imageView
                }
                
                LoadingProgress.startAnimating(in: superview, isAlphaReduced: false)
            }
            
            Connection.requestData(url, method: .get, parameters: nil, dataResponse: { (dataResponse) in
                if showLoading {
                    LoadingProgress.stopAnimating(in: superview)
                }
                
                if let data = dataResponse {
                    if let dataImage = Data(base64Encoded: data.base64EncodedString()) {
                        imageView.image = UIImage(data: dataImage)
                    }
                }
            })
        }
    }
    
    static func addProductReferenceToCart(_ reference : Referencias) {
        MarketPlaceController.sharedInstance.cartProductsReferences.append(reference)
    }
}
