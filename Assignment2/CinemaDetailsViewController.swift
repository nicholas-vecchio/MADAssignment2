//
//  CinemaDetailsViewController.swift
//  Assignment2
//

import UIKit
import CoreData

class CinemaDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var moviesTableView: UITableView!
    
    var allMovies: [Movie] = []
    var selectedMovies: [Movie] = []
    var cinemaToEdit: Cinema?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllMovies()
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        // If editing, prefill the details
        if let cinema = cinemaToEdit {
            nameTextField.text = cinema.name
            locationTextField.text = cinema.location
            selectedMovies = cinema.movies?.allObjects as? [Movie] ?? []
        }
    }
    
    func fetchAllMovies() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        do {
            allMovies = try context.fetch(request)
            moviesTableView.reloadData()
        } catch {
            print("Error fetching movies: \(error)")
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // If editing, update the existing cinema. Otherwise, create a new cinema.
        let cinema = cinemaToEdit ?? Cinema(context: context)
        
        cinema.name = nameTextField.text
        cinema.location = locationTextField.text
        cinema.movies = NSSet(array: selectedMovies)
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true) // Navigate back after saving
        } catch {
            print("Error saving cinema: \(error)")
        }
    }
    
    // MARK: - TableView DataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = allMovies[indexPath.row]
        cell.textLabel?.text = movie.title // Assuming 'title' is an attribute of Movie
        cell.accessoryType = selectedMovies.contains(movie) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = allMovies[indexPath.row]
        if selectedMovies.contains(movie) {
            selectedMovies.removeAll { $0 == movie }
        } else {
            selectedMovies.append(movie)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
