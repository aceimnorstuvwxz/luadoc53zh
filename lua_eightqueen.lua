--Eigth Queen
q = {0,0,0,0,0,0,0,0}
count = 0
function valid(index)
    for i = 1, index - 1, 1 do
        for j = i + 1, index -1, 1 do
            if math.abs(i - j) == math.abs(q[i] - q[j]) or q[i] == q[j] then return false end
        end
    end
    return true
end
function eightQueen(index)
    if valid(index) then
        if index == 9 then
            count = count + 1
        else
            for i = 1,8,1 do
                q[index] = i
                eightQueen(index + 1)
            end
        end
    end
end
eightQueen(1)
print (count)
