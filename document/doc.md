# 基于openresty的一个简单web框架

## 类库参考

### 加载模块

框架启动的时候自动加载此类，以后加载代码都适用此类加载
对于没有场景限制的类，无论调用多少次加载函数，都只会加载一次，然后就缓存起来

#### 加载核心函数

load_core(core_name)

参数：core_name(string),核心模块名
返回：table，加载的核心模块

#### 加载辅助函数

load_helper(helper_name)

参数：helper_name(string),辅助函数名
返回：table，加载的辅助函数 

#### 加载类库

load_library(library_name)

参数：library_name(string),类库名
返回：table，加载的类库

#### 加载语言集合

load_lang(lang_name)

参数：lang_name(string),语言集合名
返回：table，加载的语言集合

#### 加载数据库类

load_database(database_name)

参数：database_name(string),数据库类名
返回：table，加载的数据库类

#### 加载配置

load_config(config_name)

参数：config_name(string),配置名
返回：table，加载的配置

#### 加载模型

load_model(model_name)

参数：model_name(string),模型名
返回：table，加载的模型

#### 加载服务层

load_service(service_name)

参数：service_name(string),服务层名
返回：table，加载的服务

#### 加载执行阶段

load_stage(stage_name)

参数：stage_name(string)，执行阶段名
返回：table，加载的执行阶段

#### 加载控制器

load_controller(controller_name)

参数：controller_name(string),控制器名
返回：table，加载的控制其

#### 加载视图

load_view(view_name)

参数：view_name(string),加载的视图名
返回：table，加载的视图

### 表单验证模块

使用前需先加载此类，在system/library/Form_validation.lua

```lua
local form_validation = loadfile(ngx.var.root .. "/system/library/Form_validation.lua")()
```

然后传入验证待验证的参数，和要验证的变量

```lua
local result, err = form_validation.check(args, check_item)
```
args是一个字典，键名是待验证的变量名，值是要验证变量的值
check_item是一个字符串形式的逻辑表达式，运算符有|，&，（，）。|，&分别表示或和且。
如果验证通过,result返回true,err返回nil，否则result返回false同时err返回错误信息

例子:

```lua
check_itme = "file_type&user_id&access_token&sex&((audio_class&question_arr)|(video_class&save_key&questions))"
```

check_item推荐写在/application/config/form_check_config.lua中
验证变量时，需先在/application/config/form_check_item_config.lua中写好验证规则，例子
例子：

```lua

local form_check_item_config = {}

form_check_item_config.change_nickname = {
	["field"] = "nickname",
	["label"] = "用户昵称",
	["rules"] = "required|min_length[1]|max_length[30]|is_unique[user.nickname]"
}

return form_check_item_config

```

原生支持的规则

规则名|是否需要参数|描述|例子
--:|:---:|:---:|:---
is_number | 否 | 判断一个参数是否是数字 |
min_length | 是 | 判断一个字符串的长度是否大于某个值 | min_length[3]
max_length | 是 | 判断一个字符串的长度是否小于某个值 | max_length[10]
greater_than_equal_to | 是 | 判断一个数是否大于等于某个值 | greater_than_equal_to[3]
less_than_equal_to | 是 | 判断一个数是否小于等于某个值 | less_than_equal_to[10]
exact_length | 是 | 判断一个字符串的长度是否等于某个值 | exact_length[11]
required | 否 | 判断一个参数是否存在 |

## 辅助函数参考

### 全局辅助函数

使用前需引用

```lua
local helper = loadfile(ngx.var.root .. "/system/helper/Global_helper.lua")()
```

#### 字符串转换成整数

atoi(str)

参数： str(string) 待转化成数字的字符串
返回： 失败的时候返回nil,否则返回一个number类型的变量

例子：

```lua
local str = "23";
local number = helper.atoi(str)
```
#### 字符串拆分成数组

split(str, delimiter)

参数： 
* str(string), 待拆分的字符串
* delimiter(string), 分割符

返回：
失败的时候返回nil,成功的时候返回一个table类型的变量

例子：

```lua
local str = "a|b|c"
local delimiter = "|"
local result = helper.split(str, delimiter)
```
### Json 处理辅助函数

使用前需引用

```lua
local json = loadfile(ngx.var.root .. "/system/helper/Json.lua")()
```

#### 将变量编码成json字符串，当为空时编码成对象

encode_empty_as_object(var)

参数:

* var(mixed),待编码的变量

返回：
失败时返回nil, 成功时返回编码后的json字符串(string)

例子：

```lua
local var = {
	["a"] = "ddd",
	["b"] = "ccc"
}
local result = json.encode_empty_as_object(var)
```

#### 将变量编码成json字符串，当为空时编码成数组

encode_empty_as_array(var)

参数:

* var(mixed),待编码的变量

返回：
失败时返回nil, 成功时返回编码后的json字符串(string)

例子：

```lua
local var = {
	["a"] = "ddd",
	["b"] = "ccc"
}
local result = json.encode_empty_as_array(var)
```

#### 将json字符串解析成变量

decode(str)

参数:

* str(string),待解析的json字符串

返回：
失败时返回nil, 成功时会返回一个解析之后的变量(mixed)