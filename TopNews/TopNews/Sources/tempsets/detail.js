var commontScroller = null,hasShowComment = true;
var nocomment = document.querySelector("#nocomment");
var spliterEl = document.createElement("h6");
    spliterEl.style="margin-top: -1px";
    spliterEl.innerHTML = "|";

function insertAfter(newEl, targetEl) {
    var parentEl = targetEl.parentNode;
    if (parentEl.lastChild == targetEl) {
        parentEl.appendChild(newEl);
    } else {
        parentEl.insertBefore(newEl,targetEl.nextSibling);
    }
}

var boolHaveLocalImg = 0;
function setDetail(result, netType, isOn) {
    if (!result) {return;}
    var id = result.id;
    var article = document.querySelector(".article");
    article.style.display="block";

    var content = document.querySelector("#content");
    var EMPTY_EL = document.createElement("p");
    EMPTY_EL.className = "article-p";

    document.querySelector(".article-h").innerHTML = result.title;
    document.querySelector("#source").innerHTML = result.source ;
    if (result.source && result.source != "") {
        insertAfter(spliterEl, document.querySelector("#source"));
    }

    document.querySelector("#publishTime").innerHTML = getFormatDateByLong(result.publishTime, "dd/MM");
    var imgContextMap = result.imgContextMap ? result.imgContextMap:null;
    if (!imgContextMap || !imgContextMap[0] || netType == -1 || netType == 2) {
        content.appendChild(EMPTY_EL);
    }

    var sections = result.sections;
    for (var i=0;i<sections.length;i++) {
        if (imgContextMap) {
            var list = imgContextMap[i];
            if(list){
                for(var j = 0,size = list.length; j < size ; j++) {
//                    window.webkit.messageHandlers.jsCallImgList.postMessage({body:list[j]});
                    if (jsCallImgList(list[j])) {
                        content.appendChild(getImg(jsGetImgFromLocal(list[j])));
                    }
                    else
                    {
                        switch(netType) {
                            case 1:
                                content.appendChild(getImg(list[j]));
                                break;
                            case -1:
                            case 2:
                                break;
                            case 3:
                            case 4:
                            default:
                                if (isOn) {
                                    var img = getImg("img-recommend-01.jpg");
                                    setImgClick(img,list[j]);
                                    content.appendChild(img);
                                }
                                break;
                        }
                    }
                }
            }
        }

        var p = document.createElement("p");
        p.className = "article-p";
        p.innerHTML = sections[i];
        content.appendChild(p);
    }
    var comments = document.querySelector("#comments");
    comments.style.display="block";
    commontScroller.refresh();
}

function getImg(src) {
    var img = document.createElement("img");
    img.setAttribute("src", src);
    img.className = "article-img";
//    img.onload = function(){
//        commontScroller.refresh();
//    }
    bindImgLoad(img);
    return img;
}

function setImgClick(img, src) {
    img.addEventListener('click', function (event) {
            event.preventDefault();
            img.src = src;
     }, false);
}

function setComment(result) {
    if (!result) {return;}
    nocomment.style.display="none";
    var div = getCommentDiv(result);
    var wrapper = document.querySelector(".comments-wrapper");
    wrapper.insertBefore(div,document.querySelector(".comments-item"));
    commontScroller.refresh();
}

function setComments(result) {
    var loadingContainer = document.querySelector("#loadingContainer");
    loadingContainer.style.display="none";
    if (!result) {return;}
    nocomment.style.display="none";
    for (var i=0;i<result.length;i++) {
        var div = getCommentDiv(result[i]);
        var wrapper = document.querySelector(".comments-wrapper");
        wrapper.appendChild(div);
    }
    commontScroller.refresh();
    
    if (commontScroller.y != 0){
        commontScroller.scrollBy(0,-100,300,IScroll.utils.ease.quadratic);
    }
}

function getCommentDiv(result) {
    var img = document.createElement("img");
    img.setAttribute("src", result.head);

    var userImgDiv = document.createElement("div");
    userImgDiv.className = "user-img";
    userImgDiv.appendChild(img);

    var nameSpan = document.createElement("span");
    nameSpan.className = "user-name";
    nameSpan.innerHTML = result.name;

    var timeSpan = document.createElement("span");
    timeSpan.className = "publish-time";
    timeSpan.innerHTML = getFormatDateByLong(result.commentTime, "dd/MM");

    var header = document.createElement("header");
    header.className = "item-header";
    header.appendChild(userImgDiv);
    header.appendChild(nameSpan);
    header.appendChild(timeSpan);

    var p = document.createElement("p");
    p.className = "comments-content";
    if (result.layers && result.layers.length>0) {
        p.innerHTML = "@" + result.layers[0].name + " : " + result.text;
    } else {
        p.innerHTML = result.text;
    }

    var div = document.createElement("div");
    div.className = "comments-item";
    div.appendChild(header);
    div.appendChild(p);
    div.addEventListener('click', function (event) {
                event.preventDefault();
                         jsCallContentTap();
//                window.jsbridge.reply(result.commentId, result.name);
         }, false);

    return div;
}

function setRecommend(result) {
    if (!result) {
        return;
    }
//    alert("setRecommend!");
    var recommended = document.querySelector(".recommended");
    recommended.style.display="block";
    for (var i=0;i<result.length;i++) {
        switch (result[i].imgType) {
            case 0:
                recommended.appendChild(getTextItem(result[i]));
            break;
            case 3:
                recommended.appendChild(getThreeImagesItem(result[i]));
            break;
            default:
                recommended.appendChild(getOneImageItem(result[i]));
            break;
        }
    }
    commontScroller.refresh();
}

