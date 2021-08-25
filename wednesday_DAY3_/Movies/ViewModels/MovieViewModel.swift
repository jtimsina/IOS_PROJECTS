//
//  MovieViewModel.swift
//  Movies
//
//  Created by Christian Quicano on 24/08/21.
//

import Foundation
import Combine

protocol MovieViewModelType {
    var count: Int { get }
    var moviesBinding: PassthroughSubject<Void, Never> { get }
    var errorBinding: Published<String>.Publisher { get }
    var updateRowBinding: Published<Int>.Publisher { get }
    func fetchMovies()
    func getTitle(at row: Int) -> String
    func getOverview(at row: Int) -> String
    func getImage(at row: Int) -> Data?
}


class MovieViewModel: MovieViewModelType {
    // communication = closure, delegate/protocol, observer
    
    // MARK:- internal properties
    let moviesBinding = PassthroughSubject<Void, Never>()
    var errorBinding: Published<String>.Publisher { $messageError }
    var updateRowBinding: Published<Int>.Publisher { $updateRow }
    
    @Published private var updateRow = 0
    @Published private var messageError = ""
    
    var count: Int { movies.count }
    func getTitle(at row: Int) -> String { movies[row].originalTitle }
    func getOverview(at row: Int) -> String { movies[row].overview }
    
    // MARK:- private properties
    private var movies = [Movie]()
    private let networkManager = NetworkManager()
    private var subscribers = Set<AnyCancellable>()
    private var imagesCache = [String: Data]()
    
    // MARK:- internal properties
    func fetchMovies() {
        // create the url
        let urlS = "https://api.themoviedb.org/3/movie/popular?api_key=6622998c4ceac172a976a1136b204df4&language=en-US"
        
        networkManager
            .getMovies(from: urlS)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.moviesBinding.send()
            }
            .store(in: &subscribers)
    }
    
    func getImage(at row: Int) -> Data? {
        
        let movie = movies[row]
        let posterPath = movie.posterPath
        
        if let data = imagesCache[posterPath] {
            return data
        }
        
        let urlS = "https://image.tmdb.org/t/p/w500\(posterPath)"
        networkManager
            .getImageData(from: urlS)
            .sink { _ in }
                receiveValue: { [weak self] data in
                    self?.imagesCache[posterPath] = data
                    self?.updateRow = row
            }
            .store(in: &subscribers)

        return nil
    }
}
