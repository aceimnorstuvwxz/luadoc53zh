--[[
node�����ݽṹ
node.elements ����
node.size() ���ش�С
]]--

--����һ���ն�
function build()
    local h = {}
    h.elements = {}
    h.size = 0
    return h
end

--����в���һ��Ԫ��
function insert(h,v)
    --�ŵ�������ǣ�ע��elemtns��1��ʼ
    h.elements[h.size + 1] = v
    h.size = h.size + 1
    
    local now = h.size
    local up = now // 2
    while(true) do
        if now == 1 then break end
        if h.elements[up] > h.elements[now] then
            h.elements[up], h.elements[now] = h.elements[now], h.elements[up]
        end
        now = up
        up = now //2
    end
end

--��ȡ�Ѷ�Ԫ�ص�ֵ
function get(h)
    if h.size >0 then
        return h.elements[1]
    else
        return nil
    end
end

--ɾ���Ѷ�Ԫ�أ����ضԶ�Node��value
function delete(h)
    if h.size <= 0 then
        return nil
    end
    
    local res = h.elements[1]
    --������ĩԪ�طŵ�����
    h.elements[1] = h.elements[h.size]
    h.size = h.size - 1
    --����
    local now = 1
    local fcheck = function(up,down)
        if down > h.size then
            return true
        end
        if h.elements[down] >= h.elements[up] then
            return true
        end
        return false
    end
    while(true) do
        local left = now * 2
        local right = left + 1
        if left > h.size and right > h.size then
            break
        elseif right > h.size then
            if h.elements[left] < h.elements[now] then
                h.elements[left], h.elements[now] = h.elements[now], h.elements[left]
                now = left
            else
                break
            end
        else
            if h.elements[now] <= math.min(h.elements[left], h.elements[right]) then
                break
            else
                local which = 0
                if h.elements[left] < h.elements[right] then
                    which = left
                else
                    which = right
                end
                h.elements[which], h.elements[now] = h.elements[now], h.elements[which]
                now = which
            end
        end
    end
    return res
end

function display(h)
    for i = 1, h.size, 1 do
        print(h.elements[i])
    end
end

function test()
    local h = build()
    local cnt = 100
    for i = 1,cnt,1 do
        insert(h, math.random(1,100000))
    end
    print("-----")
    display(h)
    print("-----")
    for i = 1,cnt,1 do
        print(delete(h))
    end
    print("-----")
    display(h)
end

test()