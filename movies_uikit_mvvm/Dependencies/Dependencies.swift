import UIKit
import os

struct Dependencies{
    static let apiLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "API")
    
    static let apiProvider = ApiProviderImpl(
        logger: apiLogger
    )
    
    static let moviesVC: UIViewController = {
        let vc = MoviesVCImpl(
            moviesView: MoviesView()
        )
        vc.viewModel = MoviesViewModelImpl(
            apiProvider: apiProvider
        )
        return vc
    }()
    
    static func detailsVC(id: Int) -> UIViewController {
        let vc = DetailsVCImpl(
            detailsView: DetailsView(),
            id: id
        )
        vc.viewModel = DetailsViewModelImpl(
            apiProvider: apiProvider
        )
        return vc
    }
}
