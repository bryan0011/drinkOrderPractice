//
//  MenuTableViewController.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/20.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var drinkMenus: [Record] = []
    let ai = UIActivityIndicatorView(style: .large)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMenu()
        
        ai.center = tableView.center
        ai.startAnimating()
        tableView.addSubview(ai)
        ai.hidesWhenStopped = true
        
        
    }
    
    func fetchMenu() {
        if let url = URL(string: "https://api.airtable.com/v0/appbQTpLmlKHdXTtu/menu") {
            var request = URLRequest(url: url)
            request.setValue("Bearer keyAJ7qqPymAEq7JZ", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let searchResponse = try decoder.decode(DrinkMenu.self, from: data)
                        self.drinkMenus = searchResponse.records
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.ai.stopAnimating()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
        
    }
    @IBSegueAction func showOption(_ coder: NSCoder) -> OptionViewController? {
        
        if let row = tableView.indexPathForSelectedRow?.row {
            return OptionViewController(coder: coder, drinkMenu: drinkMenus[row])
        } else {
            return nil
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinkMenus.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkMenuTableViewCell.self)", for: indexPath) as! DrinkMenuTableViewCell
        
        let drinkMenu = drinkMenus[indexPath.row]
        cell.nameLabel.text = drinkMenu.fields.drinkName
        cell.lPriceLabel.text = drinkMenu.fields.largePrice
        cell.mPriceLabel.text = drinkMenu.fields.mediumPrice
        
        URLSession.shared.dataTask(with: drinkMenu.fields.drinkImage[0].url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.drinkImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
