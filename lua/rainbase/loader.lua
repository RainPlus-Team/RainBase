if not WaitForRainBase then
    RBWaitList = {}
    function WaitForRainBase(callback)
        table.insert(RBWaitList, callback)
    end
end