//
//  ViewController.swift
//  Realm-Learning
//
//  Created by Tiến Việt Trịnh on 29/06/2023.
//

import UIKit


class ViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        let people = People()
        people.name = "Siuuuuuu"
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
