//
//  ViewController.swift
//  HistoryView
//
//  Created by MICHAIL SHAKHVOROSTOV on 15.10.2020.
//

import UIKit

import Foundation

struct HistorySection {
    let title: String
    var transactions: [Transaction]
}

struct History: Codable {
    var transactions: [Transaction]
}

struct Transaction: Codable {
    let id: Int
    let type: String
    let amount: String
    let date: Date

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case amount
        case date = "processed_at"
    }

}

class HistoryViewController: UITableViewController {
        
    var viewModel: HistoryViewModel?
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        fetchTransactions()
    }
    
    func fetchTransactions() {
        
        HistoryService.shared.fetchTransaction { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let transactions):
                self.viewModel?.transactions = transactions
                self.tableView.reloadData()
            case .failure(let error):
                print("Error \(error)")
            
            }
            
        }
        
    }
        
    func style() {
        navigationItem.title = "Games"
        tableView.register(HistoryViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        viewModel = HistoryViewModel()
    
    }
}

// MARK: Data Source
extension HistoryViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
      
        guard let vm = viewModel else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HistoryViewCell
        else {
            return UITableViewCell()
        }
        
        let section = indexPath.section
        
        var transaction: Transaction
        
            switch section {
            case 0:
                transaction = vm.sections[0].transactions[indexPath.row]
            case 1:
                transaction = vm.sections[1].transactions[indexPath.row]
            case 2:
                transaction = vm.sections[2].transactions[indexPath.row]
            default:
                return UITableViewCell()
            }
        
        cell.transaction = transaction
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let vm = viewModel else {
            return 0
        }
        
        switch section {
        
        case 0:
            return vm.sections[0].transactions.count
        case 1:
            return vm.sections[1].transactions.count
        case 2:
            return vm.sections[2].transactions.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let vm = viewModel else {
            return nil
        }
        
        switch section {
        case 0:
            return vm.sections[0].title
        case 1:
            return vm.sections[1].title
        case 2:
            return vm.sections[2].title
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = viewModel?.sections else {return 0}
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .tileBrown
    }
}

