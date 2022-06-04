RainBase.Web = {}

function RainBase.Web.SimpleDownloadFile(url, path, callback)
    http.Fetch(url, function(body, size, headers, code)
        file.Write(path, body)
        if callback then
            xpcall(callback, function(err)
                RainBase.Logging.Warn("Failed to call SimpleDownloadFile callback.", err)
            end, size, headers, code)
        end
    end)
end

function RainBase.Web.DownloadFile(pararmeters, path, callback)
    local succ = pararmeters.success
    local para = table.Merge(pararmeters, {
        success = function(code, body, headers)
            file.Write(path, body)
            if succ then
                xpcall(succ, function(err)
                    RainBase.Logging.Warn("Failed to call DownloadFile HTTP success.", err)
                end, code, body, headers)
            end
            if callback then
                xpcall(callback, function(err)
                    RainBase.Logging.Warn("Failed to call DownloadFile callback.", err)
                end, true, string.len(body))
            end
        end
    })
    HTTP(para)
end