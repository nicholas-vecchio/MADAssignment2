//
//  CinemaTableController.swift
//  Assignment2
//
//  Created by Nicholas on 12/10/2023.
//

import UIKit
import CoreData

class CinemaTableViewController: UITableViewController {

    var cinemas = [Cinema]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.allowsMultipleSelectionDuringEditing = true
        loadCinemas()
    }
    
    func setupNavigationBar() {
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedCinemas))
        navigationItem.rightBarButtonItems = [editButtonItem, addButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCinemas()
    }

    func loadCinemas() {
        let request: NSFetchRequest<Cinema> = Cinema.fetchRequest()
        do {
            cinemas = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching cinemas: \(error)")
        }
    }
    
    @objc func deleteSelectedCinemas() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let cinemaToDelete = cinemas[indexPath.row]
                context.delete(cinemaToDelete)
                cinemas.remove(at: indexPath.row)
            }
            
            do {
                try context.save()
                tableView.deleteRows(at: selectedRows, with: .automatic)
            } catch {
                print("Error deleting cinemas: \(error)")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cinemas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath)
        let cinema = cinemas[indexPath.row]
        cell.textLabel?.text = cinema.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            navigationItem.rightBarButtonItems = [editButtonItem, deleteButton]
        } else {
            navigationItem.rightBarButtonItems = [editButtonItem, addButton]
        }
    }
}
