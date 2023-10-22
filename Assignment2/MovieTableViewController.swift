//
//  MovieListViewController.swift
//  Assignment2
//
//  Created by Nicholas on 8/10/2023.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController {

    var movies: [Movie] = []
    var releasedMovies: [Movie] = []
    var comingSoonMovies: [Movie] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.allowsMultipleSelectionDuringEditing = true
        loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }

    func setupNavigationBar() {
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedMovies))
        navigationItem.rightBarButtonItems = [editButtonItem, addButton]
    }
    
    func loadMovies() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            movies = try context.fetch(request)
            categorizeMovies()
            tableView.reloadData()
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    func categorizeMovies() {
        let currentDate = Date()
        releasedMovies = movies.filter { $0.releaseDate ?? currentDate <= currentDate }
        comingSoonMovies = movies.filter { $0.releaseDate ?? currentDate > currentDate }
    }
    
    @objc func deleteSelectedMovies() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let movieToDelete = indexPath.section == 0 ? releasedMovies[indexPath.row] : comingSoonMovies[indexPath.row]
                context.delete(movieToDelete)
            }
            
            do {
                try context.save()
                loadMovies()
            } catch {
                print("Error deleting movies: \(error)")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? releasedMovies.count : comingSoonMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = indexPath.section == 0 ? releasedMovies[indexPath.row] : comingSoonMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Released" : "Coming Soon"
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
