clear;

% 2. Чтение исходного изображения
bogdan = imread('C:\Users\stepa\Desktop\ITMO\DIP\bogdan.jpg');

% 3. Отображение
% imshow(bogdan); pause;

% 4. Сохранение в формате jpg
imwrite(bogdan, 'bogdan.jpg')

% 5. Сохранение в формате png
imwrite(bogdan, 'bogdan.png')

% 6. Получение информации
jpg_info = imfinfo('bogdan.jpg');
png_info = imfinfo('bogdan.png');

% 7. Вычисление степени сжатия
Ks_jpg = (jpg_info.Width*jpg_info.Height*jpg_info.BitDepth/8)/jpg_info.FileSize;
Ks_png = (png_info.Width*png_info.Height*png_info.BitDepth/8)/png_info.FileSize;

% 8. Преобразование в полутоновое
bogdan_grey = rgb2gray(bogdan);
imwrite(bogdan_grey, 'bogdan_grey.jpg');

% 9. Преобразование в двоичное
for i = [0.25 0.50 0.75]
    adr = ['Logical/' sprintf('%.2f', i) '.jpg'];
    imwrite(imbinarize(bogdan_grey, i), adr);
end

% 10. Разбиение на битовавые плоскости
for i = 1:8
    adr = ['BitPlane/' int2str(i) '.jpg'];
    imwrite(logical(bitget(bogdan_grey, i)), adr);
end

% 11. Дискретизация полутонового изображения
for i = [5 10 20 50]
    adr = ['Discret/' int2str(i) '.jpg'];
    imwrite(mat2gray(blkproc(bogdan_grey, [i i], 'mean2(x)*ones(size(x))')), adr);
end

% 12. Квантование полутонового изображения
for i = [4 16 32 64 128]
    
end


