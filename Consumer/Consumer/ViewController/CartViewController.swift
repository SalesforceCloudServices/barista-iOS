//
//  CartViewController.swift
//  Consumer
//
//  Created by Nicholas McDonald on 2/12/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    fileprivate var tableView = UITableView(frame: .zero, style: .plain)
    fileprivate var order:Order
    fileprivate var orderStore:OrderStore
    fileprivate var itemStore:OrderItemStore
    fileprivate var orderItems:[OrderItem]
    
    init(order:Order, orderStore:OrderStore, itemStore:OrderItemStore) {
        self.order = order
        self.orderStore = orderStore
        self.itemStore = itemStore
        self.orderItems = itemStore.items(from: order)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Check Out"
        self.view.backgroundColor = UIColor.white
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.separatorColor = UIColor.clear
        self.tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "itemCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 40.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(self.tableView)
        
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CartHeaderView(frame: .zero)
        view.location1 = "Corner of 1st & Main"
        view.location2 = "123 Main St."
        view.location3 = "Chicago, Il 60601"
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = CartFooterView(frame: .zero)
        view.total = "Free"
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! CartItemTableViewCell
        let item = self.orderItems[indexPath.row]
        guard let productId = item.productId else {return cell}
        let product = ProductStore.instance.product(from: productId)
        cell.itemName = product?.name
        cell.description1 = "Description 1"
        cell.description2 = "Description 2"
        cell.price = "Free"
        return cell
    }
}











