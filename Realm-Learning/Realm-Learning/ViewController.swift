//
//  ViewController.swift
//  Realm-Learning
//
//  Created by Tiến Việt Trịnh on 29/06/2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    //MARK: - Properties

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        write()
//        initObject()
//        readAll()
//        filterQuery()
//        updateData()
        deleteData()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        let config = RealmSwift.Realm.Configuration(
            schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
    }
    
    func write() {
        let viet = People()
        viet.name = "Trinh Tien Viet"
        viet.listAge.append(1311)
        viet.listAge.append(53)
        
        let ducanh = People()
        ducanh.name = "Tran Duc Anh"
        ducanh.listAge.append(22)
        ducanh.listAge.append(03)
        ducanh.address = "Hoang Xá, Vân Đình"
        
        let config = Realm.Configuration(
            schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(viet)
            realm.add(ducanh)

        }
    }
    
    func initObject() {
        let baolong = People(value: ["Vu Bao Long", [15, 18, 20], "Van Dình, Ứng Hoà"])

        let realm = try! Realm()
        
        try! realm.write {
            realm.add(baolong)
        }
    }
    
    func readAll() {
        let realm = try! Realm()
        
        let allPeople = realm.objects(People.self)
        print("DEBUG: \(allPeople)")
    }
    
    func filterQuery() {
        let realm = try! Realm()
        
        let allPeople = realm.objects(People.self)
        
        let viet = allPeople.first {
            return $0.name == "Trinh Tien Viet"
        }
        print("DEBUG: \(String(describing: viet))")
    }
    
    func updateData() {
        let realm = try! Realm()
        
        let viet = realm.objects(People.self).first!
        
        try! realm.write {
            viet.name = "Vietdz123"
            viet.address = "Hồng Thái, Hoàng Xá, Ứng Hoà, Hà Nội"
        }
    }
    
    func deleteData() {
        let realm = try! Realm()
        
        let long = realm.objects(People.self).last!
        
        try! realm.write({
            realm.delete(long)
        })
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
