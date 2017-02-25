-- 引入相关库
local template = require("resty.template")
local json = require("cjson")
local api = require("stuq.httpapi")

--从配置里取数据
local APP_URL = "http://www.stuq.org"

local config = {
    APP_ENV = "development",
    APP_URL = APP_URL,
    app = {
        title = "StuQ--lua测试",
        description = "欢迎访问StuQ",
        keywords = "stuq,geekbang",
    }
}
local requestdata = {
    skill_id = 0,
    category_id = 5,
}

-- api获取数据
local content = api.request("GET", "content?cats=index_title,index_notice")
local titles = content["index_title"]["data"]
local notices = content["index_notice"]["data"]

content = api.request("GET", "content?need_body=1&cats=index_subscribe,index_theysay")
local subscribes = content["index_subscribe"]["data"]
local theysays = content["index_theysay"]["data"]

local skills = api.request("GET", "skill")
local skill_colors = {"#ffaf3e", "#f44848", "#ff7849", "#ff7849", "#ffaf3e", "#f44848"}
for i,skill in pairs(skills) do
    skills[i]["link"] = APP_URL.."/course?category_id="..skill["id"]
    skills[i]["color"] = skill_colors[i%6]
end

local categories = api.request("GET", "category?is_in_index=1")
local cate_colors = {"#f44848", "#ff7849", "#ffaf3e", "#f44848", "#f44848", "#ffaf3e"}
for i,category in pairs(categories) do
    categories[i]["link"] = APP_URL.."/course?category_id="..category["id"]
    categories[i]["color"] = cate_colors[i%6]
end

local companies = api.request("GET", "company?is_in_index=1")

local teachers = api.request("GET", "teacher?is_in_index=1&is_public=1")


local data = {
    config = config,
    requestdata = requestdata,
    titles = titles,
    notice = notices,
    subscribes = subscribes,
    theysays = theysays,
    skills = skills,
    categories = categories,
    teachers = teachers,
    companys = companies,
}

--ngx.say(json.encode(data))

-- 渲染模板
template.render("main.html", data)

