# **Final Project**  
Topic: KT Gray Image Compression Encoder  
  
Copyright @ K.T. Tu  
  
&emsp;&emsp;The content is for reference and discussion purposes only. Please refrain from copying, plagiarizing, or engaging in any activity related to exchanging benefits.  
&emsp;&emsp;If you have any questions, please feel free to contact me at my email address: ting6452@gmail.com  
  
## Index  
- [Introduction](#Introduction)
- [Principle](#Principle)
- [Architecture](#Architecture)
- [Module Interface Description](#Module-Interface-Description)
- [Acknowledgment](#Acknowledgment)
- [Reference](#Reference)
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
  <em>Symmetric</em>
</p>

&emsp;&emsp;The processing of utilizing symmetric extension at the image edges is performed. Due to the utilization of only the data from the image boundaries during the extension, it does not significantly increase the amount of data. Moreover, since the extended image becomes continuous at the image edges, this method is advantageous for reducing boundary effects.  
### 2. Quantization (Dead-Zone Scalar Quantization)  
<p align="center">
  <img src="Document_img/Dead-Zone Scalar Quantization.png" width="300" />
</p>

&emsp;&emsp;In this operation, we will quantize the data by discarding some bits to achieve data compression.  
### 3. Difference Operation  
<p align="center">
  <img src="Document_img/Difference.png" width="250" />
</p>

&emsp;&emsp;In this operation, we first divide the data processed in the previous steps into four regions: LL, HH, LH, and HL. Then, for each region, we subtract each column of data from its left column and record the difference. This step aims to concentrate the frequency of data occurrence.  
### 4. Data Compression (Huffman Coding)  
<p align="center">
  <img src="Document_img/Huffman codes.png" width="300" />
</p>

<p align="center">
  <img src="Document_img/Huffman Tree.png" width="300" />
</p>

&emsp;&emsp;In this operation, we first divide the data of each pixel into groups of 4 bits and apply Huffman coding to each group individually. As a result, the number of data after this layer will be M times the original. However, due to Huffman coding, the total number of output bits will be fewer than the input.  
&emsp;&emsp;The pre-analysis reveals that the frequencies of data occurrences are mostly the same, so we predefine the format of Huffman coding to reduce complexity and speed up the computational speed of the architecture.  
## Architecture  
### 1. System Architecture  
<p align="center">
  <img src="Document_img/System_Architecture.png" width="600" />
</p>

&emsp;&emsp;a.&emsp;Hardware design, which includes DWT, quantization, difference calculation, and Huffman coding.  
&emsp;&emsp;b.&emsp;Communication protocol, which involves AXI4-Stream and AXI4-Lite.  
&emsp;&emsp;c.&emsp;Software design, which includes reading/writing data from an SD card.  
### 2. Encoder Architecture  
<p align="center">
  <img src="Document_img/Encoder Architecture.png" width="500" />
</p>  

### 3. RTL Design Module  
<p align="center">
  <img src="Document_img/RTL Module.png" width="500" />
</p>  

## Module Interface Description  
### 1. Hardware Core   
<p align="center">
  <img src="Document_img/Hardware_core_interface.png" width="500" />
</p>  

- DWT Module Inputs/Outputs Signals
  
|Signal Name|I/O|Width|Simple Description|  
|  :----:   |:----:|:----:|:----|  
|dwt_pixel    |O|10|輸出經過DWT運算後的值 |  
|h_or_g       |O| 1|表明輸出的值是經過哪種filter，經過h filter則輸出0，經過g filter則輸出1|  
|clk          |I| 1|系統時脈訊號，本系統為同步於時脈正緣之同步設計|  
|rst          |I| 1|低位準”非”同步(active low asynchronous)之系統重置信號|  
|ready        |I| 1|高位準表明輸入的值為有效的|  
|idata        |I|10|輸入灰階圖像像素資料訊號，MSB為資料的signed bit|  
|sp           |I| 4|表明當前硬體的工作時序|  
- DWT_control Module Inputs/Outputs Signals
  
|Signal Name|I/O|Width|Simple Description|  
|  :----:   |:----:|:----:|:----|  
|dwt_pixel    |O|10|輸出經過DWT運算後的值 |  
|oaddr        |O|16|表明輸出訊號(dwt_pixel)的值要儲存的記憶體位置|  
|o_valid      |O| 1|高位準表明輸出訊號(dwt_pixel)的值有效|
|iaddr        |O|16|輸入灰階圖像位址訊號，指示欲索取哪個灰階圖像像素(pixel)資料的位址|  
|mode         |O| 1|表明目前DWT operation是進行甚麼方向的運算，低位準表示進行row processing(horizental)，高位準表示進行column processing(vertical)|  
|end_flag     |O| 1|高位準表明DWT運算結束，可進入下一層運算|  
|clk          |I| 1|系統時脈訊號，本系統為同步於時脈正緣之同步設計|  
|rst          |I| 1|低位準”非”同步(active low asynchronous)之系統重置信號|  
|ready        |I| 1|高位準表明輸入的值為有效的|  
|idata        |I|10|輸入灰階圖像像素資料訊號，MSB為資料的signed bit|  
- compression Module
  
|Signal Name|I/O|Width|Simple Description|  
|  :----:   |:----:|:----:|:----|  
|odata        |O|15|輸出資料經過壓縮後的值 |  
|iaddr        |O|16|輸入經過DWT運算後資料的位址訊號。指示欲索取資料的位址|  
|o_valid      |O| 1|高位準表明輸出訊號(odata)的值有效|  
|end_flag     |O| 1|高位準表明compress運算結束|  
|clk          |I| 1|系統時脈訊號，本系統為同步於時脈正緣之同步設計|  
|rst          |I| 1|低位準”非”同步(active low asynchronous)之系統重置信號|  
|ready        |I| 1|高位準表明輸入的值為有效的|  
|out_stop     |I| 1|高位準表明電路輸出需要暫停|  
|idata        |I|10|輸入資料訊號，MSB為資料的signed bit|  
- blk_mem_gen_0 Module  

|Signal Name|I/O|Width|Simple Description|  
|  :----:   |:----:|:----:|:----|  
|clka         |I| 1|input wire clka|  
|wea          |I| 1|input wire [0 : 0] wea write enable|  
|addra        |I|18|input wire [17 : 0] addra write addr|  
|dina         |I|10|input wire [9 : 0] dina|  
|clkb         |I| 1|input wire clkb|  
|addrb        |I|18|input wire [17 : 0] addrb read addr|  
|doutb        |O|10|output wire [9 : 0] doutb|  

[Hint: blk_mem_gen_0 module為透過Vivado呼叫之IP，詳情可參閱blk_mem_gen_0.veo]
- image_compression Module
  
|Signal Name|I/O|Width|Simple Description|  
|  :----:   |:----:|:----:|:----|  
|odata        |O|15|輸出資料經過壓縮後的值 |  
|in_valid     |O| 1|高位準表明要求索取資料|  
|o_valid      |O| 1|高位準表明輸出訊號(odata)的值有效|  
|end_flag     |O| 1|高位準表明image_compress結束|  
|now_state    |O| 3|將想要觀察的訊號送出，始PS端可透過AXI4-Lite觀察PL端狀態|  
|clk          |I| 1|系統時脈訊號，本系統為同步於時脈正緣之同步設計|  
|rst          |I| 1|低位準”非”同步(active low asynchronous)之系統重置信號|  
|start        |I| 1|高位準PS端要求PL端進入工作狀態|  
|axis_enable  |I| 1|高位準PS端透過AXI4-Stream送入PL端的狀態為有效的|  
|out_stop     |I| 1|高位準表明電路輸出需要暫停|  
|s_axis_data  |I| 8|輸入灰階圖像像素資料訊號，為8bits的無號數|  

### 2. Hardware System  
<p align="center">
  <img src="Document_img/a.png" width="500" />
</p>  

## Acknowledgment  
```
A. NCHU EE Undergraduate           : Chun-Wei Su
B. NCHU EE MSPIC Lab. (611B)       : Kun-Yung Chang
C. NCHU EE ICs & Systems Lab. (612): Hung-Jui Chang, Mo-Hsuan Hsiung, Shun-Liang Yeh and Chun-Yuan Hsiao
D. NCHU EE Lab. 716                : Hsing-Yao Wang and Hsuan-Yu Lin
E. NCHU EE VSIP-IC Lab. (908)      : Wen-Chia Yang
```  

## Reference  
```
[1] Po-Wei Liu, “The Implementation of Image Compression JPEG2000,” M.S. thesis, Dept. Elect. Eng., DYU, Changhua, Taiwan, 2014.
[2] M.Puttaraju, and Dr.A.R.Aswatha “FPGA Implementation of 5/3 Integer DWT for Image Compression” International Journal of Advanced Computer Science and Applications, Vol. 3, No. 10, 2012
[3] G. K. Khan and A. G. Sawant, "Spartan 6 FPGA implementation of 2D-discrete wavelet transform in Verilog HDL," 2016 IEEE International Conference on Advances in Electronics, Communication and Computer Technology (ICAECCT), 2016, pp. 139-143, doi: 10.1109/ICAECCT.2016.7942570
[4] Hardware Design of the Discrete Wavelet Transform: an Analysis of Complexity, Accuracy and Operating Frequency Dora M. Ballesteros L. 1, Diego Renza 2 and Luis Fernando Pedraza 3 Received: 28-04-2016 | Accepted: 21-10-2016 | Online: 18-11-2016 PACS: 84.40.Ua; 07.50.Qx doi:10.17230/ingciencia.12.24.6
[5] https://www.cnblogs.com/chengqi521/p/6732999.html
[6] https://www.cnblogs.com/amxiang/p/16543664.html
[7] https://zhuanlan.zhihu.com/p/608277782
[8] https://blog.csdn.net/weixin_38071135/article/details/118581250
```
