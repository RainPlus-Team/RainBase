if CLIENT then
    RainBase.UI = {}

    local builderMeta = {
        __index = function(tbl, key)
            local control = tbl:VGUI()
            if control then
                local tgt = control[key]
                if type(tgt) == "function" then
                    local wrapper = function( ... )
                        local tbl = { ... }
                        table.remove(tbl, 1)
                        tgt(control, unpack(tbl))
                    end
                    return wrapper
                end
                return tgt
            else
                return nil
            end
        end,
        __newindex = function(tbl, key, val)
            if tbl[key] ~= nil then
                tbl[key] = val
            else
                local control = tbl:VGUI()
                control[key] = val
            end
        end
    }
    
    local builderPropSetters = {
        Parent = function(slf, parent)
            if IsValid(parent) then
                slf:VGUI():SetParent(parent)
            end
            return slf:VGUI():GetParent()
        end,
        Pos = function(slf, x, y)
            if x ~= nil and y ~= nil then
                slf:VGUI():SetPos(x, y)
            end
            return slf:VGUI():GetPos()
        end,
        X = function(slf, x)
            if x ~= nil then
                slf:VGUI():SetX(x)
            end
            return slf:VGUI():GetX()
        end,
        Y = function(slf, y)
            if y ~= nil then
                slf:VGUI():SetY(y)
            end
            return slf:VGUI():GetY()
        end,
        Size = function(slf, wide, tall)
            if wide ~= nil and tall ~= nil then
                slf:VGUI():SetSize(wide, tall)
            end
            return slf:VGUI():GetSize()
        end,
        Wide = function(slf, wide)
            if wide ~= nil then
                slf:VGUI():SetWide(wide)
            end
            return slf:VGUI():GetWide()
        end,
        Tall = function(slf, tall)
            if tall ~= nil then
                slf:VGUI():SetTall(tall)
            end
            return slf:VGUI():GetTall()
        end,
        Color = function(slf, clr)
            if clr then
                slf:VGUI():SetColor(clr)
            end
            return slf:VGUI():GetColor()
        end
    }

    local function UIBuilder(vpanel)
        if not IsValid(vpanel) then return false end
        local builder = {
            VGUI = function(slf)
                --return slf._VGUI_TREE_[#slf._VGUI_TREE_]
                return slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_] || slf._ROOT_
            end,
            Use = function(slf, index)
                slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_] = slf._VGUI_TREE_[slf._CHILDREN_LAYER_][index]
            end,
            AddChild = function(slf, child)
                local c = child
                if type(c) == "string" then
                    c = vgui.Create(c)
                end
                if not IsValid(c) then
                    return false
                end

                -- Add child to the tree
                if slf._VGUI_TREE_[slf._CHILDREN_LAYER_] == nil then
                    slf._VGUI_TREE_[slf._CHILDREN_LAYER_] = {}
                end
                local index = table.insert(slf._VGUI_TREE_[slf._CHILDREN_LAYER_], c)

                -- Set as active
                slf:Use(index)

                -- Set parent
                slf:Parent(slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_ - 1])
            end,
            BeginChildren = function(slf)
                slf._CHILDREN_LAYER_ = slf._CHILDREN_LAYER_ + 1
            end,
            EndChildren = function(slf)
                slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_] = nil
                slf._CHILDREN_LAYER_ = slf._CHILDREN_LAYER_ - 1
            end
        }
        builder = table.Merge(builder, builderPropSetters)
        builder._VGUI_TREE_ = { vpanel }
        builder._ROOT_ = vpanel
        builder._CHILDREN_LAYER_ = 1
        builder._LAYER_ACTIVE_PANELS_ = { vpanel }
        setmetatable(builder, builderMeta)
        return builder
    end

    function RainBase.UI.CreateBuilder(classname)
        if not classname or classname == "_HUD_" then
            return UIBuilder(GetHUDPanel())
        else
            local vpanel = vgui.Create(classname)
            if IsValid(vpanel) then
                return UIBuilder(vpanel)
            else
                return false
            end
        end
    end
end