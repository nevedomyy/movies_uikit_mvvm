import UIKit

protocol MoviesVC {}

class MoviesVCImpl: UIViewController, MoviesVC {
    private let moviesView: MoviesView
    private var movies: Movies?
    private var cellsViewModel: [MoviesCellViewModel] = []
    
    var viewModel: MoviesViewModel?
    
    
    init(moviesView: MoviesView) {
        self.moviesView = moviesView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesView.tableView.dataSource = self
        moviesView.tableView.delegate = self
        moviesView.errorButton.addTarget(self, action: #selector(fetchMovies), for: .touchUpInside)
        view = moviesView
        
        callbacks()
        
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = moviesView.tableView.indexPathForSelectedRow {
            moviesView.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func callbacks(){
        viewModel?.showLoader = { [weak self] in
            self?.moviesView.loaderView()
        }
        viewModel?.showError = { [weak self] in
            self?.moviesView.errorView()
        }
        viewModel?.showMovies = { [weak self] movies in
            self?.movies = movies
            for _ in 0...movies.results.count-1 {
                self?.cellsViewModel.append(MoviesCellViewModelImpl(apiProvider: Dependencies.apiProvider))
            }
            self?.moviesView.successView()
        }
    }

    @objc private func fetchMovies(){
        viewModel?.fetchMovies()
    }
}
        
extension MoviesVCImpl: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: moviesView.identifier,
            for: indexPath) as? MoviesCell else {
            fatalError("Unsupported cell")
        }
        cell.title.text = movies?.results[indexPath.row].title ?? ""
        cell.descript.text = movies?.results[indexPath.row].overview ?? ""
        cellsViewModel[indexPath.row].updateImage = { img in
            cell.image.image = img
        }
        cellsViewModel[indexPath.row].fetchImage(path: movies?.results[indexPath.row].posterPath ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = movies?.results[indexPath.row].id else { return }
        navigationController?.pushViewController(Dependencies.detailsVC(id: id), animated: true)
    }
}
