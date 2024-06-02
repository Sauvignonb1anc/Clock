import sys

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QTimer, QObject, pyqtSignal, pyqtSlot, QUrl
from PyQt5.QtMultimedia import QMediaPlayer, QMediaContent
from QRcode import QRCodeGenerator
import datetime

from time import strftime, localtime

app = QGuiApplication(sys.argv)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.load('main.qml')

class Backend(QObject):
    updated = pyqtSignal(str, arguments=['time'])
    hms = pyqtSignal(int, int, int, arguments=['hours','minutes','seconds'])

    def __init__(self):
        super().__init__()

        # Define timer.
        self.timer = QTimer()
        self.timer.setInterval(100)  # msecs 100 = 1/10th sec
        self.timer.timeout.connect(self.update_time)
        self.timer.start()

    def update_time(self):
        # Pass the current time to QML.
        local_time = localtime()
        curr_time = strftime("%H:%M:%S", localtime())
        self.updated.emit(curr_time)
        self.hms.emit(local_time.tm_hour, local_time.tm_min, local_time.tm_sec)

#音乐播放控制
class MusicPlayer(QObject):
    def __init__(self):
        super().__init__()
        self.player = QMediaPlayer()

    @pyqtSlot(str)
    def play_music(self, file_path):
        """
        播放音乐文件。

        Args:
            file_path (str): 音乐文件的路径。
        """
        media_content = QMediaContent(QUrl.fromLocalFile(file_path))
        self.player.setMedia(media_content)
        self.player.play()

    @pyqtSlot()
    def pause_music(self):
        """暂停音乐播放。"""
        self.player.pause()

    @pyqtSlot()
    def resume_music(self):
        """恢复音乐播放。"""
        self.player.play()

    @pyqtSlot()
    def stop_music(self):
        """停止音乐播放。"""
        self.player.stop()

#将backend传到main.qml中
backend = Backend()

engine.rootObjects()[0].setProperty('backend', backend)

backend.update_time()

#创建二维码
engine3 = QQmlApplicationEngine()
qrcode = QRCodeGenerator()
context3 = engine3.rootContext()
context3.setContextProperty("qrcode", qrcode)

app2 = QGuiApplication(sys.argv)
engine2 = QQmlApplicationEngine()

# 创建Python对象
musicplayer = MusicPlayer()

# 将对象绑定到QML的全局命名空间中
context2 = engine.rootContext()
context2.setContextProperty("musicplayer", musicplayer)

# 加载QML文件（确保 Alarm.qml 存在于相应路径）
qml_url = QUrl.fromLocalFile("Alarm.qml")
engine2.load(qml_url)

sys.exit(app.exec())
sys.exit(app2.exec())