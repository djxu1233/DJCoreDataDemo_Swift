//
//  ViewController.swift
//  DJCoreDataDemo
//
//  Created by minstone.DJ on 2020/3/23.
//  Copyright © 2020 minstone. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [DJBook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "CoreDataDemo"

        self.view.backgroundColor = .white
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        self.fetchDataSource()
        
    }
    
    //managedObjectModel
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        guard let modelURL = Bundle.main.url(forResource: "DJCoreDataDemo", withExtension: "momd") else {
            fatalError("failed to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        return mom
    }()

    
    lazy var persistanceCoordinator : NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "db.sqlite", relativeTo: dirURL)
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: fileURL, options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        return psc
    }()
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistanceCoordinator
        return moc
    }()
    
    func fetchDataSource() {
        let request: NSFetchRequest<DJBook> = DJBook.fetchRequest()
        
        do {
            let resArray = try self.managedObjectContext.fetch(request)
            self.dataSource = resArray
            self.tableView.reloadData()
        } catch  {
            print("Data could not fatched right now")
        }
        
    }

    @IBAction func insertAction(_ sender: Any) {
        print("插入操作")
        
        let bookNames = ["语文", "数学", "英语", "地理", "化学", "物理", "历史", "政治", "生物"]
        
        
        let book = NSEntityDescription.insertNewObject(forEntityName: "DJBook", into: self.managedObjectContext) as! DJBook
        book.name = bookNames[Int(arc4random() % 9)]
        book.price = Int16((arc4random() % 30) + 10)
        book.page = Int16(arc4random() % 100 + 100)
        book.color = 1000// (String.init((arc4random() % 1000), radix: 16, uppercase: true))
        
        print("book === \(book)")
        let fetchRequest: NSFetchRequest<DJBook> = DJBook.fetchRequest()

        do {
            let resArray = try self.managedObjectContext.fetch(fetchRequest)
            
            
            self.dataSource = resArray
            self.tableView.reloadData()
            
             try self.managedObjectContext.save()
            
            print("dataSource == \(dataSource)")
        } catch {
            print("Data could not fatched right now")
        }
        
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        print("删除操作")
        
        let request: NSFetchRequest<DJBook> = DJBook.fetchRequest()
        
        let pre: NSPredicate = NSPredicate.init(format: "price < \(30)")
        
        request.predicate = pre
        
        do {
            let deleteArray = try self.managedObjectContext.fetch(request)
            
            for book in deleteArray {
                self.managedObjectContext.delete(book)
            }
            self.fetchDataSource()

            try self.managedObjectContext.save()
        } catch  {
            fatalError()
        }

        
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        print("更新操作")
        
        let request: NSFetchRequest<DJBook> = DJBook.fetchRequest()
        let pre: NSPredicate = NSPredicate.init(format: "page < \(150)")
        request.predicate = pre
        do {
            let resultArray = try self.managedObjectContext.fetch(request)
            for book in resultArray {
                book.page = 180
            }
            self.fetchDataSource()
            try self.managedObjectContext.save()
        } catch  {
            fatalError()
        }
        
    }
    
    
    @IBAction func queryAction(_ sender: Any) {
        print("查询操作")
        
        let request: NSFetchRequest<DJBook> = DJBook.fetchRequest()
        let pre: NSPredicate = NSPredicate.init(format: "price > 35")
        request.predicate = pre
        
        do {
            let resultArray = try self.managedObjectContext.fetch(request)
            self.dataSource = resultArray
            self.tableView.reloadData()
            
        } catch  {
            fatalError()
        }
        
        
    }
    
    
    @IBAction func sortAction(_ sender: Any) {
        print("排序操作")
        
        let request: NSFetchRequest<DJBook> = DJBook.fetchRequest()
        let priceSort: NSSortDescriptor = NSSortDescriptor.init(key: "price", ascending: true)
        let pageSort: NSSortDescriptor = NSSortDescriptor.init(key: "page", ascending: true)
        request.sortDescriptors = [priceSort, pageSort]
        
        do {
            let resultArray = try self.managedObjectContext.fetch(request)
            self.dataSource = resultArray
            self.tableView.reloadData()
        } catch  {
            fatalError()
        }
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))!
        
        let book: DJBook = self.dataSource[indexPath.row]
        cell.textLabel?.text = " 书名：\(book.name!) \n 价格 = \(book.price) \n 页数 = \(book.page) \n 颜色 = \(book.color)"
        cell.textLabel?.numberOfLines = 0;
        
        cell.textLabel?.textColor = UIColor.random()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

