//
//  SearchViewController.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/4/20.
//
import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController ,UISearchResultsUpdating, UISearchBarDelegate {
    
    let viewModel = SearchControllerViewModel()
    let searchResults: BehaviorRelay<[Citys]> = BehaviorRelay(value: [])
    
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        searchResults.bind(to: self.tableView.rx.items) {table, row, model  in
            return self.makeSearchCell(with: model, from: table)
        }.disposed(by: self.viewModel.disposeBag)
        
        tableView.rx.modelSelected(Citys.self).subscribe(onNext : { item in
            self.viewModel.submitSearch(by: item)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.viewModel.disposeBag)
        
        tableView.tableFooterView = UIView()
    }
    
    private func makeSearchCell(with model: Citys, from table: UITableView) -> UITableViewCell {
        guard let searchCell = table.dequeueReusableCell(withIdentifier: searchCellId) else { fatalError("search cell does not exist") }
        searchCell.textLabel?.textColor = .white
        searchCell.textLabel?.text = model.name + ", " + model.sys.country
        return searchCell
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        NotificationCenter.default.post(name: Notification.Name(searchButtonId), object: nil)
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
}
