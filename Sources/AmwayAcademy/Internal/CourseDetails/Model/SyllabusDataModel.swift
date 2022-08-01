
/*
*
* FileName: SyllabusData.swift
* CreatedOn: Thursday, March 3rd 2022
* CreatedBy: Maverick's Parser
* Ready to Use. Pass dictionary response to ParentModel init(response: [String : Any]) to configure all the sub-Models.
*
*/

import Foundation 


struct SyllabusData {

var id : Int = -1
var title : String = ""
var subtitle : String = ""

init() {}

init(response : [String : Any]) {

if let id = response["id"] as? Int {
    self.id = id 
} 
 
if let title = response["title"] as? String {
    self.title = title 
} 
 
if let subtitle = response["subtitle"] as? String {
    self.subtitle = subtitle 
} 
 
}
}