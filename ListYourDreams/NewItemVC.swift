//
//  NewItemVC.swift
//  ListYourDreams
//
//  Created by Maciej Marut on 26.01.2017.
//  Copyright © 2017 Maciej Marut. All rights reserved.
//

import UIKit
import CoreData

class NewItemVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Variables
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    //MARK: - Outlets
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var storePickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storePickerView.delegate = self
        storePickerView.dataSource = self
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        createTestData()
        fetchShopList()
        fetchItemTypeList()
        changePlaceholderColor(fields: [titleField, priceField, detailField])
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    //MARK: - Actions
    @IBAction func saveItemTouched(_ sender: UIButton) {
        var item: Item!
        let image = Image(context: context)
        image.image = thumbnail.image
    
        if itemToEdit == nil {
            item = Item(context: context)
            item.created = NSDate()
        } else {
            item = itemToEdit
        }
        item.toImage = image
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailField.text {
            item.details = details
        }
        item.toStore = stores[storePickerView.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[categoryPickerView.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteTouched(_ sender: Any) {
        if itemToEdit != nil {
            let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                context.delete(self.itemToEdit!)
                appDelegate.saveContext()
                _ = self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func changeImageTouched(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK: - Functions
    func changePlaceholderColor(fields: [UITextField]) {
        for field in fields {
            if let text = field.placeholder {
                field.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.white])
            }
        }
    }
    
    func createTestData() {
        let store = Store(context: context)
        store.name = "ebay"
        let store2 = Store(context: context)
        store2.name = "apple"
        let store3 = Store(context: context)
        store3.name = "car dealer"
        let store4 = Store(context: context)
        store4.name = "banggood"
        let store5 = Store(context: context)
        store5.name = "allegro"
        let store6 = Store(context: context)
        store6.name = "amazon"
        
        let itemType = ItemType(context: context)
        itemType.type = "electronic"
        let itemType2 = ItemType(context: context)
        itemType2.type = "toys"
        let itemType3 = ItemType(context: context)
        itemType3.type = "cars"
        let itemType4 = ItemType(context: context)
        itemType4.type = "consumable"
        let itemType5 = ItemType(context: context)
        itemType5.type = "clothes"
        let itemType6 = ItemType(context: context)
        itemType6.type = "gadgets"

        
        appDelegate.saveContext()
    }
    
    func fetchShopList() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            stores = try context.fetch(fetchRequest)
            storePickerView.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    func fetchItemTypeList() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            itemTypes = try context.fetch(fetchRequest)
            categoryPickerView.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailField.text = item.details
            if let image = item.toImage?.image as? UIImage {
                thumbnail.image = image
            }
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePickerView.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
            if let type = item.toItemType {
                var index = 0
                repeat {
                    let t = itemTypes[index]
                    if t.type == type.type {
                        categoryPickerView.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < itemTypes.count)
            }
        }
    }
    
    //MARK: - UIPickerView functions
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return stores[row].name
        }
        return itemTypes[row].type
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return stores.count
        }
        return itemTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - ImagePicker functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnail.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}
