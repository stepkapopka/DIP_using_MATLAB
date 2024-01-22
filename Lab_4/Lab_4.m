clear;

%% 1 Фурье спектр
I = imread('portret.png');
imshow(I); pause;
F = fft2(I);
Fc = fftshift(F);
S = log(1+abs(Fc));
imshow(S, []); title('Фурье спектр'); pause;
saveas(gcf, 'F.png')

%% 2 ФНЧ
n = 2;
[x, y] = meshgrid(1:800, 1:800);
D = sqrt((x - 400).^2 + (y - 400).^2);
for D0 = [5 10 50 250]
    H = double(D <= D0);
    FFc = Fc.*H;
    FF = ifftshift(FFc);
    FI = real(ifft2(FF));
    imshow(FI, []); title(['Идеальный ФНЧ (D0 = ', num2str(D0), ')']); pause;
    imwrite(FI, ['Low/Ideal/' num2str(D0) '.png'])
end

for D0 = [5 10 50 250]
    H = 1 ./ (1 + (D ./ D0).^(2*n));
    FFc = Fc.*H;
    FF = ifftshift(FFc);
    FI = real(ifft2(FF));
    imshow(FI, []); title(['Баттерворт ФНЧ (D0 = ', num2str(D0), ')']); pause;
    imwrite(FI, ['Low/Butter/' num2str(D0) '.png'])
end

for D0 = [5 10 50 250]
    H = exp(-(D.^2) ./ (2 * D0^2));
    FFc = Fc.*H;
    FF = ifftshift(FFc);
    FI = real(ifft2(FF));
    imshow(FI, []); title(['Гаус ФНЧ (D0 = ', num2str(D0), ')']); pause;
    imwrite(FI, ['Low/Gaus/' num2str(D0) '.png'])
end

%% 3 ФВЧ
for D0 = [5 10 50 250]
    H = double(D >= D0);
    FFc = Fc.*H;
    FF = ifftshift(FFc);
    FI = real(ifft2(FF));
    imshow(FI, []); title(['Идеальный ФВЧ (D0 = ', num2str(D0), ')']); pause;
    imwrite(FI, ['High/Ideal/' num2str(D0) '.png'])
end

for D0 = [5 10 50 250]
    H = 1 ./ (1 + (D0 ./ D).^(2*n));
    FFc = Fc.*H;
    FF = ifftshift(FFc);
    FI = real(ifft2(FF));
    imshow(FI, []); title(['Баттерворт ФВЧ (D0 = ', num2str(D0), ')']); pause;
    imwrite(FI, ['High/Butter/' num2str(D0) '.png'])
end

for D0 = [5 10 50 250]
    H = 1 - exp(-(D.^2) ./ (2 * D0^2));
    FFc = Fc.*H;
    FF = ifftshift(FFc);
    FI = real(ifft2(FF));
    imshow(FI, []); title(['Гаус ФВЧ (D0 = ', num2str(D0), ')']); pause;
    imwrite(FI, ['High/Gaus/' num2str(D0) '.png'])
end