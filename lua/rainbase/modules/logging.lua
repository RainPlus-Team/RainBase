RainBase.Logging = {}

local function getTime()
    return os.date("%H:%M:%S")
end

local function handleMsg( ... )
    local msgs = { ... }
    for i, v in ipairs(msgs) do
        msgs[i] = IsColor(v) and v or tostring(v)
    end
    return msgs
end

local function formatCaller(calr)
    if calr == nil then return nil end
    local splt = string.Split(calr.short_src, "/")
    local src = splt[#splt]
    local line = calr.currentline
    return src .. ":" .. line
end

local function output(mClr, mType, caller, msgs)
    local rClr = SERVER and Color(156, 241, 255, 200) or Color(255, 241, 122, 200)
    table.insert(msgs, "\n")
    MsgC(rClr, SERVER and "<SRV>" or "<CLNT>", Color(102, 204, 255), " [RB] ", Color(255, 157, 0), "(" .. (caller or "unknown") .. ") ", Color(102, 204, 255), getTime(), mClr, " [" .. mType .. "] ", Color(255, 255, 255), unpack(msgs))
end

function RainBase.Logging.Info( ... )
    output(Color(0, 0, 255), "INFO", formatCaller(debug.getinfo(2)), handleMsg( ... ))
end

function RainBase.Logging.Warn( ... )
    output(Color(255, 225, 0), "WARN", formatCaller(debug.getinfo(2)), handleMsg( ... ))
end

function RainBase.Logging.Error( ... )
    output(Color(238, 0, 0), "ERROR", formatCaller(debug.getinfo(2)), handleMsg( ... ))
end

function RainBase.Logging.Debug( ... )
    if not RainBase.ConVars.Debug:GetBool() then
        return
    end
    output(Color(184, 184, 184), "DBG", formatCaller(debug.getinfo(2)), handleMsg( ... ))
end