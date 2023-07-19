# **Final Project**  
Topic: KT Gray Image Compression Encoder  
  
Copyright @ K.T. Tu  
  
&emsp;&emsp;The content is for reference and discussion purposes only. Please refrain from copying, plagiarizing, or engaging in any activity related to exchanging benefits.  
&emsp;&emsp;If you have any questions, please feel free to contact me at my email address: ting6452@gmail.com  
  
## Introduction  
&emsp;&emsp;KT Gray Image Compression Architecture combines the specifications of both JPEG and JPEG2000 image compression. This method not only avoids some drawbacks of JPEG, such as mosaic distortion, but also retains several advantages of JPEG2000, such as real-time decoding. Compared to JPEG2000, it boasts lower computational complexity, and is also much more suitable for hardware implementation.  
&emsp;&emsp;In this project, we utilized Zedboard for the hardware implementation of the encoder and then developed the decoder using MATLAB.  
  
## Principle  
### 1. DWT Filter
<p align="center">
  <img src="Document_img/2D DWT Filter.png" width="400" />
</p>

<p align="center">
  <img src="Document_img/2D_DWT_Filter_Formula.png" width="400" />
</p>

&emsp;&emsp;The image is passed through a low-pass filter (Eq1) and a high-pass filter (Eq2) respectively, and then down-sampled to compress the image data.  
<p align="center">
  <img src="Document_img/Symmetric extension scheme for boundary pixels.png" width="700" />
</p>

&emsp;&emsp;The processing of utilizing symmetric extension at the image edges is performed. Due to the utilization of only the data from the image boundaries during the extension, it does not significantly increase the amount of data. Moreover, since the extended image becomes continuous at the image edges, this method is advantageous for reducing boundary effects.  
### 2. Dead-Zone Scalar Quantization  
<p align="center">
  <img src="Document_img/Dead-Zone Scalar Quantization.png" width="300" />
</p>

&emsp;&emsp;In this operation, we will quantize the data by discarding some bits to achieve data compression.  
### 3. Difference Operation  
<p align="center">
  <img src="Document_img/Difference.png" width="250" />
</p>

&emsp;&emsp;In this operation, we first divide the data processed in the previous steps into four regions: LL, HH, LH, and HL. Then, for each region, we subtract each column of data from its left column and record the difference. This step aims to concentrate the frequency of data occurrence.  
### 4. Data Compression  
<p align="center">
  <img src="Document_img/Huffman codes.png" width="300" />
</p>

<p align="center">
  <img src="Document_img/Huffman Tree.png" width="300" />
</p>

&emsp;&emsp;In this operation, we first divide the data of each pixel into groups of 4 bits and apply Huffman coding to each group individually. As a result, the number of data after this layer will be M times the original. However, due to Huffman coding, the total number of output bits will be fewer than the input.  
&emsp;&emsp;The pre-analysis reveals that the frequencies of data occurrences are mostly the same, so we predefine the format of Huffman coding to reduce complexity and speed up the computational speed of the architecture.  
## Architecture  
### 1. System  
<p align="center">
  <img src="Document_img/System Architecture.png" width="600" />
</p>

&emsp;&emsp;a.&emsp;Hardware design, which includes DWT, quantization, difference calculation, and Huffman coding.  
&emsp;&emsp;b.&emsp;Communication protocol, which involves AXI4-Stream and AXI4-Lite.  
&emsp;&emsp;c.&emsp;Software design, which includes reading/writing data from an SD card.  
### 2. Encoder Architecture  
<p align="center">
  <img src="Document_img/Encoder Architecture.png" width="500" />
</p>  

### 3. Design Module  
<p align="center">
  <img src="Document_img/Design Module.png" width="500" />
</p>  
