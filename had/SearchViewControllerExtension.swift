//
//  SearchViewControllerExtension.swift
//  had
//
//  Created by chrisdegas on 07/11/2015.
//  Copyright © 2015 had. All rights reserved.
//

import Foundation
/*
extension SearchViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let isEmpty = searchController.searchBar.text?.isEmpty
        if(isEmpty == false){
            let textSearch = searchController.searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
            self.searchArray.removeAll()
            QServices.post("POST", params:["object":"object"], url: "https://hadrink.herokuapp.com/search/places/"+textSearch!){
                (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                
                let locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
                
                if let reposArray = obj["searchlist"] as? [NSDictionary]  {
                    //println("ReposArray \(reposArray)")
                    
                    for item in reposArray {
                        self.searchArray.append(PlaceItem(json: item, userLocation : locationDictionary))
                        //println("Item \(item)")
                        print("has Item")
                    }
                    
                }
                print("reload")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData.reloadData()
                    print("nbSectiontebleview")
                    print(self.tableData.numberOfSections)
                })
                
            }
        }
    }
}
*/