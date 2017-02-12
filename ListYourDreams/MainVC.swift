//
//  MainVC.swift
//  ListYourDreams
//
//  Created by Maciej Marut on 25.01.2017.
//  Copyright © 2017 Maciej Marut. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //MARK: - Constants and variables
    let reusableCellIdentifier = "itemCell"
    let editItemSegue = "editItemSegue"
    var controller = NSFetchedResultsController<Item>()
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    //MARK: - View life cycle
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        //createTestData()
        fetchItemList()
    }
    
    //MARK: - Actions
    @IBAction func segmentChanged(_ sender: Any) {
        fetchItemList()
        tableView.reloadData()
    }
    
    
    //MARK: - Functions
    func fetchItemList() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segmentedControl.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segmentedControl.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print (error)
        }
        
    }
    func createTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro late 2016"
        item.price = 12000
        item.details = "New MacBook Pro 2016 with the touchBar!"
        appDelegate.saveContext()
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editItemSegue {
            if let controller = segue.destination as? NewItemVC {
                if let item = sender as? Item {
                    controller.itemToEdit = item
                }
            }
        }
    }
    
    //MARK: - CoreData functions
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    //MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let section = sections[section]
            return section.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.isSelected = false
        }
        
        if let objects = controller.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: editItemSegue, sender: item)
        }
    }
}
