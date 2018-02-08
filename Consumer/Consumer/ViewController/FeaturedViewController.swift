//
//  FeaturedViewController.swift
//  Consumer
//
//  Created by David Vieser on 2/6/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController {

    @IBOutlet weak var featuredProductTableView: UITableView!

    var featuredProducts: [Product?] = [] {
        didSet {
            self.featuredProductTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        featuredProductTableView.tableFooterView = UIView()
        featuredProducts = ProductStore.instance.featuredProducts()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeaturedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FeaturedProductCell"
        
        // Dequeue or create a cell of the appropriate type.
        let cell: FeaturedProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FeaturedProductTableViewCell
        
        // Configure the cell to show the data.
        if let product: Product = featuredProducts[indexPath.row] {
            cell.name = product.name
            cell.imageURL = indexPath.row % 2 == 0 ? product.featuredImageRightURL : product.featuredImageLeftURL
        }
        
        return cell
    }
}
