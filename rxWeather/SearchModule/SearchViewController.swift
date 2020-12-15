//
//  SearchViewController.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/4/20.
//
import UIKit
import RxCocoa
import RxSwift
protocol SearchButtonDelegate: class  {
    func didButtonShown(stats: Bool)
}

class SearchViewController: UIViewController ,UISearchResultsUpdating, UISearchBarDelegate {
    
    let viewModel = SearchControllerViewModel()
    let searchResults: BehaviorRelay<[Citys]> = BehaviorRelay(value: [])
    var delegate: SearchButtonDelegate?

    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        searchResults.bind(to: self.tableView.rx.items) {table, row, model  in
            return self.makeSearchCell(with: model, from: table)
        }.disposed(by: self.viewModel.disposeBag)
        
        tableView.rx.modelSelected(Citys.self).subscribe(onNext : { item in
            self.viewModel.submitSearch(by: item)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.viewModel.disposeBag)
        delegate!.didButtonShown(stats: false)
        tableView.tableFooterView = UIView()
    }
    
    private func makeSearchCell(with model: Citys, from table: UITableView) -> UITableViewCell {
        guard let searchCell = table.dequeueReusableCell(withIdentifier: searchCellId) else { fatalError("search cell does not exist") }
        searchCell.textLabel?.textColor = .white
        searchCell.textLabel?.text = model.name + ", " + model.sys.country
        return searchCell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate!.didButtonShown(stats: true)

    }
}
