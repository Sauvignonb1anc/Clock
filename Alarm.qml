import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: false
    width: 500
    height: 300
    title: "闹钟设置"

    Rectangle {
        anchors.fill: parent
        color: "lightgray"

        // 用于显示小时的滚轮
        ListView {
            id: hourListView
            x: 50
            y: 76.5
            width: 100
            height: 150
            model: 24 // 24小时制

            delegate: Item {
                width: hourListView.width
                height: 30 //设置间距

                Text {
                    anchors.centerIn: parent
                    text: index.toString()
                }
            }

            // 设置滚轮的属性
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0 // 初始位置
            preferredHighlightEnd: 24 // 结束位置
        }

        // 用于显示分钟的滚轮
        ListView {
            id: minuteListView
            anchors.centerIn: parent
            width: 100
            height: 150
            model: 60 // 60分钟制

            delegate: Item {
                width: minuteListView.width
                height: 30

                Text {
                    anchors.centerIn: parent
                    text: index.toString()
                }
            }

            // 设置滚轮的属性
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0 // 初始位置
            preferredHighlightEnd: 60 // 结束位置
        }

        // 用于显示秒钟的滚轮
        ListView {
            id: secondListView
            x: 350
            y: 76.5
            width: 100
            height: 150
            model: 60 // 60秒制

            delegate: Item {
                width: secondListView.width
                height: 30

                Text {
                    anchors.centerIn: parent
                    text: index.toString()
                }
            }

            // 设置滚轮的属性
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0 // 初始位置
            preferredHighlightEnd: 60 // 结束位置
        }

        Text {
            x: 50;
            y: 85;
            text: "时钟-->"
            color: "red"
        }

        Text {
            x: 200;
            y: 85;
            text: "分钟-->"
            color: "red"
        }

        Text {
            x: 350;
            y: 85;
            text: "秒钟-->"
            color: "red"
        }

          // 设置按钮
        Button {
            id: button
            anchors.horizontalCenter: parent.horizontalCenter
            text: "设置闹钟"

            onClicked: {
                var selectedHour = hourListView.currentIndex;
                var selectedMinute = minuteListView.currentIndex;
                var selectedSecond = secondListView.currentIndex;

                // 获取当前时间
                var currentTime = new Date();

                // 设置的时间
                var setTime = new Date();
                setTime.setHours(selectedHour, selectedMinute, selectedSecond);

                // 比较当前时间和设置的时间
                if (currentTime.getTime() > setTime.getTime()) {
                    console.log("时间已过期！");
                    failurePopup.open();
                } else {
                    console.log("还未到达设置的时间。");
                    var formattedTime = setTime.getHours() + ":" + setTime.getMinutes() + ":" + setTime.getSeconds();
                    console.log("设置的时间：" + formattedTime);
                    successPopup.open();

                     // 计算距离提醒时间的毫秒数
                    var timeDifference = setTime.getTime() - currentTime.getTime();

                    // 创建定时器，在到达设置的时间时触发
                    var alarmTimer = Qt.createQmlObject('import QtQuick 2.15; Timer { interval: ' + timeDifference + '; onTriggered: alarmPopup.open(); }', button);
                    alarmTimer.start();
                }
            }
        }


        Popup {
            id: successPopup
            anchors.centerIn: parent
            width: 170
            height: 120
            modal: true

            onOpened: {
                // 在弹出窗口打开后更新时间文本
                var selectedHour = hourListView.currentIndex;
                var selectedMinute = minuteListView.currentIndex;
                var selectedSecond = secondListView.currentIndex;

                var setTime = new Date();
                setTime.setHours(selectedHour, selectedMinute, selectedSecond);

                var formattedTime = setTime.getHours() + ":" + setTime.getMinutes() + ":" + setTime.getSeconds();

                timeText.text = "设置的时间：" + formattedTime;
            }
            contentItem: Rectangle {
                color: "green"
                Column {
                    anchors.centerIn: parent
                    Text {
                        font.bold: true
                        font.pointSize: 15
                        text: "闹钟设置成功！"
                    }
                    Text {
                        id: timeText
                        font.pointSize: 12
                    }
                }
            }
        }

        // 显示设置失败的弹窗
        Popup {
            id: failurePopup
            anchors.centerIn: parent
            width: 170
            height: 120
            modal: true
            contentItem: Rectangle {
                color: "red"
                Text {
                    anchors.centerIn: parent
                    fontSizeMode: Text.HorizontalFit // 自动调整水平大小
                    font.pointSize: 8
                    text: "设置失败，请重新选择时间。"
                }
            }
        }



        //到达时间弹窗
        Popup {
            id: alarmPopup
            anchors.centerIn: parent
            width: 170
            height: 120
            modal: true
            onOpened: {
                // 在弹出窗口打开后播放音乐
                musicplayer.play_music("简单爱.mp3")
            }

            onClosed: {
                // 在弹出窗口关闭时停止音频播放
                musicplayer.stop_music()
            }

            contentItem: Rectangle {
                color: "lightblue"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: 8
                    text: "时间到了！"
                    font.bold: true
                }
            }
        }
    }
}