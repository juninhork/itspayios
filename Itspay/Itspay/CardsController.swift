
//
//  CardsController.swift
//  Itspay
//
//  Created by Arthur Augusto Sousa Marques on 12/19/16.
//  Copyright © 2016 Compilab. All rights reserved.
//

import UIKit

class CardsController {
    static let sharedInstance = CardsController()
    
    static func createVirtualCardsURLPath() -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "credencial")
        
        if let value = LoginController.sharedInstance.loginResponseObject.cpf {
            url += "/\(value)"
        }
        
        url += "/pessoa/\(TIPO_PESSOA)/processadora/\(ID_PROCESSADORA)/instituicao/\(ID_INSTITUICAO)"
        
        return url
    }

    static func createDetailVirtualCardsURLPath(_ credencial : Credenciais) -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "credencial")
        
        if let value = credencial.idCredencial {
            url += "/\(value)/detalhes"
        }
        
        return url
    }

    static func createVirtualCardStatementURLPath(_ credencial : Credenciais, dataInicial : Date, dataFinal : Date) -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "credencial")
        
        if let value = credencial.idCredencial {
            url += "/\(value)/detalhes"
        }
        
        url += "/extrato/data_inicial/\(DateFormatter.stringWith("dd/MM/yyyy", from: dataInicial))/data_final/\(DateFormatter.stringWith("dd/MM/yyyy", from: dataFinal))"
        
        return url
    }

    static func createSearchTariffURLPath(_ credencial : Credenciais) -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "buscarTarifas")
        
        if let value = credencial.idConta {
            url += "/\(value)"
        }
        
        return url
    }
    
    static func createTariffProfileURLPath(_ credencial : Credenciais, tarifa : Int) -> String {
        var url = Repository.createServiceURLFromPListValue(.services, key: "perfilTarifario")
        
        if let value = credencial.idConta {
            url += "/\(value)"
        }
        
        url += "/tarifa/\(tarifa)"
        
        return url
    }
    
    static func createBanksListURLPath() -> String {
        return Repository.createServiceURLFromPListValue(.services, key: "bancos")
    }
}
