//
//  RestaurantsViewController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit
import DZNEmptyDataSet

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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.alpha = 0.0
        self.showLoading()
        self.getRestaurants()
        super.viewWillAppear(animated)
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
        self.router.moveToAddRestaurantViewController(delegate: self)
    }
    
}

extension RestaurantsViewController {
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(RestaurantTableViewCell.nib, forCellReuseIdentifier: RestaurantTableViewCell.cellIdentifier)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
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

extension RestaurantsViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage.noRestaurantsFound
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let font = UIFont.openSansSemiBold(with: 21)
        let color = UIColor.neutralBlack.withAlphaComponent(0.2)
        let attributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        return NSAttributedString(string: self.roleManager.noRestaurantsFoundString(), attributes: attributes)
        
    }
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRestaurants
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.cellIdentifier) as! RestaurantTableViewCell
        cell.nameLabel.text = self.viewModel.name(at: indexPath.row)
        if self.viewModel.averageRating(at: indexPath.row) == 0 {
            cell.averageRatingLabel.text = " - "
        } else {
            cell.averageRatingLabel.text = "\(String(format: "%.2f", self.viewModel.averageRating(at: indexPath.row)))"
        }
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

extension RestaurantsViewController: AddRestaurantViewControllerDelegate {
    func didDeleteRestaurantIn(addRestaurantViewController: AddRestaurantViewController) {}
    
    func didPostNameIn(addRestaurantViewController: AddRestaurantViewController) {
        self.showLoading()
        self.getRestaurants()
    }
}
