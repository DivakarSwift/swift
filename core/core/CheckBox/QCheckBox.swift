//
//  QCheckBoxs.swift
//  LinCore
//
//  Created by lin on 2/11/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import LinUtil

//public class QCheckBoxs : QCheckBox{
//
//}

private class __QCheckBoxDelegateImpl3 : DelegateAction,QCheckBoxDelegate{
    private var _didSelectedCheckBoxAction:((checkBox:QCheckBox)->())?;
    
    @objc private func didSelectedCheckBox(checkBox: QCheckBox!, checked: Bool) {
        _didSelectedCheckBoxAction?(checkBox: checkBox)
    }
    
    
}


extension QCheckBox{
    
    
    private var actionDelegate:__QCheckBoxDelegateImpl3{
        
        if self.delegate is __QCheckBoxDelegateImpl3{
            return self.delegate as! __QCheckBoxDelegateImpl3;
        }
        
        let da = __QCheckBoxDelegateImpl3();
        self.delegate = da;
        da.withObjectSameLifecycle = self;
        return da;
    }
    
    public var didSelectedCheckBoxAction:((checkBox:QCheckBox)->())?{
        get{
            return actionDelegate._didSelectedCheckBoxAction;
        }
        set{
            actionDelegate._didSelectedCheckBoxAction = newValue;
        }
    }
}