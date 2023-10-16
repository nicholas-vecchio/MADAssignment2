//
//  CinemaTableController.swift
//  Assignment2
//
//  Created by Nicholas on 12/10/2023.
//

import UIKit
import CoreData

class CinemaTableViewController: UITableViewController {

    var cinemas: [Cinema] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCinemas()
    }
    
    func fetchCinemas() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Cinema> = Cinema.fetchRequest()
        
        do {
            cinemas = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching cinemas: \(error)")
        }
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cinemas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath)
        let cinema = cinemas[indexPath.row]
        cell.textLabel?.text = cinema.name
        cell.detailTextLabel?.text = cinema.location
        return cell
    }

    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCinema = cinemas[indexPath.row]
        performSegue(withIdentifier: "showDetailController", sender: selectedCinema)
    }

    // MARK: - Navigation

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showDetailController", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailController",
           let destinationVC = segue.destination as? CinemaDetailsViewController {
            destinationVC.cinemaToEdit = sender as? Cinema
        }
    }
}
