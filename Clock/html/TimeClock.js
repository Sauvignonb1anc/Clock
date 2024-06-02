function showTime(clock) {
    var now = new Date();
    var year = now.getFullYear();
    var month = now.getMonth() + 1;
    var day = now.getDate();
    var hour = now.getHours();
    var minu = now.getMinutes();
    var second = now.getSeconds();
    var time = formatTime(year) + "-" + formatTime(month) + "-" + formatTime(day) ;
    var clockTime = formatTime(hour) + ":" + formatTime(minu) + ":" + formatTime(second);

    clock.innerHTML = time + "<br>" + clockTime; // 使用 <br> 换行
}

function formatTime(time) {
    return time < 10 ? "0" + time : time; // 如果小于10，前面补0
}

window.onload = function () {
    var clock = document.getElementById("clock");
    window.setInterval("showTime(clock)", 1000);
}