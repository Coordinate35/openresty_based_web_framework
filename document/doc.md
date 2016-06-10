# 基于openresty的一个简单web框架

## 类库参考

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
local helper = loadfile(ngx.var.root .. "/system/helper/global_helper.lua")()
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
