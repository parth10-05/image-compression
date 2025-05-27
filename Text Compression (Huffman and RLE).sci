clc;
clear;

disp("=== TEXT COMPRESSION TOOL ===");
disp("1. Huffman Coding (better for varied text)");
disp("2. Run-Length Encoding (better for repeated chars)");
choice = input("Choose compression method (1 or 2): ");

text = input("Enter text to compress: ", "string");

function freqTable = buildFrequencyTable(text)
    freqTable = zeros(256, 2);
    for i = 1:256
        freqTable(i, 1) = i - 1;
    end
    for i = 1:length(text)
        charCode = ascii(part(text, i));
        freqTable(charCode + 1, 2) = freqTable(charCode + 1, 2) + 1;
    end
    freqTable = freqTable(find(freqTable(:, 2) > 0), :);
endfunction

function node = createNode(char, freq, left, right)
    node = struct("char", char, "freq", freq, "left", left, "right", right);
endfunction

function huffmanTree = buildHuffmanTree(freqTable)
    heap = list();
    for i = 1:size(freqTable, 1)
        heap($+1) = createNode(freqTable(i, 1), freqTable(i, 2), [], []);
    end
    n = length(heap);
    for i = 1:n-1
        for j = 1:n-i
            if heap(j).freq > heap(j+1).freq then
                temp = heap(j);
                heap(j) = heap(j+1);
                heap(j+1) = temp;
            end
        end
    end
    while length(heap) > 1
        left = heap(1);
        right = heap(2);
        heap(1) = null();
        heap(1) = null();
        mergedNode = createNode(-1, left.freq + right.freq, left, right);
        heap($+1) = mergedNode;
        n = length(heap);
        for i = 1:n-1
            for j = 1:n-i
                if heap(j).freq > heap(j+1).freq then
                    temp = heap(j);
                    heap(j) = heap(j+1);
                    heap(j+1) = temp;
                end
            end
        end
    end
    huffmanTree = heap(1);
endfunction

function codes = generateHuffmanCodes(tree, prefix, codes)
    if nargin < 3 then
        codes = emptystr(256, 1);
    end
    if isempty(tree.left) & isempty(tree.right) then
        codes(tree.char + 1) = prefix;
    else
        if ~isempty(tree.left) then
            codes = generateHuffmanCodes(tree.left, prefix + "0", codes);
        end
        if ~isempty(tree.right) then
            codes = generateHuffmanCodes(tree.right, prefix + "1", codes);
        end
    end
endfunction

function compressed = huffmanCompress(text, codes)
    compressed = "";
    for i = 1:length(text)
        charCode = ascii(part(text, i));
        compressed = compressed + codes(charCode + 1);
    end
endfunction

function decompressed = huffmanDecompress(compressed, tree)
    decompressed = "";
    currentNode = tree;
    for i = 1:length(compressed)
        bit = part(compressed, i);
        if bit == "0" then
            currentNode = currentNode.left;
        else
            currentNode = currentNode.right;
        end
        if isempty(currentNode.left) & isempty(currentNode.right) then
            decompressed = decompressed + ascii(currentNode.char);
            currentNode = tree;
        end
    end
endfunction

function compressed = rleCompress(text)
    compressed = "";
    if length(text) == 0 then
        return;
    end
    currentChar = part(text, 1);
    count = 1;
    for i = 2:length(text)
        if part(text, i) == currentChar then
            count = count + 1;
        else
            if count > 3 then
                compressed = compressed + "[" + string(count) + currentChar + "]";
            else
                compressed = compressed + strcat(repmat(currentChar, 1, count));
            end
            currentChar = part(text, i);
            count = 1;
        end
    end
    if count > 3 then
        compressed = compressed + "[" + string(count) + currentChar + "]";
    else
        compressed = compressed + strcat(repmat(currentChar, 1, count));
    end
endfunction

function decompressed = rleDecompress(compressed)
    decompressed = "";
    i = 1;
    len = length(compressed);
    while i <= len
        currentChar = part(compressed, i);
        if currentChar == "[" then
            closePos = i + 1;
            while closePos <= len & part(compressed, closePos) ~= "]"
                closePos = closePos + 1;
            end
            if closePos > len then
                error("Invalid RLE format: no closing bracket");
            end
            token = part(compressed, i+1:closePos-1);
            numEnd = 0;
            while numEnd < length(token) & strindex("0123456789", part(token, numEnd+1)) ~= []
                numEnd = numEnd + 1;
            end
            if numEnd == 0 then
                error("Invalid RLE format: no count number");
            end
            count = strtod(part(token, 1:numEnd));
            charToRepeat = part(token, numEnd+1:length(token));
            decompressed = decompressed + strcat(repmat(charToRepeat, 1, count));
            i = closePos + 1;
        else
            decompressed = decompressed + currentChar;
            i = i + 1;
        end
    end
endfunction

if choice == 1 then
    disp("=== Using Huffman Coding ===");
    freqTable = buildFrequencyTable(text);
    huffmanTree = buildHuffmanTree(freqTable);
    codes = generateHuffmanCodes(huffmanTree, "");
    compressed = huffmanCompress(text, codes);
    decompressed = huffmanDecompress(compressed, huffmanTree);
    originalBits = length(text) * 8;
    compressedBits = length(compressed);
elseif choice == 2 then
    disp("=== Using Run-Length Encoding ===");
    compressed = rleCompress(text);
    decompressed = rleDecompress(compressed);
    originalBits = length(text) * 8;
    compressedBits = length(compressed) * 8;
else
    error("Invalid choice. Please select 1 or 2.");
end

disp("Original text: " + text);
disp("Compressed: " + compressed);
disp("Decompressed: " + decompressed);

compressionRatio = 100 * (1 - compressedBits/originalBits);
disp("Original size: " + string(originalBits) + " bits");
disp("Compressed size: " + string(compressedBits) + " bits");
disp("Compression ratio: " + string(compressionRatio) + "%");

if text == decompressed then
    disp("✓ Perfect reconstruction (lossless)");
else
    disp("✗ Reconstruction error detected!");
end
