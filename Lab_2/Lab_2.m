clear;
% Вариант 3

%% 1 Синтезировать пустое полутновое изображение.
blankimage = uint8(zeros(800, 800));
% imshow(blankimage);

%% 2 Нанести на изображение шум
noise = im2uint8(imnoise2('exponential', 800, 800, 5));
noiseimage = blankimage + noise;
imshow(noiseimage); pause;

%% 3 Построить гистограмму распределения полученного шума
h = imhist(noiseimage);
h1 = h(1:10:256);
horz = 1:10:256;
bar(horz, h1);
axis([0 255 0 14000]);
set(gca, 'xtick', 0:50:255)
set(gca, 'Ytick', 0:2000:14000)
title('Гистограмма распределения шума');
saveas(gcf, 'hist.png');
pause;

%% 4 Синтез Объекта 1
obj1 = noiseimage;
a = 40;
obj1((round(size(obj1, 1)/2)-a):(round(size(obj1, 1)/2)+a), ...
    (round(size(obj1, 1)/2)-a):(round(size(obj1, 1)/2)+a)) = 255;
% obj1((round(size(obj1, 1)/2)-2*a):(round(size(obj1, 1)/2)+2*a), ...
%     (round(size(obj1, 1)/2)-a):(round(size(obj1, 1)/2)+a)) = 255;
imshow(obj1); pause;
imwrite(obj1, 'obj1.png')

%% 5 Масштабирование изображения
scaledNN = imresize(obj1, 2, 'nearest');
imshow(scaledNN); title('Увелечение в 2 раза (метод ближайшего соседа)'); pause;
imwrite(scaledNN, 'scaledNN.png')
scaledBC = imresize(obj1, 0.5, 'bicubic');
imshow(scaledBC); title('Уменьшение в 2 раза (бикубическая интерполяция)'); pause;
imwrite(scaledBC, 'scaledBC.png')

%% 6 Синтез Объекта 2 и 3
offset = 150;
newnoise = im2uint8(imnoise2('exponential', 800, 800, 5));
% Объект 2
[x, y] = meshgrid(1:size(newnoise, 1), 1:size(newnoise, 2));
center_x = offset;
center_y = offset;
r1 = 40;
b = 0.5;
ellipse = sqrt((x - center_x).^2 + ((y - center_y).^2)/(b^2)) <= r1;
ellipse_perim = bwperim(ellipse, 4);
newnoise(ellipse_perim) = 255;
imshow(newnoise); pause;
% Объект 3
width = 80; 
height = 40; 
side1 = size(newnoise, 1)-offset:size(newnoise, 1)-offset+width;
side2 = size(newnoise, 1)-offset:size(newnoise, 1)-offset+height; 
x_tr = [side1(1), side1(1), side1(width)]; 
y_tr = [side2(1), side2(height), side2(height)]; 
tr = poly2mask(x_tr, y_tr, size(newnoise, 1), size(newnoise, 2));
newnoise(tr) = 255;
imshow(newnoise); pause;

%% 7-8 Зеркаливание
mirroredH = fliplr(newnoise);
imshow(mirroredH); title('Отзеркаливание по горизонтали'); pause;
imwrite(mirroredH, 'mirroredH.png');
mirroredV = flipud(mirroredH);
imshow(mirroredV); title('Отзеркаливание по вертикали'); pause;
imwrite(mirroredV, 'mirroredV.png');

%% 9-10 Повороты на 45°
rotated1 = imrotate(mirroredV, -45);
imshow(rotated1); title('Поворот на 45° по часовой стрелке'); pause;
imwrite(rotated1, 'rotated1.png');
rotated2 = imrotate(rotated1, 45);
imshow(rotated2); title('Поворот на 45° против часовой стрелке'); pause;
imwrite(rotated2, 'rotated2.png');

%% 11 Фон
background = imread("background.png");
imshow(background); title('Фон'); pause;

%% 12 Вырезать участок
cropped_bg = imcrop(background, [0 0 800 800]);
imshow(cropped_bg); title('Вырезанный участок'); pause;

%% 13 Уменьшить яркость в 4 раза
dark_cropped_bg = cropped_bg/4;
imshow(dark_cropped_bg); title('Уменьшенная яркость'); pause;

%% 14 Новое полутновое изображение + 2 объекта + шум
grey_cropped_bg = rgb2gray(dark_cropped_bg);
grey_cropped_bg(tr) = 255;
grey_cropped_bg(ellipse_perim) = 255;
noise = imnoise2('exponential', 800, 800, 5);
grey_cropped_bg = im2double(grey_cropped_bg);
noisyImage = grey_cropped_bg.*noise;
imshow(noisyImage); pause;
imwrite(noisyImage, 'new_grey_image.png')

%% 15 Негатив
negative = imcomplement(noisyImage);
imwrite(negative, 'negative.png');
imshow(negative); pause;

%% 16 Новое полутновое изображение + 1 объекта + шум
grey_cropped_bg2 = rgb2gray(dark_cropped_bg);
grey_cropped_bg2((round(size(obj1, 1)/2)-a):(round(size(obj1, 1)/2)+a), ...
    (round(size(obj1, 1)/2)-a):(round(size(obj1, 1)/2)+a)) = 255;
noise = imnoise2('exponential', 800, 800, 5);
grey_cropped_bg2 = im2double(grey_cropped_bg2);
noisyImage2 = grey_cropped_bg2.*noise;
imshow(noisyImage2); pause;
imwrite(noisyImage2, 'new_grey_image2.png')

%% 17 Разность
diff = imabsdiff(noisyImage, noisyImage2);
imshow(diff);
imwrite(diff, 'diff.png')