//
//  FormSegueDescriptor.swift
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

open class FormSegueDescriptor:FormRowDescriptor{
    
    fileprivate var _segue:String;
    open var segue:String{
        return _segue;
    }
    
    
    public init(title:String,segue:String){
        self._segue = segue;
        super.init(title: title, name: "");
    }
    
    public init(title:String,imageName:String,segue:String){
        self._segue = segue
        
        super.init(title: title, imageName:imageName, name:"")
    }
    
    public init(title:String,imageName:String,count:String ,segue:String){
        self._segue = segue
        
        super.init(title: title, imageName:imageName, name:"")
    }
    
    override open func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormSegueCell.self;
    }
}
