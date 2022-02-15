//
//  ItemPillViewController.swift
//  pills-prod
//
//  Created by Sergei Ivchenko on 08.02.2022.
//

import UIKit
import CoreData

class ItemPillViewController: UIViewController {
    
    @IBOutlet private weak var tradeLabel: UILabel!
    @IBOutlet private weak var manufacturedLabel: UILabel!
    @IBOutlet private weak var packagengDescriptionLabel: UILabel!
    @IBOutlet private weak var compositionDescriptLabel: UILabel!
    @IBOutlet private weak var compositionInnLabel: UILabel!
    @IBOutlet private weak var сompositionPharmFormLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBAction private func saveButtonTap(_ sender: Any) {
        disabledSaveButton()
        save()
    }
    @IBAction private func closeButton(_ sender: Any) {
        guard self.presentingViewController != nil else { return }
        self.presentingViewController?.dismiss(animated: true )
    }
    
    var pills:[NSManagedObject] = []
    var trade = String()
    var manufactured = String()
    var packagengDescription = String()
    var compositionDescript = String()
    var compositionInn = String()
    var сompositionPharmForm = String()
    var saveButtonDisabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tradeLabel.text = trade
        manufacturedLabel.text = manufactured
        packagengDescriptionLabel.text = "Опис пакування: \(packagengDescription)"
        compositionDescriptLabel.text = "Склад препарату: \(compositionDescript)"
        compositionInnLabel.text = "Діюча речовина: \(compositionInn)"
        сompositionPharmFormLabel.text = "Фармакологічна форма: \(сompositionPharmForm)"
        tradeLabel.sizeToFit()
        manufacturedLabel.sizeToFit()
        packagengDescriptionLabel.sizeToFit()
        compositionDescriptLabel.sizeToFit()
        compositionInnLabel.sizeToFit()
        сompositionPharmFormLabel.sizeToFit()
        if saveButtonDisabled {
            disabledSaveButton()
        }
    }
    
    private func disabledSaveButton() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = .lightGray
    }
    
    private func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Pill", in: managedContext) else { return }
        let pill = NSManagedObject(entity: entity, insertInto: managedContext)
        pill.setValue(trade, forKeyPath: "trade")
        pill.setValue(manufactured, forKeyPath: "manufactured")
        pill.setValue(packagengDescription, forKeyPath: "packagengDescription")
        pill.setValue(compositionDescript, forKeyPath: "compositionDescript")
        pill.setValue(compositionInn, forKeyPath: "compositionInn")
        pill.setValue(сompositionPharmForm, forKeyPath: "compositionPharmForm")
        do {
            pills.append(pill)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
