import UIKit

protocol MoviesViewModel {
    init(apiProvider: ApiProvider)
    func fetchMovies()
    var showLoader: (() -> ())? { get set }
    var showError: (() -> ())? { get set }
    var showMovies: ((Movies) -> ())? { get set }
    var updateImage: ((UIImage?) -> ())? { get set }
}

class MoviesViewModelImpl: MoviesViewModel{
    private let apiProvider: ApiProvider
    var showLoader: (() -> ())?
    var showError: (() -> ())?
    var showMovies: ((Movies) -> ())?
    var updateImage: ((UIImage?) -> ())?

    required init(apiProvider: ApiProvider) {
        self.apiProvider = apiProvider
    }

    func fetchMovies(){
        self.showLoader?()
        apiProvider.fetchMovies{ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.showMovies?(data)
                case .failure(_):
                    self?.showError?()
                }
            }
        }
    }
}
