//
//  FiltersViewController.swift
//  Yep
//
//  Created by Angela Yu on 9/19/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import AIFlatSwitch

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, RadioCellDelegate {
    
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var dealsSwitch: UISwitch!
    @IBOutlet weak var bestSortSwitch: UISwitch!
    @IBOutlet weak var distanceSortSwitch: UISwitch!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    struct Section {
        var name: String
        var collapsed: Bool
        var items: [String]
        var selected: Int
        
        init(name: String, collapsed: Bool = false, items: [String], selected: Int) {
            self.name = name
            self.collapsed = collapsed
            self.items = items
            self.selected = selected
        }
    }
    
    var filterLabels = [Section]()
    
    var categories: [[String: String]]!
    var catNames: [String] = [""]
    var switchStates: [IndexPath: Bool] = [IndexPath: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate the filter labels
        filterLabels = [
            Section(name: "Deals", collapsed: false, items: ["Offering a Deal"], selected: 0),
            Section(name: "Sort By", collapsed: true, items: ["Best Match", "Distance", "Rating"], selected: 0),
            Section(name: "Distance", collapsed: true, items:["Best Match", "0.3 miles", "1 mile", "3 miles", "5 miles", "20 miles"], selected: 0),
            Section(name: "Cuisine", collapsed: false, items: [], selected: 0)
        ]
        switchStates[[1,0]] = true
        switchStates[[2,0]] = true
        
        // Populate the Cuisine categories
        categories = yelpCategories()
        filterLabels[3].items = [""]
        catNames = []
        for (category) in categories {
            catNames.append(category["name"]!)
        }
        filterLabels[3].items = catNames
        
        // Tableview delegate pattern
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TableView Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterLabels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterLabels[section].collapsed ? 1 : filterLabels[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1, 2:
            let cell = filtersTableView.dequeueReusableCell(withIdentifier: "RadioCell", for: indexPath) as! RadioCell
            if filterLabels[indexPath.section].collapsed {
                let selected = filterLabels[indexPath.section].selected
                cell.radioLabel?.text = filterLabels[indexPath.section].items[selected]
                guard let selectedState = switchStates[[indexPath.section, selected]] else {
                    cell.radioSwitch.setSelected(false, animated: false)
                    return cell
                }
                cell.radioSwitch.setSelected(selectedState, animated: false)
                
            } else {
                cell.radioLabel?.text = filterLabels[indexPath.section].items[indexPath.row]
                guard let selectedState = switchStates[indexPath] else {
                    cell.radioSwitch.setSelected(false, animated: false)
                    return cell
                }
                cell.radioSwitch.setSelected(selectedState, animated: false)
            }
            cell.delegate = self
            
            return cell
        default:
            let cell = filtersTableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            let filtersInSection = filterLabels[indexPath.section].items
            cell.switchLabel?.text = filtersInSection[indexPath.row]
            cell.delegate = self
            
            cell.onSwitch.isOn = switchStates[indexPath] ?? false
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FiltersHeaderView()
        
        header.textLabel?.text = filterLabels[section].name
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Cell Delegate Functions
    func switchCellToggled(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)!
        
        switchStates[indexPath] = value
    }
    
    func radioCellTapped(radioCell: RadioCell) {
        let indexPath = filtersTableView.indexPath(for: radioCell)!
        
        let rowCount = filterLabels[indexPath.section].items.count
        for row in 0..<rowCount {
            switchStates[[indexPath.section, row]] = false
        }
        switchStates[indexPath] = true
        filterLabels[indexPath.section].selected = indexPath.row
        filterLabels[indexPath.section].collapsed = !filterLabels[indexPath.section].collapsed
        filtersTableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.bottom)
    }
    
    // Process interactions
    func filtersFromTableData() -> Filters {
        let ret = Filters()
        
        // Grab the selected categories
        var selectedCategories = [String]()
        print("\(switchStates)")
        
        for (indexPathKey, isSelected) in switchStates {
            switch indexPathKey.section {
            case 0:
                ret.deals = isSelected
                break
            case 1:
                if isSelected {
                    let row = indexPathKey.row
                    switch row {
                    case 1:
                        ret.sort = YelpSortMode.distance
                        break
                    case 2:
                        ret.sort = YelpSortMode.highestRated
                        break
                    default:
                        ret.sort = YelpSortMode.bestMatched
                        break
                    }
                }
                break
            case 2:
                if isSelected {
                    let row = indexPathKey.row
                    switch row {
                    case 1:
                        ret.distance = 482
                        break
                    case 2:
                        ret.distance = 1609
                        break
                    case 3:
                        ret.distance = 8047
                        break
                    case 4:
                        ret.distance = 32187
                        break
                    default:
                        ret.distance = nil
                        break
                    }
                }
                break
            case 3:
                if isSelected {
                    let row = indexPathKey.row
                    selectedCategories.append(categories[row]["code"]!)
                }
                break
            default:
                print("no section matched")
            }
        }
        
        if selectedCategories.count > 0 {
            ret.categories = selectedCategories
        }
        
        print("filtersFromTableData called")
        return ret
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        var filters = Filters()
        filters = self.filtersFromTableData()
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }
    
}
