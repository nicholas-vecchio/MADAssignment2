//
//  MovieDetailsViewController.swift
//  Assignment2
//
//  Created by Nicholas on 9/10/2023.
//

import UIKit
import CoreData

class MovieDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var directorsTextField: UITextField!
    @IBOutlet weak var castTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!

    lazy var selectedMovie: Movie = {
        return Movie(context: context)
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = selectedMovie.title
        directorsTextField.text = selectedMovie.directors
        datePicker.date = selectedMovie.releaseDate ?? Date()
        castTextField.text = selectedMovie.cast

        if let imageName = selectedMovie.poster, let image = UIImage(named: imageName) {
            imageView.image = image
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        selectedMovie.title = titleTextField.text
        selectedMovie.directors = directorsTextField.text
        selectedMovie.releaseDate = datePicker.date
        selectedMovie.cast = castTextField.text

        if let image = imageView.image, let imageData = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("\(selectedMovie.id).png")
            try? imageData.write(to: filename)
            selectedMovie.poster = "\(selectedMovie.id)"
        }

        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(withTitle: "Error", message: "Error saving movie details.")
        }
    }

    @IBAction func chooseImageButtonPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
