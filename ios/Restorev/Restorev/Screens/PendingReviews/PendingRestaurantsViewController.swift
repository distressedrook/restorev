//
//  PendingReviewsViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import UIKit

class PendingReviewsViewController: UIViewController, LoadingIndicatable {
    
    var viewModel: PendingReviewsViewModel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
    }
}

extension PendingReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
    }
}
