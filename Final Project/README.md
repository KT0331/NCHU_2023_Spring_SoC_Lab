# **Final Project**  
Topic: KT Gray Image Compression Encoder  
  
Copyright @ K.T. Tu  
  
The content is for reference and discussion purposes only. Please refrain from copying, plagiarizing, or engaging in any activity related to exchanging benefits.  
If you have any questions, please feel free to contact me at my email address: ting6452@gmail.com  
  
## Introduction  
  
    KT Gray Image Compression Architecture combines the specifications of both JPEG and JPEG2000 image compression. This method not only avoids some drawbacks of JPEG, such as mosaic distortion, but also retains several advantages of JPEG2000, such as real-time decoding. Compared to JPEG2000, it boasts lower computational complexity, and is also much more suitable for hardware implementation.  
    In this project, we utilized Zedboard for the hardware implementation of the encoder and then developed the decoder using MATLAB.  
  
## Architecture  
  
### 1.DWT Filter
<p align="left">
  <img src="Document_img/2D DWT Filter.png" width="500" />
</p>

<br/>
    將圖像分別通過低頻濾波器(Eq1.)及高頻濾波器(Eq2.)後再進行downsampling以壓縮圖像資料。  
<p align="left">
  <img src="Document_img/Symmetric extension scheme for boundary pixels.png" width="500" />
</p>

<br/>
  在圖像邊緣利用對稱拓展的方式處理，由於拓展時，僅用到圖像邊界 的資料，因此不會增加過多資料量。同時由於拓展後的圖像在圖像邊界處是連續的，因此該方法有利於消除邊界效應。
