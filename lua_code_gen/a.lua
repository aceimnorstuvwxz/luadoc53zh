function string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

function print_list(list)
    for i=1, #list, 1 do
        print (list[i])
    end
    print()
end

function format_line_err(list)
    --<string name="tp_cms_err_generic">服务器内部错误</string>
    return string.format([[    <string name="%s">%s</string>]]..'\n', 'tp_cms_err'..(list[2]:sub(6):lower()), list[3])
end

id_index = 0x7f040132

function format_line_id(list)
    --<public type="string" name="tp_cms_err_generic" id="0x7f040132" />
    local res = string.format([[  <public type="string" name="%s" id="0x%x" />]]..'\n', 'tp_cms_err'..(list[2]:sub(6):lower()), id_index)
    id_index = id_index + 1
    return res
end

function format_line_int(list)
    --public static final int ERROR_GENERIC = -10000;
    return string.format([[public static final int %s = %s;]]..'\n', list[2], list[1])
end

function format_line_ret(list)
    --case ERROR_FWID_NOT_SUPPORT_DEVICE: return res.getString(android.R.string.tp_cms_err_fwid_not_support_device);
    return string.format([[case %s: return res.getString(android.R.string.%s);]]..'\n',list[2], 'tp_cms_err'..(list[2]:sub(6):lower()))
end

function a()
    local out_err = io.open("cms_errors_res.txt", "w")
    local out_id = io.open("cms_errors_ids.txt", "w")
    local out_int = io.open("cms_errors_int.txt", "w")
    local out_ret = io.open("cms_errors_ret.txt", "w")
    local f = io.lines("cms_errors.txt")
    while (true) do
        local line = f()
        if (line == nil) then
            break
        end
        local list = string_split(line, '\t')
        out_err:write(format_line_err(list))
        out_id:write(format_line_id(list))
        out_int:write(format_line_int(list))
        out_ret:write(format_line_ret(list))
    end
    out_err:close()
    out_id:close()
    out_int:close()
    out_ret:close()
end


a()