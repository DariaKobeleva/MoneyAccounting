//
//  ViewController.swift
//  MoneyAccounting
//
//  Created by Vladimir Dmitriev on 05.03.24.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var incomeLabel: UILabel!
    @IBOutlet var targetIncomeLabel: UILabel!
    @IBOutlet var expenseLabel: UILabel!
    @IBOutlet var targetExpenseLabel: UILabel!
    
    @IBOutlet var whiteView: UIView!
    @IBOutlet var greyView: UIView!
    
    @IBOutlet var categoriesTableView: UITableView!
    
    // MARK: - Private Properties
    private let categories = CategoriesStore.shared
    private let transactions = TransactionStore.shared
    
    // MARK: - View Life Cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tim Cook"
        
        balanceLabel.text = String(format: "%.2f", transactions.totalBalance())
        
        //FIXME: - add methods for all income and all expence
        
        incomeLabel.text = "1000"
        expenseLabel.text = "2000"
        
        categoriesTableView.rowHeight = 50
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        whiteView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        greyView.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = categoriesTableView.indexPathForSelectedRow else { return }
        
        //FIXME: - add selectedSegmentIndex
        
        switch segue.identifier {
        case "toCategoryVC":
            let selectedCategory = categories.categories[indexPath.row]
            if let categoryVC = segue.destination as? CategoryViewController {
                categoryVC.category = selectedCategory
            }
        case "toHistoryVCIncome":
            if let destinationVC = segue.destination as? HistoryViewController {
//                destinationVC.selectedSegmentIndex = 0
            }
        case "toHistoryVCExpense":
            if let destinationVC = segue.destination as? HistoryViewController {
//                destinationVC.selectedSegmentIndex = 1
            }
        default: break
        }
        
    }
    
    // MARK: - Public Methods
    @objc func leftButtonTapped() {
        let storyboard = UIStoryboard(name: "Person", bundle: nil)
        let personVC = storyboard.instantiateViewController(
            withIdentifier: "PersonViewController"
        ) as! PersonViewController
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(
            withIdentifier: "SettingsViewController"
        ) as! SettingsViewController
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    // MARK: - IB Actions
    @IBAction func showHistoryTapped(_ sender: UIButton) {
        if sender.tag == 0 {
                performSegue(withIdentifier: "toHistoryVCIncome", sender: nil)
            } else if sender.tag == 1 {
                performSegue(withIdentifier: "toHistoryVCExpense", sender: nil)
            }
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func setupBackground() {
        let backgroundImage = UIImage(named: "backgroundMain")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = backgroundImage
        imageView.clipsToBounds = true
        
        view.insertSubview(imageView, at: 0)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: nil,
            action: nil
        )
        
        // FIXME: - настройки для отображения фото в левой кнопке
        
//        let personButton = UIButton(type: .system)
//        personButton.setImage(
//            UIImage(named: "tc")?.withRenderingMode(.alwaysTemplate),
//            for: .normal
//        )
//        personButton.imageView?.contentMode = .scaleAspectFit
//        personButton.contentVerticalAlignment = .fill
//        personButton.contentHorizontalAlignment = .fill
//        personButton.addTarget(
//            self,
//            action: #selector(leftButtonTapped),
//            for: .touchUpInside
//        )
//                
//        let leftButton = UIBarButtonItem(customView: personButton)
//        
//        navigationItem.leftBarButtonItem = leftButton
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: #selector(leftButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.categories.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        
        let categoryCell = cell as? CategoryViewCell
        let category = categories.categories[indexPath.row]
        
        categoryCell?.categoryLabel.text = category.name
        
        let amountCategory = transactions.totalAmount(for: category, transactions: transactions.getAllTransactions())
        categoryCell?.amountCategoryLabel.text = "\(amountCategory) ₽"
        
        categoryCell?.gradientImageView.image = UIImage(named: category.colorImage)
        categoryCell?.iconImageView.image = UIImage(systemName: category.icon)
        categoryCell?.iconImageView.tintColor = .white
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundColorView
    }
    
}
