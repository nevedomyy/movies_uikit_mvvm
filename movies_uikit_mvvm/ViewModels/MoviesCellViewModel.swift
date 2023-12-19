import UIKit

protocol MoviesCellViewModel {
    init(apiProvider: ApiProvider)
    func fetchImage(path: String)
    var updateImage: ((UIImage?) -> ())? { get set }
}

class MoviesCellViewModelImpl: MoviesCellViewModel{
    private let apiProvider: ApiProvider
    var updateImage: ((UIImage?) -> ())?
    
    required init(apiProvider: ApiProvider) {
        self.apiProvider = apiProvider
    }
    
    func fetchImage(path: String){
        if path.isEmpty { return }
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
