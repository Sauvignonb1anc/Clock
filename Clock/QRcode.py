import qrcode
from PIL import Image
import os
import sys

class QRCodeGenerator:
    def __init__(self, logo_path="OIP.jpg"):
        self.logo_path = logo_path

    def generate_qrcode(self, url):
        qr = qrcode.QRCode(
            version=2,
            error_correction=qrcode.constants.ERROR_CORRECT_H,
            box_size=8,
            border=1,
        )
        qr.add_data(url)
        qr.make(fit=True)
        img = qr.make_image(fill_color='black', back_color='white')
        img = img.convert("RGBA")

        if self.logo_path and os.path.exists(self.logo_path):
            try:
                icon = Image.open(self.logo_path)
                img_w, img_h = img.size
            except Exception as e:
                print(e)
                sys.exit(1)

            factor = 4
            size_w = int(img_w / factor)
            size_h = int(img_h / factor)

            new_logo_size = (70, 70)
            icon = icon.resize(new_logo_size, Image.LANCZOS)
            icon_w, icon_h = icon.size

            if icon_w > size_w:
                icon_w = size_w
            if icon_h > size_h:
                icon_h = size_h

            image = img.resize((10, 10), Image.LANCZOS)

            w = int((img_w - icon_w) / 2)
            w -= 10
            h = int((img_h - icon_h) / 2)
            h -= 10
            icon = icon.convert("RGBA")
            img.paste(icon, (w, h), icon)

        img.save("QRcode.png")


webpage_url = "http://192.168.163.1:8080"  # Replace with your desired webpage URL
qrcode_generator = QRCodeGenerator()
qrcode_generator.generate_qrcode(webpage_url)
