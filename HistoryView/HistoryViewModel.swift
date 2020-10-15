//
//  HistoryViewModel.swift
//  HistoryView
//
//  Created by MICHAIL SHAKHVOROSTOV on 15.10.2020.
//

import Foundation

struct HistoryViewModel {
    
    var sections = [HistorySection]()
    
    var transactions: [Transaction]? {
        
        didSet {
            
            guard let txs = transactions else {return}
            
            let firstMounth = "Jul"
            let secondMounth = "Jun"
            let thirdMounth = "May"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let firstMounthTransactions = txs.filter {
                let dateString = dateFormatter.string(from: $0.date)
                return dateString.starts(with: firstMounth)
            }
            
            let secondMounthTransactions = txs.filter {
                let dateString = dateFormatter.string(from: $0.date)
                return dateString.starts(with: secondMounth)
            }
            
            let thridMounthTransactions = txs.filter {
                let dateString = dateFormatter.string(from: $0.date)
                return dateString.starts(with: thirdMounth)
            }
            
            //create sections
            
            let firstMounthSection = HistorySection(title: "July", transactions: firstMounthTransactions)
            let secondMounthSection = HistorySection(title: "June", transactions: secondMounthTransactions)
            let thirdMounthSection = HistorySection(title: "May", transactions: thridMounthTransactions)
            
            //collect for display
            sections = [HistorySection]()
            sections.append(firstMounthSection)
            sections.append(secondMounthSection)
            sections.append(thirdMounthSection)
        }
        
        
    }
    
    
}
