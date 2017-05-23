local cjson = require("cjson")

ngx.req.read_body()

local data = ngx.req.get_body_data()
ngx.log(ngx.INFO, data)

if data then
  local value = cjson.new().decode(data)
  if type(value) == 'table' then
    for k,v in ipairs(value) do
      for key, value in pairs(v) do
        ngx.log(ngx.INFO, key .. " " .. value)
        local command = "zabbix_sender -z localhost -p 8080 -s \"host\" -k " .. key
          .. " -o " .. value
        local handle = io.popen(command)
        local result = handle:read("*a")
        handle:close()
        ngx.log(ngx.INFO, result)
        ngx.say(result)
      end
    end
    ngx.exit(ngx.HTTP_OK)
  end
end

ngx.exit(ngx.HTTP_BAD_REQUEST)
