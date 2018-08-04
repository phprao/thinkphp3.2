var host = window.location.host;
shopApi = '';
switch(host){
    case 'localhost':
        shopApi = 'http://localhost/dc_php_xingyun/trunk/dc_web/dc_web_api/';
        break;
    case '192.168.1.210':
        shopApi = 'http://192.168.1.210/dc_web/dc_web_api/';
        break;
    case 'xingyun.dcgames.cn':
        shopApi = 'http://xingyun.dcgames.cn/dc_web/dc_web_api/';
        break;
	case 'xyht.xingyuncity.com':
        shopApi = 'http://xyht.xingyuncity.com/dc_web/dc_web_api/';
        break;	
    default:
}

/*
* ajax请求方法
*/
function post($url,$data,$fun,$before,$complete, $error){
	$.ajax({
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        url:$url,
        type:'post',
        data: $data,
        dataType:'json',
        beforeSend:function(XMLHttpRequest){
            if($before){
                $before();
            }
        },
        success:function(data) {
            // is_login(data);
            $fun(data);

        },
        complete:function(XMLHttpRequest,textStatus){
            if($complete){
                $complete();
            }
        },
        error:function(jqXHR,textStatus,errorThrown){
            if($error){
                $error(jqXHR,textStatus,errorThrown);
            }
        }
    })
}
/*
* get请求方法
*/
function get($url,$data,$fun,$before,$complete, $error){
    if($data){
        $url += '?';
        for(var item in $data){
            $url += item +'='+$data[item]+'&';   
        }
        $url = getLaststring($url);
    }
	$.ajax({
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        url:$url,
        type:'get',
        dataType:'json',
        beforeSend:function(XMLHttpRequest){
            if($before){
                $before();
            }
        },
        success:function(data) {
            // is_login(data);
            $fun(data);
            
        },
        complete:function(XMLHttpRequest,textStatus){
            if($complete){
                $complete();
            }
        },
        error:function(jqXHR,textStatus,errorThrown){
            if($error){
                $error(jqXHR,textStatus,errorThrown);
            }
        }
    })
}
/*
* 图片上传方法A
*/
function uploadImg($ojb,$url,$data,$fun){
    var thisObj = $ojb;
    var allowType = ["gif", "jpeg", "jpg", "bmp",'png']; //可接受的类型
    var maxSize = 2;
    // 设置是否在上传中全局变量
    var isUploading  = false;

    thisObj.change(function(){
        if(!$url){
            tips('请设置要上传的服务端地址');
            return;
        }

        var formData = new FormData();
        var files    = thisObj[0].files;
        var fileObj  = files[0];
        var inputName = thisObj.attr('name');

        if(files){
            // 目前仅支持单图上传
            formData.append(inputName, files[0]);
        }

        var postData = $data;
        if (postData) {
            for (var i in postData) {
                formData.append(i, postData[i]);
            }
        }

        if(!fileObj){
            tips('没有选中文件');
            return;
        }
        var fileName = fileObj.name;
        var fileSize = (fileObj.size)/(1024*1024);

        if (!isAllowFile(fileName, allowType)) {
            tips("图片类型必须是" + allowType.join("，") + "中的一种");
            return;
        }
        if(fileSize > maxSize){
            tips('上传图片不能超过' + maxSize + 'M，当前上传图片的大小为'+fileSize.toFixed(2) + 'M');
            return;
        }

        if(isUploading == true){
            tips('文件正在上传中，请稍候再试！');
            return;
        }

        // 将上传状态设为正在上传中
        isUploading = true;

        $.ajax({
            url: $url,
            type: "post",
            data: formData,
            processData: false,
            contentType: false,
            dataType: 'json',
            success:function(json){
                // 将上传状态设为非上传中
                isUploading = false;
                $fun(json);
            },
            error:function(e){
                console.log(e)
            }
        });
        thisObj.val(''); 
    });
}
/*
* 图片上传方法
*/
function upload($url,$data,$fun,$maxNum){
    $maxNum = $maxNum?$maxNum:1;
    $("#upload-input").ajaxImageUpload({
        url: $url, //上传的服务器地址
        data: $data,
        maxNum: $maxNum, //允许上传图片数量
        zoom: true, //允许上传图片点击放大
        allowType: ["gif", "jpeg", "jpg", "bmp",'png'], //允许上传图片的类型
        maxSize :2, //允许上传图片的最大尺寸，单位M
        before: function () {
            //alert('上传前回调函数');
        },
        success:function(data){
            //alert('上传成功回调函数');
            $fun(data);
        },
        error:function (e) {
            //alert('上传失败回调函数');
            console.log(e);
        }
    });
}
/*
* 是否是允许上传文件格式
*/
function isAllowFile(fileName, allowType){
    var fileExt = this.getFileExt(fileName).toLowerCase();
    if (!allowType) {
        allowType = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
    }
    if ($.inArray(fileExt, allowType) != -1) {
        return true;
    }
    return false;

}
/*
* 获取上传文件的后缀名
*/
function getFileExt(fileName){
    if (!fileName) {
        return '';
    }

    var _index = fileName.lastIndexOf('.');
    if (_index < 1) {
        return '';
    }
    return fileName.substr(_index+1);
}

