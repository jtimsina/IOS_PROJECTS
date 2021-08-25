//
//  ViewController.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import UIKit
import Combine

class MoviesListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: MovieViewModelType = MovieViewModel()
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setUpBinding()
    }
    
    private func setUpBinding() {
        
        // create binding of movies
        viewModel
            .moviesBinding
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        // create binding for errors
        viewModel
            .errorBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] messageError in
                self?.displayErrorAlert(messageError)
            }
            .store(in: &subscribers)
        
        // binding to update row
        viewModel
            .updateRowBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }
            .store(in: &subscribers)
        
        viewModel.fetchMovies()
    }
    
    private func displayErrorAlert(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default)
        alert.addAction(acceptAction)
        present(alert, animated: true)
    }
    
}

extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let title = viewModel.getTitle(at: row)
        let overview = viewModel.getOverview(at: row)
        let data = viewModel.getImage(at: row)
        cell.configureCell(title: title, overview: overview, imageData: data)
        
        return cell
    }
    
}

extension MoviesListViewController{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let MovieCell = MovieCell()
        
        return MovieCell.heightForLabel(text: viewModel.getOverview(at: indexPath.row), font: UIFont.systemFont(ofSize: 17) , width: 200)
    }

//func lines(label: UILabel) -> Int {
//        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
//        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
//        let charSize = lroundf(Float(label.font.lineHeight))
//        let lineCount = rHeight/charSize
//        return lineCount
   }
//}
