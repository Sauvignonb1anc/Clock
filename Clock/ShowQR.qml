import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: false
    width: 800
    height: 500
    title: "显示二维码"

    Rectangle {
        anchors.fill: parent
        color: "lightgray"

        Image {
            source: "QRcode.png" // 设置图片路径
            anchors.centerIn: parent // 居中显示图片
        }
    }
}
