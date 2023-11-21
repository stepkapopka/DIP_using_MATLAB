clear;
% Я не делал выводы изображений на экран для экономии (все изображения и
% так сохраняются в репозиторий)

% 2. Чтение исходного изображения
bogdan = imread('C:\Users\stepa\Desktop\ITMO\DIP\DIP_using_MATLAB\bogdan.jpg');

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
    adr = ['Quantiz/' int2str(i) '.jpg'];
    imwrite(mat2gray(imquantize(bogdan_grey, linspace(0, 255, i+1))), adr);
end

% 13. Вырезание области
adr = 'Crop/cropped_bogdan.jpg';
imwrite(imcrop(bogdan_grey,centerCropWindow2d(size(bogdan_grey),[100 100])), adr);

% 14. Значения соседей
N1 = [bogdan_grey(20,17) ...
    bogdan_grey(22,17) ...
    bogdan_grey(21,18) ...
    bogdan_grey(21,16) ...
    ];
N2 = [bogdan_grey(14,10) ...
    bogdan_grey(16,12) ...
    bogdan_grey(14,12) ...
    bogdan_grey(16,10) ...
    ];
N3 = [bogdan_grey(18,89) ...
    bogdan_grey(19,89) ...
    bogdan_grey(20,89) ...
    bogdan_grey(18,88) ...
    bogdan_grey(20,88) ...
    bogdan_grey(18,87) ...
    bogdan_grey(19,87) ...
    bogdan_grey(20,87) ...
    ];

% 15. Средний уровень яркости
mean_brightness = mean(mean(bogdan_grey));

% 16. Нанесение меток
rectsize = 20;
m(:, :, 1) = imcrop(bogdan_grey, [0 0 rectsize rectsize]);
m(:, :, 2) = imcrop(bogdan_grey, [0 801-rectsize rectsize rectsize]);
m(:, :, 3) = imcrop(bogdan_grey, [801-rectsize 801-rectsize rectsize rectsize]);
m(:, :, 4) = imcrop(bogdan_grey, [801-rectsize 0 rectsize rectsize]);
m(:, :, 5) = imcrop(bogdan_grey,centerCropWindow2d(size(bogdan_grey),[rectsize rectsize]));
marked_bogdan = bogdan_grey;
for i = 1:5
    if mean(mean(m(:, :, i))) < 128
        m(:, :, i) = 255;
    else
        m(:, :, i) = 0;
    end
end
marked_bogdan(1:rectsize, 1:rectsize) = m(:, :, 1);
marked_bogdan(1:rectsize, 801-rectsize:800) = m(:, :, 2);
marked_bogdan(801-rectsize:800, 801-rectsize:800) = m(:, :, 3);
marked_bogdan(801-rectsize:800, 1:rectsize) = m(:, :, 4);
marked_bogdan(((801-rectsize)/2):((800+rectsize)/2), ((801-rectsize)/2):((800+rectsize)/2)) = m(:, :, 5);
imwrite(marked_bogdan, 'Marks\marked_bogdan.jpg');