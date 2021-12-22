

import UIKit
import Alamofire
import Reachability


class SearchViewController: UITableViewController {
  
  // MARK: Constants
  
  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultTableViewCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
    }
  }
  
  enum State {
    case notSearchedYet
    case loading
    case noResults
    case results
  }
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: Variables
  
  var films: [Film] = []
  var items: [Displayable] = []
  var selectedItems: Displayable?
  let reachability = try! Reachability()
  private(set) var state: State = .notSearchedYet
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var celNib = UINib(
      nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(
      celNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    celNib = UINib(
      nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(
      celNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    celNib = UINib(
      nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(
      celNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    
    searchBar.delegate = self
  }
  
  // MARK: Connection Check
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.main.async {
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: .reachabilityChanged, object: self.reachability)
      do{
        try self.reachability.startNotifier()
      }catch{
        print("could not start reachability notifier")
      }
    }
    
  }
  
  @objc func reachabilityChanged(note: Notification) {
    let reachability = note.object as! Reachability
    
    switch reachability.connection {
    case .wifi:
      self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    case .cellular:
      self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    case .unavailable:
      showNetworkError()
      view.isHidden = true
    case .none:
      return
    }
  }
  
  // MARK: TableView Delegate & DataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch state {
    case .notSearchedYet:
      return 0
    case .loading:
      return 1
    case .noResults:
      return 1
    case .results:
      return items.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch state {
    case .notSearchedYet:
      fatalError("Should never get here")
      
    case .loading:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.loadingCell,
        for: indexPath)
      
      let spinner = cell.viewWithTag(50) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
      
    case .noResults:
      return tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
        for: indexPath)
      
      
    case .results:
      let item = items[indexPath.row]
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.searchResultCell,
        for: indexPath) as! SearchResultTableViewCell
      cell.titleLabel.text = item.titleLabel
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "toDetailVC", sender: nil)
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedItems = items[indexPath.row]
    switch state {
    case .notSearchedYet, .loading, .noResults:
      return nil
    case .results:
      return indexPath
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? DetailViewController else {
      return
    }
    destinationVC.data = selectedItems
  }
}

// MARK: Api Fetch 
extension SearchViewController {
  func searchFilms(for title: String) {
    state = .loading
    let encodedText = title.addingPercentEncoding(
      withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let url = "https://www.omdbapi.com/?t=\(encodedText)&apikey=b71b9ac9"
    let parameters: [String: String] = ["search": title]
    AF.request(url, parameters: parameters).validate()
      .responseDecodable(of: Film.self) { response in
        
        guard let films = response.value else { return self.state = .noResults}
        DispatchQueue.main.async {
          self.state = .results
          self.items = [films]
          self.tableView.reloadData()
        }
        
      }
  }
}

// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let filmName = searchBar.text else { return }
    searchFilms(for: filmName)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.resignFirstResponder()
    items = films
    tableView.reloadData()
  }
  
}

// MARK: Helper
extension SearchViewController {
  func showNetworkError() {
    let alert = UIAlertController(
      title: NSLocalizedString("Whoops...", comment: "Network error alert title"),
      message: NSLocalizedString("There is no internet connection for including features." +
                                 " Please try again with a connection.", comment: "Network error alert message"),
      preferredStyle: .alert)
    
    let action = UIAlertAction(
      title: NSLocalizedString("OK", comment: "OK button title"), style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}



