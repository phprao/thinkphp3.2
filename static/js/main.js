/** 
 * Created by cxq on 2018/5/15. 
 */
main = function() {
    this.title = '星云游戏 管理后台';//默认标题
    this.basics = new utility;
    this.loadscript = new loadscript; //加载页面文件的js
    this.config = new apiconfig;//加载配置类
    this.localUrl = this.config.localUrl();//本地路由地址
    this.userinfo = null;
    this.hostname = this.basics.UrlName(); //本页的名字
    this.modelname = this.basics.UrlModelname(); //本页的model
    this.menu; //菜单栏
    this.init();
};

main.prototype = {
    //公用基础方法
    init: function() {
        this.isLogin();
        //标记当前页面
        this.markSign();
        this.loadHtml();
        this.titleReset();
    },
    //加载头部，侧边栏，尾部
    loadHtml: function(){
    	$("#header").load('../header.html');
		$("#sidebar").load('../sidebar.html');
		$("#footer").load('../footer.html');
        this.getScriptbyController();
    },
    // 更改title
    titleReset: function(){
    	$("title").html(this.title);
    },
    //获取当前页面的Controller
    getScriptbyController: function(){
    	var _this = this;
    	console.log("当前页面："+ _this.modelname +'/'+ _this.hostname)
        this.loadscript.addTag('script', {src: "../js/bootstrap.min.js?"+_this.loadscript.version },_this.loadscript.sync);
        this.loadscript.addTag('script', {src: "../js/controller/"+_this.hostname+'.js?'+_this.loadscript.version },_this.loadscript.sync);
    },
    //判断有没有登录,无登录就跳转至登录页面
    isLogin: function(){
        this.userinfo = this.basics.getStorage('userinfo');
        //如果有本地玩家信息，则进行跳转
        if(!this.userinfo){
            this.basics.clearAllStorage();
            this.basics.UrlLocation(this.localUrl.login);
        }
    },
    //标记当前页面
    markSign: function(){
        //先获取当前页面的parentid和subid
        var pageId = this.selectMenu();
        this.basics.setStorage('pageId',pageId);
    },
    //搜索页面所属的ID
    selectMenu: function(){
        var _this = this;
        this.menu = this.basics.getStorage('menu');
        var res = {};
        if(this.menu){
            var length = this.menu.length;
            for (var i = 0; i < length; i++) {
                if(_this.modelname == this.menu[i].model){
                    if(this.menu[i].sub){
                        var sublen = this.menu[i].sub.length;
                        for (var j = 0; j < sublen; j++) {
                            if(_this.hostname == this.menu[i].sub[j].action){
                                res.parentid = this.menu[i].sub[j].parentid;
                                res.subid = this.menu[i].sub[j].id;
                            }
                        };
                    }else{
                        if(_this.hostname == this.menu[i].action){
                            res.parentid = this.menu[i].id;
                            res.subid = 0;
                        }
                    }
                }
            };
        }
        return res;
    }
};
_main = new main;

