%% 1. Базовые морфологические операции. 
% Выбрать произвольное изображение, содержащее дефекты формы 
% (внутренние «дырки» или внешние «выступы») объектов. 
% Используя базовые морфологические операции, 
% полностью убрать или минимизировать дефекты
clear;

I = imread('defected_image.png');
I1 = im2bw(I);
% imshow(I1);
square = strel('square', 20);
I2 = imopen(I1, square);
I3 = imclose(I1, square);
I4 = imclose(I2, square);
subplot(2,2,1); imshow(I1); title('Original image');
subplot(2,2,2); imshow(I2); title('Opening');
subplot(2,2,3); imshow(I3);  title('Closing');
subplot(2,2,4); imshow(I4); title('Opening followed by closing'); pause;

% Результат сохранен в файл 'result1.jpg'

%% 2. Разделение объектов.
% Выбрать произвольное бинарное изображение, 
% содержащее перекрывающиеся объекты. 
% 2.1 Использовать операции бинарной морфологии для разделения объектов. 
clear;

I = imread('connected_elements.png');
I1 = im2bw(I);
I2 = ~I1;
subplot(2,2,1); imshow(I2); title('Original image');
% BW2 = imerode(I1, disk);
BW2 = bwmorph(I1, 'erode', 10);
subplot(2,2,2); imshow(BW2); title('Eroded image');
BW2 = bwmorph (BW2, 'thicken', Inf);
subplot(2,2,3); imshow(BW2); title('Thickened objects');
Inew = ~(I1&BW2);
subplot(2,2,4); imshow(Inew); title('Result'); pause;

% Результат сохранен в файл 'result2.1.jpg'

% 2.2 Выделить контуры объектов.
B = strel('disk', 1);
I3 = imdilate(Inew, B);
C = I3 & ~Inew;
subplot(1,1,1); imshow(C); pause;

% Результат сохранен в файл 'result2.2.jpg'

%% 3. Сегментация.
% Выбрать произвольное изображение, 
% содержащее небольшое число локальных минимумов. 
% Выполнить сегментацию изображения по водоразделам.
clear;

rgb = imread ('lemons.png');
A = rgb2gray(rgb);
B = strel ('disk', 100);
C = imerode(A, B);
Cr = imreconstruct (C, A);
Crd = imdilate(Cr, B);
Crdr = imreconstruct (imcomplement (Crd) , imcomplement (Cr));
Crdr = imcomplement (Crdr);
imshow(Crdr); pause;

fgm = imregionalmax(Crdr);
A2 = A;
A2(fgm) = 255;
imshow(A2); pause;

B2 = strel(ones(25, 25));
fgm = imclose(fgm, B2);
fgm = imerode(fgm, B2);
fgm = bwareaopen(fgm, 20);
A3 = A;
A3(fgm) = 255;
imshow(A3); pause;

bw = imbinarize (Crdr);
imshow(bw); pause;
D = bwdist(bw);
L = watershed(D);
bgm = L == 0;
imshow(bgm); pause;

