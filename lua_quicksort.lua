--¿ìËÙÅÅÐò£¬Ã°ÅÝÅÅÐò

function qsa(d,s,e)
    if (s >= e) then return end
    local v = d[e]
    local i = s
    local j = e - 1
    while (i<=j) do
        if (d[i] <= v) then
            i = i+1
        else
            d[j],d[i] = d[i],d[j]
            j = j - 1
        end
    end
    d[i],d[e] = d[e],d[i]
    qsa(d, s , i - 1)
    qsa(d, i+1, e)
end

function bub(d,s,e)
    for i=e-1,s,-1 do
        for j = s,i,1 do
            if d[j] > d[j+1] then
                d[j],d[j+1] = d[j+1],d[j]
            end
        end
    end
end
function qs()
    local ta = {}
    local cnt = 10000
    for i=1, cnt, 1 do
        ta[i] = math.random()
        --print (ta[i])
    end
    print("Start")
    local t1 = os.clock()
    qsa(ta, 1, cnt)
    print("done", os.clock() - t1)
    --[[for i = 1, cnt, 1 do 
        print (ta[i])
    end]]
end

qs()