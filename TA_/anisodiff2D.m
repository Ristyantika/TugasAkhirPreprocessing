function diff_im=anisodiff2D(im, num_iter, delta_t, kappa, option)

%anisotropic diffusion filter
% im: gray scale image
% num_it: number of iterarions
% delta_t: integration constant
% kappa: gradient modulus threshold 
% option: conduction coefficient functions
%        1 - c(x,y,t) = exp(-(nablaI/kappa).^2),
%            privileges high-contrast edges over low-contrast ones. 
%        2 - c(x,y,t) = 1./(1 + (nablaI/kappa).^2),
%            privileges wide regions over smaller ones.

im=double(im);

%initial condition
diff_im = im;

% Center pixel distances
dx = 1;
dy = 1;
dd = sqrt(2);

% 2D convolution masks
hN = [0 1 0; 0 -1 0; 0 0 0];
hS = [0 0 0; 0 -1 0; 0 1 0];
hE = [0 0 0; 0 -1 1; 0 0 0];
hW = [0 0 0; 1 -1 0; 0 0 0];
hNE = [0 0 1; 0 -1 0; 0 0 0];
hSE = [0 0 0; 0 -1 0; 0 0 1];
hSW = [0 0 0; 0 -1 0; 1 0 0];
hNW = [1 0 0; 0 -1 0; 0 0 0];

%diffusion function
for t=1:num_iter
    nablaN=imfilter(diff_im,hN,'conv');
    nablaS = imfilter(diff_im,hS,'conv');   
    nablaW = imfilter(diff_im,hW,'conv');
    nablaE = imfilter(diff_im,hE,'conv');   
    nablaNE = imfilter(diff_im,hNE,'conv');
    nablaSE = imfilter(diff_im,hSE,'conv');   
    nablaSW = imfilter(diff_im,hSW,'conv');
    nablaNW = imfilter(diff_im,hNW,'conv'); 
    
    if option == 1
        cN = exp(-(nablaN/kappa).^2);
        cS = exp(-(nablaS/kappa).^2);
        cW = exp(-(nablaW/kappa).^2);
        cE = exp(-(nablaE/kappa).^2);
        cNE = exp(-(nablaNE/kappa).^2);
        cSE = exp(-(nablaSE/kappa).^2);
        cSW = exp(-(nablaSW/kappa).^2);
        cNW = exp(-(nablaNW/kappa).^2);
    elseif option == 2
        cN = 1./(1 + (nablaN/kappa).^2);
        cS = 1./(1 + (nablaS/kappa).^2);
        cW = 1./(1 + (nablaW/kappa).^2);
        cE = 1./(1 + (nablaE/kappa).^2);
        cNE = 1./(1 + (nablaNE/kappa).^2);
        cSE = 1./(1 + (nablaSE/kappa).^2);
        cSW = 1./(1 + (nablaSW/kappa).^2);
        cNW = 1./(1 + (nablaNW/kappa).^2);
    end
    diff_im = diff_im + ...
              delta_t*(...
              (1/(dy^2))*cN.*nablaN + (1/(dy^2))*cS.*nablaS + ...
              (1/(dx^2))*cW.*nablaW + (1/(dx^2))*cE.*nablaE + ...
              (1/(dd^2))*cNE.*nablaNE + (1/(dd^2))*cSE.*nablaSE + ...
              (1/(dd^2))*cSW.*nablaSW + (1/(dd^2))*cNW.*nablaNW );
end
     
     
     