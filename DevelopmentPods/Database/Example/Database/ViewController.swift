//
//  ViewController.swift
//  WMDatabaseModules
//
//  Created by yangkejun on 12/07/2021.
//  Copyright (c) 2021 yangkejun. All rights reserved.
//

import UIKit
import Database

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DBManager.shared.createTable(DAppDatabase.DApp_table, of: DAppDatabase.self)
        
        var dapp = DAppDatabase()
        dapp.title = "title222"
        dapp.collect = true
        dapp.DAppUrl = "12kfhadkj"
        
        DBManager.shared.insert(intoTable: DAppDatabase.DApp_table, objects: [dapp])
        
        var object: DAppDatabase? = DBManager.shared.queryOne(fromTable: DAppDatabase.DApp_table,
                                                              where: DAppDatabase.Properties.DAppUrl == dapp.DAppUrl!)
        
        object?.imageUrl = "https://32fdjlkfs"
        
        DBManager.shared.insertOrReplace(intoTable: DAppDatabase.DApp_table, objects: [object!])
        
        let _: [DAppDatabase]? = DBManager.shared.query(fromTable: DAppDatabase.DApp_table,
                                                        where: DAppDatabase.Properties.DAppUrl == dapp.DAppUrl!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

