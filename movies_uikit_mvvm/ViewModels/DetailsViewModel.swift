import UIKit

protocol DetailsViewModel {
    init(apiProvider: ApiProvider)
    func fetchDetails(id: Int)
    var showLoader: (() -> ())? { get set }
    var showError: (() -> ())? { get set }
    var showDetails: ((Details) -> ())? { get set }
    var updateImage: ((UIImage?) -> ())? { get set }
}

class DetailsViewModelImpl: DetailsViewModel{
    private let apiProvider: ApiProvider
    var showLoader: (() -> ())?
    var showError: (() -> ())?
    var showDetails: ((Details) -> ())?
    var updateImage: ((UIImage?) -> ())?
    
    required init(apiProvider: ApiProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchDetails(id: Int){
        self.showLoader?()
        apiProvider.fetchDetails(id: id){ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.fetchImage(path: data.backdropPath)
                    self?.showDetails?(data)
                case .failure(_):
                    self?.showError?()
                }
            }
        }
    }
    
    private func fetchImage(path: String){
        apiProvider.fetchImg(path: path){ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.updateImage?(UIImage(data: data))
                case .failure(_):
                    self?.updateImage?(UIImage(named: "not_found.png"))
                }
            }
        }
    }
}
