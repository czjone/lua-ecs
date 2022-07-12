local core_table_extention_test = class(xlib.core.test_base)

function core_table_extention_test:ctor(test)
    self._test = test
    self.name = "table extention test"
end

function core_table_extention_test:execute()
    local tb = {}
    table.insert(tb,"a")    
    table.insert(tb,"b")    
    table.insert(tb,"c")    
    table.insert(tb,"d")    
    table.insert(tb,"e")    
    
    -- test index of
    local pos,val = table.index_of(tb,"c")
    
    -- teset remove_item
    local remove_tag = "e"
    table.remove_item(tb,remove_tag)
    local after_remove_pos,after_remove_val = table.index_of(tb,remove_tag)

    -- test remove all
    table.remove_all_for_array(tb,remove_tag)

    -- return test result
    return 
        pos == 3 
        and after_remove_pos == -1 
        and #tb == 0
end

return core_table_extention_test;