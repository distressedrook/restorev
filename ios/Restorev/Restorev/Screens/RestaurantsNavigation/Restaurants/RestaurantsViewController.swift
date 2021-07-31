//
//  RestaurantsViewController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

class RestaurantsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel: RestaurantsViewModel!
    var router: RestaurantsRouter!
    let roleManager = RoleManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAddButton()
        self.setupTableView()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(RestaurantTableViewCell.nib, forCellReuseIdentifier: RestaurantTableViewCell.cellIdentifier)
        self.tableView.reloadData()
    }
    
    func addAddButton() {
        let barButtonItem = roleManager.barButtonItemFor(restaurantViewController: self)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func didTapAddButton(sender: UIButton) {
        Log.d("Add button tapped")
    }
    
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.cellIdentifier) as! RestaurantTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
