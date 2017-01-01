//
//  MainView.swift
//  Itspay
//
//  Created by Arthur Augusto Sousa Marques on 12/13/16.
//  Copyright © 2016 Compilab. All rights reserved.
//

import UIKit

class MainView: UIViewController {
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchScreenView = instantiateFrom("General", identifier: "LaunchScreenView") as! LaunchScreenView
        launchScreenView.startLaunchScreen(in: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateBlurFade), name: NSNotification.Name.init("animateBlurFade"), object: nil)
    }
    
    func animateBlurFade() {
        blurView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            self.blurView.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
}
