%% For Testing dataset

sketchImg_test_all = [sketchImg_s;sketchImg_s;sketchImg_s(1:45,:)];
sketchImg_view_all = viewImg_sc;

% test_label = test_all(:,1);
sketch1 = sketchImg_test_all(:,2:end);
view1 = sketchImg_view_all(:,2:end);

NUM_SAMPLE = size(sketchImg_test_all, 1);
NUM_IMG = 128*128;

delete('test.h5')
% 
% h5create('test.h5', '/label', [1,NUM_SAMPLE],'Datatype','uint8');
% h5write('test.h5','/label',test_label');

h5create('test.h5', '/sketch', [NUM_IMG,NUM_SAMPLE],'Datatype','uint8');
h5write('test.h5','/sketch',sketch1');

h5create('test.h5', '/view', [NUM_IMG,NUM_SAMPLE],'Datatype','uint8');
h5write('test.h5','/view',view1');


%% single image data
IMGSIZE = 128;
NUM_IMG = IMGSIZE*IMGSIZE;

a = imread('./manipulate_img/6302.png');
b = imread('./manipulate_img/6302_1.png');
c = imread('./manipulate_img/6302_2.png');
d = imread('./manipulate_img/6302_3.png');
e = imread('./manipulate_img/6302_4.png');

image1 = imresize((a(:,:,1)), [IMGSIZE IMGSIZE]);
image2 = imresize((b(:,:,1)), [IMGSIZE IMGSIZE]);
image3 = imresize((c(:,:,1)), [IMGSIZE IMGSIZE]);
image4 = imresize((d(:,:,1)), [IMGSIZE IMGSIZE]);
image5 = imresize((e(:,:,1)), [IMGSIZE IMGSIZE]);

image_vec1 = reshape(image1, IMGSIZE*IMGSIZE, 1);
image_vec2 = reshape(image2, IMGSIZE*IMGSIZE, 1);
image_vec3 = reshape(image3, IMGSIZE*IMGSIZE, 1);
image_vec4 = reshape(image4, IMGSIZE*IMGSIZE, 1);
image_vec5 = reshape(image5, IMGSIZE*IMGSIZE, 1);

image_mani = [image_vec1';image_vec2';image_vec3';image_vec4';image_vec5'];

NUM_SAMPLE_simple = size(image_mani, 1);
delete('test_mani_face.h5')
h5create('test_mani_face.h5', '/sketch', [NUM_IMG,NUM_SAMPLE_simple],'Datatype','uint8');
h5write('test_mani_face.h5','/sketch',image_mani');
