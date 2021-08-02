//
//  RestaurantsViewController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

class RestaurantsViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel: RestaurantsViewModel!
    var router: RestaurantsRouter!
    let roleManager = RoleManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setOnce(viewModel: RestaurantsViewModelImp(), router: RestaurantsRouterImp(navigatable: self))
        self.bind()
        self.addAddButton()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getRestaurants()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = sender as? String else {
            fatalError("Sender must always be a string")
        }
        self.router.prepareToMoveTo(viewController: segue.destination, id: id)
    }
    
    func setOnce(viewModel: RestaurantsViewModel, router: RestaurantsRouter) {
        if self.viewModel == nil {
            self.viewModel = viewModel
        }
        if self.router == nil {
            self.router = router
        }
    }
    
    @objc func didTapAddButton(sender: UIButton) {
        Log.d("Add button tapped")
    }
    
}

extension RestaurantsViewController {
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(RestaurantTableViewCell.nib, forCellReuseIdentifier: RestaurantTableViewCell.cellIdentifier)
    }
    
    private func addAddButton() {
        let barButtonItem = roleManager.barButtonItemFor(restaurantViewController: self)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func bind() {
        self.viewModel.didGetRestaurants = {
            self.hideLoading()
            self.tableView.reloadData()
            UIView.animate(withDuration: Constants.ANIMATION_TIME) {
                self.tableView.alpha = 1.0
            }
        }
        
        self.viewModel.didGetRestaurantFail = { error in
            self.showError(with: Strings.failure, message: error.displayString)
            self.roleManager.restaurantsServiceFor(viewModel: self.viewModel)()
        }
    }
    
    private func getRestaurants() {
        self.showLoading()
        self.tableView.alpha = 0.0
        self.roleManager.restaurantsServiceFor(viewModel: self.viewModel)()
    }
    
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRestaurants
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.cellIdentifier) as! RestaurantTableViewCell
        cell.nameLabel.text = self.viewModel.name(at: indexPath.row)
        cell.averageRatingLabel.text = "\(String(format: "%.2f", self.viewModel.averageRating(at: indexPath.row)))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router.moveToRestaurantDetailWith(id: self.viewModel.id(at: indexPath.row))
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
}
