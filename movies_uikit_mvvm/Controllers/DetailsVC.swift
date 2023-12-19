import UIKit

protocol DetailsVC {}

class DetailsVCImpl: UIViewController, DetailsVC {
    private let detailsView: DetailsView
    private let id: Int
    
    var viewModel: DetailsViewModel?
    
    init(detailsView: DetailsView, id: Int) {
        self.detailsView = detailsView
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.errorButton.addTarget(self, action: #selector(fetchDetails), for: .touchUpInside)
        view = detailsView
        
        callbacks()
        
        fetchDetails()
    }
    
    private func callbacks(){
        viewModel?.showLoader = { [weak self] in
            self?.detailsView.loaderView()
        }
        viewModel?.showError = { [weak self] in
            self?.detailsView.errorView()
        }
        viewModel?.showDetails = { [weak self] details in
            self?.detailsView.successView(
                title: details.title,
                raiting: "\(details.voteAverage)",
                budget: "\(details.budget)",
                descript: details.overview
            )
        }        
        viewModel?.updateImage = { [weak self] image in
            if image == nil { return }
            self?.detailsView.image.image = image
        }
    }

    @objc private func fetchDetails(){
        viewModel?.fetchDetails(id: self.id)
    }
}