/*
* 获取URL参数
*/
function UrlSearch(){
    var name,value; 
    var str=location.href; //取得整个地址栏
    var num=str.indexOf("?") 
    str=str.substr(num+1); //取得所有参数   stringvar.substr(start [, length ]
    var arr=str.split("&"); //各个参数放到数组里
    var returnData = [];
    for(var i=0;i < arr.length;i++){
        num=arr[i].indexOf("=");
        if(num>0){ 
            name=arr[i].substring(0,num);
            value=arr[i].substr(num+1);
            returnData[name]=value;
        }
    }
    return returnData;
}
/*
* 获取当前页面文件名
*/
function UrlName(){
    var a = location.href;
    var b = a.split("/");
    var c = b.slice(b.length-1, b.length).toString(String).split(".");
    return c.slice(0, 1)[0];
}

/*
* 获取当前页面文件所处文件model 名字
*/
function UrlModelname(){
    var a = location.href;
    var b = a.split("/");
    var c = b.slice(b.length-2, b.length-1).toString(String).split(".");
    return c[0];
}

//获取当前页面主机部分
function UrlHost(){
    return window.location.host;
}

//跳转方法
function UrlLocation(url){
    if(url){
        window.location.href = url;
    }
}

/*
*获取当前手机
*/
function IsMobile(test){
    var u = navigator.userAgent, app = navigator.appVersion;
    if(/AppleWebKit.*Mobile/i.test(navigator.userAgent) || (/MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/.test(navigator.userAgent))){
            if(window.location.href.indexOf("?mobile")<0){
                try{
                    if(/iPhone|mac|iPod|iPad/i.test(navigator.userAgent)){
                        return '0';
                    }else{
                        return '1';
                    }
                }catch(e){}
            }   
    }else if( u.indexOf('iPad') > -1){
        return '0';
    }else{
        return '1';
    }
}

/*
* 本地localStorage操作--读取
*/
function getStorage($key){
    var storage = window.localStorage;
    return JSON.parse(storage.getItem($key));
}

/*
* 本地localStorage操作--设置
*/
function setStorage($key,$value){
    var storage = window.localStorage;
    return storage.setItem($key,JSON.stringify($value));
}

/*
* 本地localStorage操作--删除
*/
function delStorage($key,$value){
    var storage = window.localStorage;
    return storage.removeItem($key);
}

/*
* 本地localStorage操作--清空全部
*/
function clearAllStorage(){
    var storage = window.localStorage;
    return storage.clear();
}

/*
* 弹出错误提示框
*/
function tips(str,type,hasBtn,clickDomCancel,url){
    type = type?type:'error';
    str = str?str:'正在处理';
    hasBtn = hasBtn?hasBtn:true;
    clickDomCancel = clickDomCancel?clickDomCancel:true;

    new TipBox({type:type,str:str,hasBtn:hasBtn,clickDomCancel:clickDomCancel});
    if(url){
        $('.okoButton').click(function(){
            UrlLocation(url);
        })
    }
}
/**
 * 渲染分页
 * @param $total总条数
 * @param $per_page 一页加载的条数
 * @param $current_page 当前页
 * @param $last_page 最后一页(总页数)
 * @return str
 */
function Page(res,callback){
    var html = '';
    //设置参数
    $total = res.total;
    $per_page = res.per_page;
    $current_page = res.current_page;
    $last_page = res.last_page;

    html += '<ul class="pagination pagination-split">';
    html += '<li class=" ';
    if($current_page <= 1) {
        html += 'disabled';
    }
    html += '"><a ';
    if($current_page <= 1) {
        html += 'disabled';
    }else{
        html += ' class="aft_page" page="'+$current_page+'"';
    }

    html +=' >&laquo;</a></li>';

    //如果总页数超过10页
    if($last_page > 10 && $current_page < 10){
        for (var i = 1; i <= 9; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };
        html += '<li class=""><a>...</a></li>';

        for (var i = ($last_page-4); i <= $last_page; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };
    }else if($last_page > 10  && $current_page >= 10 && $current_page < ($last_page-4)){
        for (var i = 1; i <= 2; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };
        
        html += '<li class=""><a>...</a></li>';

        for (var i = $current_page-9; i <= $current_page; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };
        html += '<li class=""><a>...</a></li>';

        for (var i = ($last_page-4); i <= $last_page; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };

    }else if($last_page > 10  && $current_page >= 10 && $current_page >= ($last_page-4)){

        for (var i = 1; i <= 2; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };
        html += '<li class=""><a>...</a></li>';

        for (var i = ($last_page-9); i <= $last_page; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };

    }else{
        for (var i = 1; i <= $last_page; i++) {
            html += '<li class=" ';
            if(i == $current_page){
                html += 'active';
            }
            html += '"><a  class="page_turning" page="'+i+'">'+i+'</a></li>';
        };
    }
    
    html += '<li class=" ';

    if($current_page >= $last_page) {
        html += 'disabled';
    }

    html +='"><a ';
    if($current_page >= $last_page) {
        html += 'disabled';
    }else{
        html += ' class="next_page" page="'+$current_page+'"';
    }

    html +=' >&raquo;</a></li>';
    html += '</ul>';
    $('#page').html(html);
    callback();
}

//去除字符串最后一位
function getLaststring($str){
    return $str.substring(0,$str.length-1);
}