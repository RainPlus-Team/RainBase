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
        if rawget(tbl, key) ~= nil then
            rawset(tbl, key, val)
        else
            local control = tbl:VGUI()
            control[key] = val
        end
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
            RainBase.Logging.Debug("Change active panel to ", slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_])
        end,
        AddChild = function(slf, child)
            local parent = slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_ - 1]
            local c = child
            if type(c) == "string" then
                c = parent.Add and parent:Add(c) or vgui.Create(c)
                RainBase.Logging.Debug("Created a new panel for child ", child)
                if not parent.Add then
                    c:SetParent(parent)
                end
            elseif ispanel(c) and parent.Add then
                parent:Add(c)
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
        end,
        BeginChildren = function(slf)
            slf._CHILDREN_LAYER_ = slf._CHILDREN_LAYER_ + 1
            RainBase.Logging.Debug("Current children layer: ", slf._CHILDREN_LAYER_)
        end,
        EndChildren = function(slf)
            slf._LAYER_ACTIVE_PANELS_[slf._CHILDREN_LAYER_] = nil
            slf._CHILDREN_LAYER_ = slf._CHILDREN_LAYER_ - 1
            RainBase.Logging.Debug("Current children layer: ", slf._CHILDREN_LAYER_)
        end
    }
    builder._VGUI_TREE_ = { vpanel }
    builder._ROOT_ = vpanel
    builder._CHILDREN_LAYER_ = 1
    builder._LAYER_ACTIVE_PANELS_ = { vpanel }
    setmetatable(builder, builderMeta)
    RainBase.Logging.Debug("UI builder for ", vpanel, " has been created.")
    return builder
end

function RainBase.UI.CreateBuilder(source)
    if not source then
        return UIBuilder(GetHUDPanel())
    else
        if type(source) == "string" then
            source = vgui.Create(source)
        end
        if ispanel(source) then
            return UIBuilder(source)
        else
            return false
        end
    end
end