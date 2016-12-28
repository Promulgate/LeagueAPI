//
//  ChampionView.swift
//  LeagueAPI
//
//  Created by Eric Chang on 12/27/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit

class ChampionView: UIView {

    @IBOutlet weak var championImageView: UIImageView!
    @IBOutlet weak var championNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
