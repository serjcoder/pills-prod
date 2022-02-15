//
//  PillsViewController.swift
//  pills-prod
//
//  Created by Sergei Ivchenko on 07.02.2022.
//

import UIKit
import CoreData

class PillsViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var table: UITableView!
    
    private var pills: Pills?
    private var pilsListSaved: [NSManagedObject] = []
    private let mainUrlString = "https://api.pills-prod.sdh.com.ua/v1/medicine/?format=json&page=1"
    private let searchUrlString = "https://api.pills-prod.sdh.com.ua/v1/medicine/?format=json&search="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showReceivedResult(urlString: mainUrlString)
    }
    
    private func showReceivedResult(urlString:String) {
        NetworkService.shared.fetchTraks(urlString: urlString) { [self] searchResponse in
            if searchResponse != nil {
                pills = searchResponse
                if pills?.count == 0{
                    alertNoSearchResult()
                    self.searchBar.becomeFirstResponder()
                }
                table.reloadData()
            } else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pill")
                do {
                    pilsListSaved = try managedContext.fetch(fetchRequest)
                    if pilsListSaved.isEmpty {
                        alertNoDataToShow()
                    } else {
                        alertNoDataResiver()
                    }
                    table.reloadData()
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PillsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pills != nil {
            return pills?.pillsList.count ?? 0
        } else if pilsListSaved.count > 0 {
            return pilsListSaved.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        if pills != nil {
            cell.tradeLabel.text = pills?.pillsList[indexPath.row].tradeLabel.name
            cell.manufacturerName.text = pills?.pillsList[indexPath.row].manufacturer?.name
        } else {
            let pill = pilsListSaved[indexPath.row]
            cell.tradeLabel.text = pill.value(forKeyPath: "trade") as? String
            cell.manufacturerName.text = pill.value(forKeyPath: "manufactured") as? String
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "viewItemPill" else { return }
        guard let destination = segue.destination as? ItemPillViewController else { return }
        guard let indexPath = table.indexPathForSelectedRow else { return }
        if let pill = pills?.pillsList[indexPath.row] {
            destination.trade = pill.tradeLabel.name
            destination.manufactured = pill.manufacturer?.name ?? ""
            destination.packagengDescription = pill.packaging.packagingDescription
            destination.compositionDescript = pill.composition.compositionDescription
            destination.compositionInn = pill.composition.inn.name
            destination.сompositionPharmForm = pill.composition.pharmForm.name
        } else {
            let pill = pilsListSaved[indexPath.row]
            destination.trade = pill.value(forKeyPath: "trade") as? String ?? ""
            destination.manufactured = pill.value(forKeyPath: "manufactured") as? String ?? ""
            destination.packagengDescription = pill.value(forKeyPath: "packagengDescription") as? String ?? ""
            destination.compositionDescript = pill.value(forKeyPath: "compositionDescript") as? String ?? ""
            destination.compositionInn = pill.value(forKeyPath: "compositionInn") as? String ?? ""
            destination.сompositionPharmForm = pill.value(forKeyPath: "compositionPharmForm") as? String ?? ""
            destination.saveButtonDisabled = true
        }
    }
}

extension PillsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        let searchPill:String = self.searchBar.text?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
        let urlString:String = searchUrlString + searchPill
        showReceivedResult(urlString: urlString)
    }
}

extension PillsViewController {
    
    private func alertNoSearchResult() {
        let alertController = UIAlertController(title: "Не знайдено препарату", message: "спробуйте інакше", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Добре", style: .default , handler: { _ in
            self.searchBar.becomeFirstResponder()
        }))
        alertController.addAction(UIAlertAction(title: "Нi", style: .cancel, handler: { _ in
            self.showReceivedResult(urlString: self.mainUrlString)
            self.dismissKeyboard()
            self.searchBar.text = nil
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func alertNoDataResiver() {
        let alertController = UIAlertController(title: "Відсутній доступ до інтернету", message: "будуть показані збережені препарати", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Добре", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    private func alertNoDataToShow() {
        let alertController = UIAlertController(title: "Відсутній доступ до інтернету", message: "зберігайте препарати для офлайн доступу", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Добре", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}
