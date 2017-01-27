//
//  NewItemVC.swift
//  ListYourDreams
//
//  Created by Maciej Marut on 26.01.2017.
//  Copyright © 2017 Maciej Marut. All rights reserved.
//

import UIKit
import CoreData

class NewItemVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: - Variables
    var stores = [Store]()
    
    //MARK: - Outlets
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //MARK: - Actions
    @IBAction func saveItemTouched(_ sender: UIButton) {
        
    }

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //getTestData()
        fetchShopList()
        changePlaceholderColor(fields: [titleField, priceField, detailField])
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    //MARK: - Functions
    func changePlaceholderColor(fields: [UITextField]) {
        for field in fields {
            if let text = field.placeholder {
                field.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.white])
            }
        }
    }
    
    func getTestData() {
        let store = Store(context: context)
        store.name = "ebay"
        let store2 = Store(context: context)
        store2.name = "amazon"
        let store3 = Store(context: context)
        store3.name = "allegro"
        let store4 = Store(context: context)
        store4.name = "banggood"
        
        appDelegate.saveContext()
    }
    
    func fetchShopList() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            stores = try context.fetch(fetchRequest)
            pickerView.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    //MARK: - UIPickerView functions
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