function getTextItem(item) {
    var article = document.createElement("article");
    article.className = "rec-article";

    var title = document.createElement("h1");
    title.className = "rec-h";
    title.innerHTML = item.title;
    article.appendChild(title);
    article.appendChild(getFooter(item));
    setRecommendClick(article, item);
    return article;
}

function getOneImageItem(item) {
    var article = document.createElement("article");
    article.className = "rec-article";

    var title = document.createElement("h1");
    title.className = "rec-h-recommend";
    title.innerHTML = item.title;
    article.appendChild(title);

    var img1 = document.createElement("img");
    img1.setAttribute("src", item.imgUrls[0]);
    img1.className = "rec-img-recommend";
    article.appendChild(img1);
    bindImgLoad(img);
    article.appendChild(getFooter(item));
    setRecommendClick(article, item);
    return article;
}

function bindImgLoad(img){
    if(!img) return;
    img.onload = function(){
        commontScroller.refresh();
    };
}

function getThreeImagesItem(item) {
    var article = document.createElement("article");
    article.className = "rec-article";

    var title = document.createElement("h1");
    title.className = "rec-h";
    title.innerHTML = item.title;
    article.appendChild(title);

    var img1 = document.createElement("img");
    img1.setAttribute("src", item.imgUrls[0]);
    img1.className = "rec-img";
    article.appendChild(img1);
    bindImgLoad(img1);

    var img2 = document.createElement("img");
    img2.setAttribute("src", item.imgUrls[1]);
    img2.className = "rec-img";
    article.appendChild(img2);
    bindImgLoad(img2);

    var img3 = document.createElement("img");
    img3.setAttribute("src", item.imgUrls[2]);
    img3.className = "rec-img";
    article.appendChild(img3);
    bindImgLoad(img);
    article.appendChild(getFooter(item));
    setRecommendClick(article, item);
    return article;
}

function getFooter(item) {
    var footer = document.createElement("footer");
    var source = document.createElement("h6");
    source.innerHTML = item.source;
    footer.appendChild(source);
    if (item.source && item.source != "") {
        footer.appendChild(spliterEl.cloneNode(true));
    }
    var publishTime = document.createElement("h6");
    publishTime.innerHTML = getFormatDateByLong(item.publishTime, "dd/MM");
    footer.appendChild(publishTime);
    return footer;
}

function setRecommendClick(article, item) {
    article.addEventListener('click', function (event) {
                             event.preventDefault();
                             jsCallToRecommendDetail(item);
//            window.jsbridge.toRecommendDetail(item.id, item.recId, item.recSource, item.channel);
    }, false);
}

//扩展Date的format方法
Date.prototype.format = function (format) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    }
    if (/(y+)/.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
}

function getFormatDate(date, pattern) {
    if (date == undefined) {
        date = new Date();
    }
    if (pattern == undefined) {
        pattern = "yyyy-MM-dd hh:mm:ss";
    }
    return date.format(pattern);
}

/**
 *转换long值为日期字符串
 * @param l long值
 * @param pattern 格式字符串,例如：yyyy-MM-dd hh:mm:ss
 * @return 符合要求的日期字符串
 */
function getFormatDateByLong(l, pattern) {
    return getFormatDate(new Date(l), pattern);
}


function scollCreat() {
    commontScroller = new IScroll("#wrapper",{
                                  //preventDefault:true,
                                  probeType:2,
                                  bounceTime:200,
                                  scrollbars: true,
                                  mouseWheel: true,
                                  interactiveScrollbars: true,
                                  shrinkScrollbars: 'scale',
                                  fadeScrollbars: true
                                  //click:true
                    });
    
    commontScroller.on("scroll",function () {
        var _y = Math.abs(this.y);
        var maxY = Math.abs(this.maxScrollY);
        if((_y > (maxY + 50)) && hasShowComment){
            document.getElementById("loadingContainer").style.display = "block";
        }                       
                       jsCallContentTap();
    });

    commontScroller.on("scrollEnd",function () {
        if(Math.abs(this.y)== Math.abs(this.maxScrollY) &&
            document.getElementById("loadingContainer").style.display == "block" && hasShowComment){
            window.clearTimeout(commontScroller._timer);
            commontScroller._timer = setTimeout(function() {
                                                jsCallGetComments();
                                                
//                window.jsbridge.getComments();
            }, 500);
        }
    });
    
    
    //bind close input
    var nodes = document.querySelectorAll(".input");
    if(!nodes || nodes.length == 0) return;
    for(var i = 0 ; i < nodes.length; i ++){
        nodes[i].addEventListener('click',function (event) {
                                  event.preventDefault();
                                  jsCallContentTap();
                        });
    }
}


function commentTop(time) {
    if(arguments.length == 0){
        time = 300;
    } else if (arguments.length == 1){
        var arg = arguments[0];
        if(typeof arg == "number") {
            time = arg;
        } else if (typeof arg == "string"){
            time = 300;
            commontScroller.scrollToElement(document.getElementById(arg),time,null,0,IScroll.utils.ease.quadratic);
            return;
        }
    } else if (arguments.length == 2){
        time = arguments[0];
        var id = arguments[1];
        commontScroller.scrollToElement(document.getElementById(id),time,null,0,IScroll.utils.ease.quadratic);
        return;
    }

    if (commontScroller.y >= 0) {
        commontScroller.scrollToElement(document.getElementById("comments"),time,null,0,IScroll.utils.ease.quadratic);
    }
    else {
        commontScroller.scrollToElement(document.getElementById("title"),time,null,0,IScroll.utils.ease.quadratic);
    }
}
