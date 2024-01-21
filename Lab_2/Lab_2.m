clear;
% Вариант 6

%% 1. Синтезировать пустое полутновое изображение.
blankimage = uint8(zeros(800, 800));
% imshow(blankimage);

%% 2. Нанести на изображение шум
noise = im2uint8(imnoise2('uniform', 800, 800));
noiseimage = blankimage + noise;
% imshow(noiseimage);

%% 3. Построить гистограмму распределения полученного шума