//
//  ChampionListCollectionViewController.swift
//  LeagueAPI
//
//  Created by Eric Chang on 12/27/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit
import CoreData

// KEY: - RGAPI-3d829713-0fe1-486a-901d-9e5dfbc588d6

class ChampionListCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var fetchedResultsController: NSFetchedResultsController<Champion>!
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private let reuseIdentifier = "ChampionCell"
    private let endpoint = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?api_key=RGAPI-3d829713-0fe1-486a-901d-9e5dfbc588d6"
    private var colView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        colView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(colView)
        colView.delegate   = self
        colView.dataSource = self
        colView.backgroundColor = UIColor.white
        
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        APIRequestManager.manager.getData(endPoint: endpoint) { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]) {
                    if let wholeDict = jsonData as? [String:Any],
                        let records = wholeDict["results"] as? [[String:Any]] {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let pc = appDelegate.persistentContainer
                        pc.performBackgroundTask { (context: NSManagedObjectContext) in
                            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                            
                            for mom in records {
                                
                                let champion = NSEntityDescription.insertNewObject(forEntityName: "Champion", into: context) as! Champion
                                champion.populate(from: mom)
                            }
                            do {
                                try context.save()
                                print("??\n\n\n\n??")
                            }
                            catch let error {
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                self.initializeFetchedResultsController()
                                self.collectionView?.reloadData()
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<Champion> = Champion.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: "name", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
         }
         */
        
        // MARK: UICollectionViewDataSource
        
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard let sections = fetchedResultsController.sections else {
                print("No sections in fetchedResultsController")
                return 0
            }
            let sectionInfo = sections[section]
            
            return sectionInfo.numberOfObjects
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChampionCollectionViewCell
            
            let champion = fetchedResultsController.object(at: indexPath)
            cell.ChampionView.championNameLabel.text = champion.name
            
            APIRequestManager.manager.getData(endPoint: "http://ddragon.leagueoflegends.com/cdn/6.24.1/img/champion/\(champion.name).png") { (returnedData) in
                if let validData = returnedData {
                    DispatchQueue.main.async {
                        cell.ChampionView.championImageView.image = UIImage(data: validData)
                    }
                }
            }
            
            return cell
        }
        
        // MARK: UICollectionViewDelegate
        
        /*
         // Uncomment this method to specify if the specified item should be highlighted during tracking
         override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment this method to specify if the specified item should be selected
         override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
         override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
         
         }
         */
        
}
