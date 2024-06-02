import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 600
    height: 900
    x: (screen.desktopAvailableWidth - width) / 2
    y: (screen.desktopAvailableHeight - height) / 2
    title: "Clock"
    property string currTime: "00:00:00"
    property var hms: {'hours': 0, 'minutes': 0, 'seconds': 0 }
    property var backend: null


    Rectangle {
        anchors.fill: parent

        Image {
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            source: "file:E:/python/work/Clock/background.png"
            fillMode: Image.PreserveAspectCrop
        }

          Image {
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectFit
            source: "file:E:/python/work/Clock/images/clockface.png"
        }


        Rectangle {
            anchors.fill: parent
            color: "transparent"


            Text {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 12
                    left: parent.left
                    leftMargin: 12
                }
                text: currTime
                font.pixelSize: 56
                color: "white"
            }

            Text {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 60
                    left: parent.left
                    leftMargin: 12
                }
                text: Qt.formatDate(new Date(), "yyyy-MM-dd")
                font.pixelSize: 56
                color: "white"
            }

        }

    }

    Image {
        id: clockface
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: "file:E:/python/work/Clock/images/clockface.png"

        Image {
            x: clockface.width/2 - width/2
            y: (clockface.height/2) - height/2
            scale: clockface.width/465
            source: "file:E:/python/work/Clock/images/hour.png"
            //antialiasing: true
            transform: Rotation {
                origin.x: 12.5; origin.y: 166;
                angle: (hms.hours * 30)
            }
        }

        Image {
            x: clockface.width/2 - width/2
            y: clockface.height/2 - height/2
            source: "file:E:/python/work/Clock/images/minute.png"
            scale: clockface.width/465
            //antialiasing: true
            transform: Rotation {
                origin.x: 5.5; origin.y: 201;
                angle: hms.minutes * 6
            }
        }

        Image {
            x: clockface.width/2 - width/2
            y: clockface.height/2 - height/2
            source: "file:E:/python/work/Clock/images/second.png"
            scale: clockface.width/465
            //antialiasing: true
            transform: Rotation {
                origin.x: 2; origin.y: 202;
                angle: hms.seconds * 6
            }
        }

        Image {
            x: clockface.width/2 - width/2
            y: clockface.height/2 - height/2
            source: "file:E:/python/work/Clock/images/cap.png"
            scale: clockface.width/465
        }

    }

    Connections {
        target: backend

        //调用python中的函数
        function onUpdated(msg) {
            currTime = msg
        }

        function onHms(hours, minutes, seconds) {
            hms = {'hours': hours, 'minutes': minutes, 'seconds': seconds}
        }
    }

    Alarm {
        id: alarm
    }

    ShowQR {
        id: qr
    }

    Button {
        width: 100
        height: 50

        text: "设置闹钟"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 130
        anchors.rightMargin: 40

        onClicked: {
            alarm.visible = !alarm.visible
        }
    }

    Button {
        width: 100
        height: 50

        text: "显示二维码"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 50
        anchors.rightMargin: 40

        onClicked: {
            qr.visible = !qr.visible
            qrcode.generate_qrcode()
        }
    }
}
