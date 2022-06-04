RainBase.Logging = {}

local function getTime()
    return os.date("%H:%M:%S")
end

local function handleMsg( ... )
    local msgs = { ... }
    for i, v in ipairs(msgs) do
        msgs[i] = tostring(v)
    end
    return unpack(msgs)
end

local function output(mClr, mType, ...)
    local rClr = SERVER and Color(156, 241, 255, 200) or Color(255, 241, 122, 200)
    MsgC(rClr, SERVER and "<SRV>" or "<CLNT>", Color(102, 204, 255), " [RB] ", getTime(), mClr, " [" .. mType .. "] ", Color(255, 255, 255), ..., "\n")
end

function RainBase.Logging.Info( ... )
    output(Color(0, 0, 255), "INFO", handleMsg( ... ))
end

function RainBase.Logging.Warn( ... )
    output(Color(255, 225, 0), "WARN", handleMsg( ... ))
end

function RainBase.Logging.Error( ... )
    output(Color(238, 0, 0), "ERROR", handleMsg( ... ))
end

function RainBase.Logging.Debug( ... )
    output(Color(184, 184, 184), "DBG", handleMsg( ... ))
end