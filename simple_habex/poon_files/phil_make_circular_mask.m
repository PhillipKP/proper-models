function [mask] = phil_make_circular_mask(size_of_square, radius_size)


[X,Y] = meshgrid((-size_of_square/2+1):1:size_of_square/2);

size(X)
size(Y)

[~,rho] = cart2pol(X,Y);

%figure;
%phil_custom_imagesc(rho < 80,'yo')

%imagesc(rho < radius_size)

mask = zeros(size(rho));

mask( rho < radius_size ) = 1;



end