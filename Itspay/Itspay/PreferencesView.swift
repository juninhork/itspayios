//
//  PreferencesView.swift
//  Itspay
//
//  Created by Arthur Augusto Sousa Marques on 12/20/16.
//  Copyright © 2016 Compilab. All rights reserved.
//

import UIKit
import MessageUI

class PreferencesView: UITableViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldCurrentPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldNewPasswordConfirmation: UITextField!

    @IBOutlet weak var buttonValue: UIButton!
    
    var isEmailEditing = false
    var isPasswordEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ajustes Gerais"
        
        updateViewInfo()
    }
    
    func updateViewInfo() {
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                isEmailEditing = !isEmailEditing
                
                if isEmailEditing {
                    isPasswordEditing = false
                }
                
                buttonValue.setTitle("Trocar Email", for: .normal)
            }
            if indexPath.row == 2 {
                isPasswordEditing = !isPasswordEditing
                
                if isPasswordEditing {
                    isEmailEditing = false
                }
                
                buttonValue.setTitle("Trocar Senha", for: .normal)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "showWebViewSegue", sender: self)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                UIApplication.shared.openURL(URL(string: "tel://\(PHONE_SAC)")!)
            } else if indexPath.row == 1 {
                UIApplication.shared.openURL(URL(string: "tel://\(PHONE_OUVIDORIA)")!)
            } else if indexPath.row == 2 {
                let mailComposeViewController = configuredMailComposeViewController()
                
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
        }
        
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([EMAIL_SAC])
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
//        AlertComponent.showSimpleAlert(title: "Erro", message: "Não foi possível enviar o email. Por favor cheque a configuração de email no seu dispositivo e tente novamente.", viewController: self)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 && !isEmailEditing {
                return 0
            }
            if !isPasswordEditing {
                if indexPath.row > 2 && indexPath.row <= 5 {
                    return 0
                }
            }
            if !isPasswordEditing && !isEmailEditing {
                if indexPath.row == 6 {
                    return 0
                }
            }
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebViewSegue" {
            let viewController = segue.destination as! WebView
            viewController.textTitle = "Termos de Uso"
            
            let url = URL(string: Repository.getPListValue(.services, key: "termosDeUso"))
            viewController.selectedURL = url
        }
    }
}
