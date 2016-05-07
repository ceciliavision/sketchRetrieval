function imshowPairData(pairData,ind)

IMGSIZE = 128;

data = pairData(ind, 2:end);
image1 = reshape(data(1:IMGSIZE*IMGSIZE), IMGSIZE, IMGSIZE);
image2 = reshape(data(IMGSIZE*IMGSIZE+1:2*IMGSIZE*IMGSIZE), IMGSIZE, IMGSIZE);
image3 = reshape(data(2*IMGSIZE*IMGSIZE+1:3*IMGSIZE*IMGSIZE), IMGSIZE, IMGSIZE);
image4 = reshape(data(3*IMGSIZE*IMGSIZE+1:4*IMGSIZE*IMGSIZE), IMGSIZE, IMGSIZE);

totalimg = [image1,image2,image3,image4];

figure()
imshow(totalimg)

return