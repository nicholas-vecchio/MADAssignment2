//
//  MovieListViewController.swift
//  Assignment2
//
//  Created by Nicholas on 8/10/2023.
//
import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    var movies: [Movie] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }

    func loadMovies() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            movies = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    // When a movie is selected, go to the detail screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMovieDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMovieDetails", let destinationVC = segue.destination as? MovieDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedMovie = movies[indexPath.row]
        }
    }
}

