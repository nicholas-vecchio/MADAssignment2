//
//  CinemaDetailViewController.swift
//  Assignment2
//
//  Created by Nicholas on 22/10/2023.
//
import UIKit
import CoreData

class CinemaDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var moviesTableView: UITableView!

    lazy var selectedCinema: Cinema = {
        return Cinema(context: context)
    }()
    
    var selectedMovies: [Movie] = []
    var allMovies: [Movie] = []

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = selectedCinema.name
        locationTextField.text = selectedCinema.location
        selectedMovies = selectedCinema.movies?.allObjects as? [Movie] ?? []

        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        loadMovies()
    }

    func loadMovies() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            allMovies = try context.fetch(request)
            moviesTableView.reloadData()
        } catch {
            print("Error fetching movies: \(error)")
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = titleTextField.text, !name.isEmpty,
              let location = locationTextField.text, !location.isEmpty else {
            showAlert(withTitle: "Missing Information", message: "Please fill out all fields.")
            return
        }
        
        selectedCinema.name = name
        selectedCinema.location = location
        selectedCinema.movies = NSSet(array: selectedMovies)
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(withTitle: "Error", message: "Error saving cinema details.")
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaMovieCell", for: indexPath)
        
        let movie = allMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        
        if selectedMovies.contains(movie) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = allMovies[indexPath.row]
        
        if selectedMovies.contains(selectedMovie) {
            selectedMovies.removeAll { $0 == selectedMovie }
        } else {
            selectedMovies.append(selectedMovie)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
