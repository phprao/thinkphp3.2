loginloadscript = function() {
    this.name = 'loginloadscript';
    this.headEl = document.getElementsByTagName('head')[0];
    this.sync = true;
    this.version = '1.0';
    this.init();
};

loginloadscript.prototype = {
    //公用基础方法
    init: function() {
        this.includeCss();
    },
    //加载css
    includeCss: function(){
        var CssPath = this.CssPath();
        var JsPath = this.JsPath();
        var _this = this;
        for (var i = 0; i < CssPath.length; i++) {
            _this.addTag('link',{ href: CssPath[i]['href']+'?'+ _this.version,rel:CssPath[i]['rel'] },_this.sync);
        };
        for (var i = 0; i < JsPath.length; i++) {
            _this.addTag('script', {src: JsPath[i]['src']+'?'+ _this.version},_this.sync);
        };
    },
    //返回各个css的路径
    CssPath: function(){
        return [
            {'rel': "shortcut icon",'type': "","href": 'images/favicon.ico'},
            {'rel': "stylesheet",'type': "text/css","href": 'css/bootstrap.css'},
            {'rel': "stylesheet",'type': "text/css","href": 'css/simplify.min.css'},
            {'rel': "stylesheet",'type': "text/css","href": 'css/mdialog.css'},
        ];
    },
    //返回各个css的路径
    JsPath: function(){
        return [
            {'src': "js/jquery.min.js"},
            {'src': "js/bootstrap.min.js"},
            {'src': "js/jquery.slimscroll.min.js"},
            {'src': "js/jquery.popupoverlay.min.js"},
            {'src': "js/modernizr.min.js"},
            {'src': "js/simplify/simplify.js"},

            //弹出框插件
            {'src': "js/zepto.min.js"},
            {'src': "js/mdialog.js"},
            //config
            {'src': "js/config/config.js"},
            //basics
            {'src': "js/utility/basics.js"},
            //apiconfig
            {'src': "js/config/apiconfig.js"},
        ];
    },
    //
    addTag: function (name, attributes, sync) {
        var el = document.createElement(name),
            attrName;

        for (attrName in attributes) {
            el.setAttribute(attrName, attributes[attrName]);
        }
        sync ? window.document.write(this.outerHTML(el)) : this.headEl.appendChild(el);
    },
    outerHTML: function(node) {
        // if IE, Chrome take the internal method otherwise build one
        return node.outerHTML || (function (n) {
            var div = document.createElement('div'), h;
            div.appendChild(n);
            h = div.innerHTML;
            div = null;
            return h;
        })(node);
    }
    
};
var _loginloadscript = new loginloadscript;
