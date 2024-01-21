clear;
% Вариант 6

%% 1 Портрет и гистограмма
I = rgb2gray(imcrop(imread('pic.png'), [6, 116, 799, 799]));
imwrite(I, 'portret.png');
histogram(I);
saveas(gcf, 'hist.png');
pause;

%% 2 Логарифмическое преобразование
g = log(1 + im2double(I));
imshow(g); title('Логарифмическое преобразование'); pause;
imwrite(g, 'Log/g.png');
histogram(g);
title('Гистограмма');
saveas(gcf, 'Log/hist.png');
pause;

%% 3 Степенное проебразование
for gamma = [0.1 0.45 5]
    g = im2double(I).^gamma;
    imshow(g); title(['gamma = ' sprintf('%.2f', gamma)]); pause;
    imwrite(g, ['Degree/' sprintf('%.2f', gamma) '.png']);
    histogram(g); pause;
    saveas(gcf, ['Degree/hist' sprintf('%.2f', gamma) '.png']);
end

%% 4 Кусочно-линейное преобразование
points = [0, 255; 100, 200; 150, 25; 255, 0];
x = points(:, 1);
y = points(:, 2);
g = zeros(800, 800);
for i = 1:800
    for j = 1:800
        if I(i, j) >= 0 && I(i, j) <= 100
            g(i, j) = ((y(2) - y(1))/(x(2) - x(1))) * double(I(i, j)) + 255;
        elseif I(i, j) > 100 && I(i, j) <= 150
            g(i, j) = ((y(3) - y(2))/(x(3) - x(2))) * double(I(i, j)) + 550;
        elseif I(i, j) > 150 && I(i, j) <= 255
            g(i, j) =((y(4) - y(3))/(x(4) - x(3))) * double(I(i, j)) + 425/7;
        end
    end
end
imshow(uint8(g)); title('Кусочно-линейное преобразование'); pause;
imwrite(uint8(g), 'Line_Contrast/g.png');
histogram(uint8(g)); pause;
saveas(gcf, 'Line_Contrast/hist.png');

%% 5 Эквализация
g = histeq(I);
imshow(g); title('Эквализация'); pause;
imwrite(g, 'Equaliz/g.png');
histogram(g); pause;
saveas(gcf, 'Equaliz/hist.png');

%% 6 Усредняющий фильтр
for size = [3 15 35]
    g = imfilter(I, fspecial('average', size));
    imshow(g); title(['Усредняющий фильтр ' num2str(size)]); pause;
    imwrite(g, ['Filter/average' num2str(size) '.png']);
end

%% 7 Фильтр повышения резкости
g2 = imfilter(im2double(I), fspecial('laplacian', 0));
g = im2double(I) - g2;
imshow(g); title('Фильтр резкости '); pause;
imwrite(g, 'Filter/sharp.png');

%% 8 Медианный фильтр
for size = [3 9 15]
    g = medfilt2(I, [size size]);
    imshow(g); title(['Медианный фильтр ' num2str(size)]); pause;
    imwrite(g, ['Median/' num2str(size) '.png']);
end

%% 9 Выделение границ
g = edge(I, 'roberts');
imshow(g); title('Метод Робертса'); pause;
imwrite(g, 'Edge/roberts.png');
g = edge(I, 'prewitt');
imshow(g); title('Метод Превитта'); pause;
imwrite(g, 'Edge/prewitt.png');
g = edge(I, 'sobel');
imshow(g); title('Метод Собеля'); pause;
imwrite(g, 'Edge/sobel.png');

%% 10 Фильтрация шума
noisy = imnoise(I, 'gaussian', 1/255, 4/255);
imshow(noisy); title('Зашумленное изображение'); pause;
imwrite(noisy, 'Filter/noisy.png');
g1 = imgaussfilt(noisy);
g2 = medfilt2(noisy);
g3 = imfilter(noisy, fspecial('average'));
imshow(g3); title('Отфильтрованное изображение'); pause;
imwrite(g3, 'Filter/denoised.png');
g4 = imbilatfilt(noisy);
N = 800*800;
D = sum((I-((1/N)*sum(I, 'all'))).^2, 'all')/N;
D1 = sum((g1-((1/N)*sum(g1, 'all'))).^2, 'all')/N;
D2 = sum((g2-((1/N)*sum(g2, 'all'))).^2, 'all')/N;
D3 = sum((g3-((1/N)*sum(g3, 'all'))).^2, 'all')/N;
D4 = sum((g4-((1/N)*sum(g4, 'all'))).^2, 'all')/N;