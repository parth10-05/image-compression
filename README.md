# Compression Algorithms in Scilab

This project contains implementations of **Image Compression** and **Text Compression** using Scilab scripts.

## 📁 Files Included

### 1. `Image Compression.sci`

Implements basic image compression using techniques such as:

* Image matrix manipulation
* Quantization or transformation (based on matrix simplification)
* Grayscale image handling

### 2. `Text Compression (Huffman and RLE).sci`

Implements two common text compression algorithms:

* **Huffman Coding**: Lossless variable-length encoding based on character frequency
* **Run-Length Encoding (RLE)**: Simple lossless encoding of repeated characters

### 3. `sample_image.jpg`

Sample grayscale image used as input for the image compression algorithm.

---

## 🛠 How to Run

1. Open **Scilab**.
2. Load the `.sci` file using:

   ```scilab
   exec('Image Compression.sci', -1);
   exec('Text Compression (Huffman and RLE).sci', -1);
   ```
3. Follow prompts or call functions as defined in the script to execute compression.

> Ensure that `sample_image.jpg` is present in the Scilab working directory for the image compression part.

---

## 🔍 Overview of Methods

### 🖼 Image Compression:

* Works on grayscale image matrices
* Reduces size by matrix transformation
* May include DCT, thresholding, or zeroing small coefficients (depending on implementation)

### 📜 Text Compression:

* **Huffman Coding**:

  * Builds a binary tree from character frequencies
  * Assigns shortest codes to most frequent characters
* **Run-Length Encoding**:

  * Converts repeating sequences like `AAAA` → `A4`

---

## ✅ Applications

* Reducing storage requirements
* Transmission of data over limited bandwidth
* Teaching foundational data compression algorithms in Digital Signal Processing and related domains


